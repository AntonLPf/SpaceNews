//
//  Persistence.swift
//  SpaceNewsApp
//
//  Created by Skep Tic on 27.10.2021.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for i in 0..<AppConstants.appNewsLimit {
            let newItem = NewsItem(context: viewContext)
            newItem.id = Int64(i)
            newItem.title = "NASA’s SLS (Space Launch System) program is preparing to serve. id: \(i)"
            newItem.publishedAt = Date()
            newItem.imageUrl = URL(string: "https://spaceflightnow.com/wp-content/uploads/2021/10/KSC-20211020-PH-FMX01_0256large.jpg")
            newItem.summary = "NASA’s SLS (Space Launch System) program is preparing to serve its role in the agency’s first human spaceflight mission to the moon in nearly 50 years–Artemis 1. After completing a DCR (Design Certification Review) in late September, the program engineering groups are now organizing the data to certify SLS’s initial configuration for flight in a few months’ time."
            newItem.newsSite = "Spaceflight Now"
            newItem.url = URL(string: "https://spaceflightnow.com/2021/10/22/nasa-targets-february-launch-for-artemis-1-moon-mission/")
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SpaceNewsApp")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
