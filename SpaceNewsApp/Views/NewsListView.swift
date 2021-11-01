//
//  NewsListView.swift
//  SpaceNewsApp
//
//  Created by Skep Tic on 27.10.2021.
//

import SwiftUI
import CoreData

struct NewsListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var newsManager: NewsManager

    @FetchRequest(
        entity: NewsItem.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \NewsItem.id, ascending: false)],
        animation: .default
    ) private var items: FetchedResults<NewsItem>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { newsItem in
                    NavigationLink {
                        NewsDetailView(newsItem: newsItem, newsManager: newsManager)
                    } label: {
                        LazyVStack(alignment: .leading) {
                            row(for: newsItem)
                        }
                    }
                    .onAppear {
                        Task {
                            await loadImage(for: newsItem, in: viewContext)
                        }
                    }
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Space News")
        }
        .refreshable { updateNewsList() }
        .onAppear { updateNewsList() }
        
    }
    
    func row(for newsItem: NewsItem) -> some View {
        return Group {
            Text(newsItem.title ?? "")
                .padding(.bottom)
            VStack(alignment: .leading, spacing: 3) {
                Text(newsItem.newsSite ?? "")
                Text(newsItem.publishedAtString)
            }
            .font(.caption)
        }
    }
    
    func updateNewsList() {
        Task { await newsManager.getFreshNews(from: viewContext) }
    }
    
    func loadImage(for newsItem: NewsItem, in context: NSManagedObjectContext) async {
        if let imageData = await newsManager.loadImage(for: newsItem), newsItem.image == nil {
            newsManager.saveImageData(imageData, for: newsItem, in: viewContext)
        }
    }
}

struct NewwsListView_Previews: PreviewProvider {
    static let context = PersistenceController.preview.container.viewContext
    static var previews: some View {
        NewsListView(newsManager: NewsManager())
            .environment(\.managedObjectContext, context)
    }
}
