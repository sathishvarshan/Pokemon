//
//  pokemonApp.swift
//  pokemon
//
//  Created by Sathish  on 19/11/25.
//

import SwiftUI
import SwiftData

@main
struct pokemonApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @AppStorage("userlogin") private var isLoggedIn: Bool = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn{
                HomeView()
            }else{
                LoginView()
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
