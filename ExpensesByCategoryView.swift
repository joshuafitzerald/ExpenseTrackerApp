//
//  ExpensesByCategoryView.swift
//  budgetapp
//
//  Created by Joshua Fitzerald on 10/27/24.
//

import SwiftUI

struct ExpensesByCategoryView: View {
    let categoryTotals: [String: Double]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Expenses by Category")
                .font(.headline)
                .padding(.bottom, 5)
            
            ForEach(categoryTotals.keys.sorted(), id: \.self) { category in
                HStack {
                    Text(category)
                    Spacer()
                    Text(String(format: "$%.2f", categoryTotals[category] ?? 0))
                }
                .padding(.vertical, 2)
            }
        }
        .padding()
    }
}

struct ExpensesByCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesByCategoryView(categoryTotals: ["Food": 120.0, "Transport": 75.5, "Entertainment": 50.0])
    }
}
