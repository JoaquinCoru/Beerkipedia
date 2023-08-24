//
//  BeerModel.swift
//  BeerApp
//
//  Created by Joaquín Corugedo Rodríguez on 18/8/23.
//

import Foundation

struct BeerModel: Identifiable, Codable {
    let id: Int
    let name: String
    let tagline: String
    let description: String
    let image_url: String?
    let brewers_tips: String
    let food_pairing: [String]
}
