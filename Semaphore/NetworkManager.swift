//
//  NetworkManager.swift
//  Simaphore
//
//  Created by Amr Omran on 04/25/2019.
//  Copyright © 2019 Amr Omran. All rights reserved.
//

import Foundation
import UIKit

typealias Query = [URLQueryItem]

enum NetworkError: Error {
    case badURL
    case statusCode(Int)
    case dataNotFound
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func getRequest<T>(urlString: String, query: Query? = nil) throws -> T? where T: Codable {
        guard let url = URL(string: urlString) else {
            throw NetworkError.badURL
        }
        
        var component = URLComponents(url: url, resolvingAgainstBaseURL: true)
        if let queries = query {
            component?.queryItems = queries
        }
        
        guard let finalURL = component?.url else {
            throw NetworkError.badURL
        }
        
        var jsonData: T?
        var returnedResponse: URLResponse?
        let jsonDecoder = JSONDecoder()
        let semaphore = DispatchSemaphore(value: 0)
        
        let session = URLSession.shared
        let task = session.dataTask(with: finalURL) { (data, response, error) in
            
            guard let data = data else {
                print("Network Error", #file, #line)
                return
            }
            
            do {
                let json = try jsonDecoder.decode(T.self, from: data)
                jsonData = json
            } catch let error {
                print("Network Error: \(error)", #file, #line)
                return
            }
            
            guard let response = response else {
                print("Network Error", #file, #line)
                return
            }
            returnedResponse = response
            
            semaphore.signal()
        }
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        if let response = returnedResponse as? HTTPURLResponse, response.statusCode > 210 {
            throw NetworkError.statusCode(response.statusCode)
        }
        
        return jsonData
    }
    
    
    func getRequestArray<T>(urlString: String, query: Query? = nil) throws -> [T]? where T: Codable {
        guard let url = URL(string: urlString) else {
            throw NetworkError.badURL
        }
        
        var component = URLComponents(url: url, resolvingAgainstBaseURL: true)
        if let queries = query {
            component?.queryItems = queries
        }
        
        guard let finalURL = component?.url else {
            throw NetworkError.badURL
        }
        
        var jsonData: [T]?
        var returnedResponse: URLResponse?
        let jsonDecoder = JSONDecoder()
        let semaphore = DispatchSemaphore(value: 0)
        
        let session = URLSession.shared
        let task = session.dataTask(with: finalURL) { (data, response, error) in
            
            guard let data = data else {
                print("Network Error", #file, #line)
                return
            }
            
            do {
                let json = try jsonDecoder.decode([T].self, from: data)
                jsonData = json
            } catch let error {
                print("Network Error: \(error)", #file, #line)
                return
            }
            
            guard let response = response else {
                print("Network Error", #file, #line)
                return
            }
            returnedResponse = response
            
            semaphore.signal()
        }
        task.resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        if let response = returnedResponse as? HTTPURLResponse, response.statusCode > 210 {
            throw NetworkError.statusCode(response.statusCode)
        }
        
        return jsonData
    }
    
    
    func loadImage(urlString: String) throws -> UIImage? {
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.badURL
        }
        
        var returnedImage: UIImage?
        var returnedResponse: URLResponse?
        let semaphore = DispatchSemaphore(value: 0)
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                print("Network Error", #file, #line)
                return
            }
            guard let image = UIImage(data: data) else {
                print("Network Error", #file, #line)
                return
            }
            returnedImage = image
            
            guard let response = response else {
                print("Network Error", #file, #line)
                return
            }
            returnedResponse = response
            
            semaphore.signal()
            }
            .resume()
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        if let response = returnedResponse as? HTTPURLResponse, response.statusCode > 210 {
            throw NetworkError.statusCode(response.statusCode)
        }
        
        return returnedImage
    }
}
