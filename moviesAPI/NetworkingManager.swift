//
//  NetworkingManager.swift
//  moviesAPI
//
//  Created by ntvlbl on 14.11.2024.
//
import Foundation
import UIKit


class NetworkingManager {
    static let shared = NetworkingManager()
    private let apiKey = "865d613b03bb7e95be704060544a4dcd"
    
    private let imageUrl = "https://image.tmdb.org/t/p/w500"
    private let session = URLSession(configuration: .default)
    
    private lazy var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.path = "/3/movie/now_playing"
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        return components
    }()
    
    private init() {}
    
    func getMovies(completion: @escaping ([Movie]) -> Void) {
        guard let url = urlComponents.url else {
            print("Invalid URL")
            return
        }
        
        print("Request URL: \(url)")

        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error:", error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("No response from server")
                return
            }
            
            print("Response status code: \(response.statusCode)")

            guard response.statusCode == 200 else {
                print("Server error with status code:", response.statusCode)
                return
            }
            
            guard let data = data else {
                print("Error: no data received")
                return
            }
            
            print("Data received: \(data)")
            do {
                let moviesResponse = try JSONDecoder().decode(Movies.self, from: data)
                print("Parsed movies:", moviesResponse.results)
                DispatchQueue.main.async {
                    completion(moviesResponse.results)
                }
                
            } catch {
                print("JSON decoding error:", error)  
            }
        }
        task.resume()
    }
    
    func loadImage(posterPath: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: imageUrl + posterPath) else { return }
        
        let task = session.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Image loading error:", error)
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        task.resume()
    }
}
