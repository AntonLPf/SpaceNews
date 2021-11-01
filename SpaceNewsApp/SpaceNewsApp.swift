//
//  SpaceNewsAppApp.swift
//  SpaceNewsApp
//
//  Created by Skep Tic on 27.10.2021.
//

import SwiftUI

@main
struct SpaceNewsApp: App {
    
    let persistenceController = PersistenceController()
    @StateObject var newsManager = NewsManager()
    
    var body: some Scene {
        WindowGroup {
            NewsListView(newsManager: newsManager)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

struct AppConstants {
    // The number of recent news that user can read. Particular project constraint.
    // Can be changed to ability of resieving and handling unlimited numbers of news in a future
    static let appNewsLimit = 30
}
