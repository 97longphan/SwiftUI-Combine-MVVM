//
//  PokemonModel.swift
//  SwiftUI-Combine-MVVM
//
//  Created by Mango on 07/04/2022.
//

import Foundation

struct PokemonDetailModel: Decodable {
    var height: Int?
    var id: Int?
    var name: String?
    var sprites: PokemonSprites?
}

struct PokemonSprites: Decodable {
    var back_default: String?
    var front_default: String?
    var front_shiny: String?
}

struct PokemonModel: Codable, Identifiable {
    var id: String {
        name
    }
    var name: String
    var url: String
    var avatar: String?
}

struct PokemonListModel: Codable {
    var count: Int?
    var next: String?
    var previous: String?
    var results: [PokemonModel] = []
}
