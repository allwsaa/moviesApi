//
//  GenreManager.swift
//  moviesAPI
//
//  Created by ntvlbl on 14.11.2024.
//
import Foundation

class GenreManager {
    static let shared = GenreManager()

    private let genres: [Int: String] = [
        28: "Action",
        12: "Adventure",
        16: "Animation",
        35: "Comedy",
        80: "Crime",
        99: "Documentary",
        18: "Drama",
        10751: "Family",
        14: "Fantasy",
        36: "History",
        27: "Horror",
        10402: "Music",
        9648: "Mystery",
        10749: "Romance",
        878: "Science Fiction",
        10770: "TV Movie",
        53: "Thriller",
        10752: "War",
        37: "Western"
    ]

    func getGenreName(by id: Int) -> String? {
        return genres[id]
    }
}
