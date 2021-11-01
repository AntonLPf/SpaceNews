//
//  DataParsingService.swift
//  SpaceNewsApp
//
//  Created by Skep Tic on 29.10.2021.
//

import Foundation

struct DataParsingService {
    
    static let shared = DataParsingService()
    
    func parseData<Entity: Decodable>(_ data: Data) -> Set<Entity>? {
        do {
            let decodedData = try JSONDecoder().decode(Set<Entity>.self, from: data)
            print("Decoding data complete")
            return decodedData
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
        return nil
    }
    
}
