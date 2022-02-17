//
//  MovieModel.swift
//  MACAQ-HQ
//
//  Created by Mohammed Al-Quraini on 2/13/22.


import Foundation

// MARK: - MovieModel
struct MovieModel: Codable {
    let results: [Movie]

}

// MARK: - Result
struct Movie: Codable {
    let id: Int
    let originalTitle, overview: String
    let posterPath, title: String

    enum CodingKeys: String, CodingKey {
        case id
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case title
    }
}
