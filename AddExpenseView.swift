//
//  AddExpenseView.swift
//  budgetapp
//
//  Created by Joshua Fitzerald on 10/26/24.
//

import SwiftUI
import CoreData

struct AddExpenseView: View {
    @Environment(\.managedObjectContext) private var viewContext // Inject Core Data context

    @State private var amount = ""
    @State private var category = ""
    @State private var date = Date()

    var body: some View {
        Form {
            Section(header: Text("Amount")) {
                TextField("Amount", text: $amount)
                    
            }

            Section(header: Text("Category")) {
                TextField("Category", text: $category)
            }

            Section(header: Text("Date")) {
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }

            Button("Save Expense") {
                let newExpense = NSEntityDescription.insertNewObject(forEntityName: "Expense", into: viewContext)
                newExpense.setValue(amount, forKey: "amount") // assuming amount is String
                newExpense.setValue(category, forKey: "category")
                newExpense.setValue(date, forKey: "date")


                do {
                    try viewContext.save()
                } catch {
                    print("Error saving expense: \(error)")
                }
            }
        }
        .navigationTitle("Add Expense")
    }
}

