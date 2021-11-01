//
//  NewsLoaderService.swift
//  SpaceNewsApp
//
//  Created by Skep Tic on 27.10.2021.
//

import Foundation
import SwiftUI

protocol NewsLoaderServiceProtocol {
    func fetchNewsRawData() async throws -> Data
    func loadImage(for newsItem: NewsItem) async throws -> Data?
}

struct NewsLoaderService: NewsLoaderServiceProtocol {
    
    static let shared = NewsLoaderService()
    
    private let baseURL = "https://api.spaceflightnewsapi.net/v3/"
    
    func fetchNewsRawData() async throws -> Data {
        let endpoint = baseURL + "articles?_limit=\(AppConstants.appNewsLimit)&_sort=publishedAt%3ADESC"
        guard let url = URL(string: endpoint) else { throw NewsLoaderError.invalidRequestUrl }
        let dataRequest = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.data(for: dataRequest)
            let serverResponse = response as? HTTPURLResponse
            guard serverResponse?.statusCode == 200 else { throw NewsLoaderError.invalidResponse } // TODO: test
            print("News data recieved from the server")
            return data
        } catch {
            throw NewsLoaderError.urlSessionError
        }
    }
    
    func loadImage(for newsItem: NewsItem) async throws -> Data? {
        guard let url = newsItem.imageUrl else { throw NewsLoaderError.badimageDataUrl } // TODO: test
        let dataRequest = URLRequest(url: url)
        do {
            let (data, response) = try await URLSession.shared.data(for: dataRequest)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                throw NewsLoaderError.invalidResponse
            }
            //checking that Data is convertable to image
            if UIImage(data: data) != nil {
                print("image loaded")
                return data
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
