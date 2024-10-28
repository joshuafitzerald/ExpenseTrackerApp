//
//  budgetappApp.swift
//  budgetapp
//
//  Created by Joshua Fitzerald on 10/26/24.
//

import SwiftUI
import CoreData

@main
struct budgetappApp: App {
    // Set up the Core Data persistence controller
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

// PersistenceController for Core Data setup

struct PersistenceController {
    static let shared = PersistenceController()

    // Preview setup for in-memory store to support SwiftUI previews
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        // Optional: Add sample data here for previewing content
        return controller
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "budgetapp") // Ensure this matches your Core Data model file name
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}



