//
//  NewsLoaderError.swift
//  SpaceNewsApp
//
//  Created by Skep Tic on 29.10.2021.
//

import Foundation

enum NewsLoaderError: String, Error {
    case invalidRequestUrl          = "Invalid request url"
    case invalidResponse            = "Invalid response from the server"
    case parsingError               = "Coldn't parse recieveddata"
    case badimageDataUrl            = "Invalid URL to image data"
    case urlSessionError            = "Error during connection with a server"
    
}
