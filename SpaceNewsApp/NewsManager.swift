//
//  NewsManager.swift
//  SpaceNewsApp
//
//  Created by Skep Tic on 27.10.2021.
//

import CoreData
import SwiftUI

class NewsManager: ObservableObject {
    
    private let newsLoaderService: NewsLoaderService
    
    init(newsLoaderService: NewsLoaderService = NewsLoaderService.shared) {
        self.newsLoaderService = newsLoaderService
    }
    
    func getFreshNews(from context: NSManagedObjectContext) async {
        await getNews(with: context)
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Data saving error during getting news : \(error)")
            }
        }
    }
    
    func loadImage(for newsItem: NewsItem) async -> Data? {
        guard newsItem.image == nil else { return nil }
        
        do {
            if let data = try await NewsLoaderService.shared.loadImage(for: newsItem) {
                return data
            }
        } catch {
            print("Error during loading image for the news id: \(newsItem.id). \(error)")
        }
        return nil
    }
    
    
    private func getNews(with context: NSManagedObjectContext) async {
        let loader = NewsLoaderService.shared
        let parser = DataParsingService.shared
        do {
            let data = try await loader.fetchNewsRawData()
            guard let decodedRawData: Set<RawNewsItem> = parser.parseData(data) else {
                fatalError()// TODO: resolve
            }
            for item in decodedRawData {
                if isFresh(item, in: context) {
                    // create new item
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
                    
                    let newNewsItem = NewsItem(context: context)
                    newNewsItem.id = item.id
                    newNewsItem.title = item.title
                    newNewsItem.summary = item.summary
                    newNewsItem.imageUrl = item.imageUrl
                    newNewsItem.publishedAt = dateFormatter.date(from: item.publishedAt)
                    newNewsItem.newsSite = item.newsSite
                    newNewsItem.url = item.url
                }
            }
            try context.save()
        } catch NewsLoaderError.invalidRequestUrl {
            print("Invalid request url")
        } catch NewsLoaderError.invalidResponse {
            print("Invalid response from the server")
        } catch {
            print("Unresolved error: \(error)")
        }
    }
    
    
    func saveImageData(_ imageData: Data, for newsItem: NewsItem, in context: NSManagedObjectContext) {
        guard let newsToBeUpdated = fetchNewsItemFromStoreForImageSaving(newsItem, in: context) else { return }
        newsToBeUpdated.image = imageData
        do {
            try context.save()
        } catch {
            print("Error during image news saving. \(error)")
        }
    }
    
    private func isFresh(_ newsItem: RawNewsItem, in context: NSManagedObjectContext) -> Bool {
        let fetchRequest = Self.fetchRequest(NSPredicate(format: "id = %@", String(newsItem.id)))
        do {
            let fetchResult = try context.fetch(fetchRequest)
            if fetchResult.isEmpty {
                print("News id \(newsItem.id) is new. For saving...")
                return true
            }
        } catch {
            print("Error during news freshness checking: \(error)")
        }
        return false
    }
    
    private func fetchNewsItemFromStoreForImageSaving(_ newsItem: NewsItem, in context: NSManagedObjectContext) -> NewsItem? {
        let fetchRequest = Self.fetchRequest(NSPredicate(format: "id = %@", String(newsItem.id)))
        do {
            let results = try context.fetch(fetchRequest)
            if let item = results.first {
                return item
            }
        } catch {
            print("Error during fetching news item for saving image. \(error)")
        }
        return nil
    }
    
    
    
    static func fetchRequest(_ predicate: NSPredicate) -> NSFetchRequest<NewsItem> {
        let request = NSFetchRequest<NewsItem>(entityName: "NewsItem")
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        request.predicate = predicate
        return request
    }
    
}
