//
//  RawNewsItem.swift
//  SpaceNewsApp
//
//  Created by Skep Tic on 29.10.2021.
//

import Foundation

struct RawNewsItem: Decodable, Hashable, Equatable {
    let id: Int64
    let title: String
    let summary: String
    let publishedAt: String
    let imageUrl: URL
    let newsSite: String
    let url: URL
}
