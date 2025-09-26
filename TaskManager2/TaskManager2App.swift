//
//  TaskManager2App.swift
//  TaskManager2
//
//  Created by arefdeveloper on 24/09/25.
//

import SwiftUI
import CoreData

@main
struct TaskManager2App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
