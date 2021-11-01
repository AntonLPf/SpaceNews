//
//  NewsLoaderError.swift
//  SpaceNewsApp
//
//  Created by Skep Tic on 29.10.2021.
//

import Foundation

enum NewsLoaderError: Error {
    case invalidRequestUrl
    case invalidResponse
    case badimageDataUrl
    case urlSessionError
    
}
