//
//  Model.swift
//  Simaphore
//
//  Created by Amr Omran on 04/25/2019.
//  Copyright © 2019 Amr Omran. All rights reserved.
//

import Foundation

enum URLs {
    static let imageSearch = "https://api.thecatapi.com/v1/images/search"
    static let breeds = "https://api.thecatapi.com/v1/breeds"
}

struct Breed: Codable {
    let id: String
    let name: String
    let temperament: String
    let origin: String
    let country_codes: String
    let country_code: String
    let description: String
}

struct ImageURL: Codable {
    let id: String
    let url: String
    let width: Int
    let height: Int
}

