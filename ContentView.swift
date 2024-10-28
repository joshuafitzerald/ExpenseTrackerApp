//
//  ContentView.swift
//  budgetapp
//
//  Created by Joshua Fitzerald on 10/26/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Expense.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Expense.date, ascending: true)]
    ) var expenses: FetchedResults<Expense>

    var body: some View {
        NavigationView {
            VStack {
                // Display total expenses
                Text("Total Expenses: \(calculateTotalExpenses())")
                    .font(.title)
                    .padding()

                // Display monthly and weekly expenses
                Text("This Month: \(String(format: "$%.2f", calculateMonthlyExpenses()))")
                    .font(.subheadline)
                    .padding(.top, 5)

                Text("This Week: \(String(format: "$%.2f", calculateWeeklyExpenses()))")
                    .font(.subheadline)
                    .padding(.bottom, 5)

                // Category breakdown
                ExpensesByCategoryView(categoryTotals: calculateExpensesByCategory())
                    .padding(.vertical)

                // List of all expenses with delete functionality
                List {
                    ForEach(expenses) { expense in
                        VStack(alignment: .leading) {
                            Text(expense.category ?? "Unknown Category")
                                .font(.headline)
                            Text("Amount: \(expense.amount ?? "0")") // Assuming amount is a String
                            Text("Date: \(expense.date ?? Date(), formatter: dateFormatter)")
                        }
                    }
                    .onDelete(perform: deleteExpense)
                }

                // Navigation to Add Expense View
                NavigationLink(destination: AddExpenseView()) {
                    Text("Add Expense")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("Dashboard")
        }
    }

    // Calculate total expenses function
    func calculateTotalExpenses() -> String {
        let total = expenses.reduce(0) { sum, expense in
            sum + (Double(expense.amount ?? "0") ?? 0)
        }
        return String(format: "%.2f", total)
    }

    // Calculate monthly expenses
    func calculateMonthlyExpenses() -> Double {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        let monthlyTotal = expenses.reduce(0) { sum, expense in
            let expenseMonth = Calendar.current.component(.month, from: expense.date ?? Date())
            let expenseYear = Calendar.current.component(.year, from: expense.date ?? Date())
            return (expenseMonth == currentMonth && expenseYear == currentYear) ? sum + (Double(expense.amount ?? "0") ?? 0) : sum
        }
        return monthlyTotal
    }

    // Calculate weekly expenses
    func calculateWeeklyExpenses() -> Double {
        let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) ?? Date()
        let weeklyTotal = expenses.reduce(0) { sum, expense in
            if let expenseDate = expense.date, expenseDate >= startOfWeek {
                return sum + (Double(expense.amount ?? "0") ?? 0)
            }
            return sum
        }
        return weeklyTotal
    }

    // Calculate expenses by category
    func calculateExpensesByCategory() -> [String: Double] {
        var categoryTotals: [String: Double] = [:]
        for expense in expenses {
            let category = expense.category ?? "Unknown"
            let amount = Double(expense.amount ?? "0") ?? 0
            categoryTotals[category, default: 0] += amount
        }
        return categoryTotals
    }

    // Delete expense function
    private func deleteExpense(at offsets: IndexSet) {
        offsets.map { expenses[$0] }.forEach(viewContext.delete)
        do {
            try viewContext.save()
        } catch {
            print("Error deleting expense: \(error)")
        }
    }
}

// Date formatter for displaying dates
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()


#Preview {
    ContentView()
}
