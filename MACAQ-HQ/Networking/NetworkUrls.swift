//
//  NetworkUrls.swift
//  MACAQ-HQ
//
//  Created by Mohammed Al-Quraini on 2/13/22.
//

import Foundation

enum NetworkURLs {
    static let apiKey = "api_key=6622998c4ceac172a976a1136b204df4"
    static let baseURL = "https://api.themoviedb.org/3/movie/popular?language=en-US&page=1&\(apiKey)"
    static let imagePath = "https://image.tmdb.org/t/p/original"
    static let productionUrl = "https://api.themoviedb.org/3/movie/"
// https://api.themoviedb.org/3/movie/634649?api_key=6622998c4ceac172a976a1136b204df4
}
