//
//  ProductionModel.swift
//  MACAQ-HQ
//
//  Created by Mohammed Al-Quraini on 2/16/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let productionModel = try? newJSONDecoder().decode(ProductionModel.self, from: jsonData)

import Foundation

// MARK: - ProductionModel
struct ProductionModel: Codable {
    let productionCompanies: [ProductionCompany]
    let productionCountries: [ProductionCountry]

    enum CodingKeys: String, CodingKey {
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
    }
}

// MARK: - ProductionCompany
struct ProductionCompany: Codable {
    let id: Int
    let logoPath: String?
    let name, originCountry: String

    enum CodingKeys: String, CodingKey {
        case id
        case logoPath = "logo_path"
        case name
        case originCountry = "origin_country"
    }
}

// MARK: - ProductionCountry
struct ProductionCountry: Codable {
    let iso3166_1, name: String

    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}
