//
//  NewsDetailView.swift
//  SpaceNewsApp
//
//  Created by Skep Tic on 28.10.2021.
//

import SwiftUI
import CoreData

struct NewsDetailView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var newsItem: NewsItem
    @ObservedObject var newsManager: NewsManager

    var body: some View {
        ScrollView {
            if let imageData = newsItem.image, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200, alignment: .center)
                    .clipped()
            } else {
                ZStack {
                    Color.clear
                        .frame(height: 200)
                    ProgressView()
                }
            }
            VStack(alignment: .leading) {
                Text(newsItem.title ?? "")
                    .font(.title)
                    .padding(.bottom, 2.0)
                if let newsSite = newsItem.newsSite, let url = newsItem.url {
                    Link(newsSite, destination: url)
                }
                Text(newsItem.publishedAtString)
                    .font(.caption)
                    .padding(.bottom)
                Text(newsItem.summary ?? "")
            }
            .padding()
        }
    }
}
