//
//  NewsItem.swift
//  SpaceNewsApp
//
//  Created by Skep Tic on 28.10.2021.
//

import Foundation

extension NewsItem {
    
    var publishedAtString: String {
        guard let date = self.publishedAt else { return "" }
        return itemFormatter.string(from: date)
    }
    
}



private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
    formatter.locale = .current
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
