//
//  Model.swift
//  pokemon
//
//  Created by Sathish  on 19/11/25.
//

import Foundation

struct PokemonListResponse: Codable {
    let results: [PokemonListItem]
}

struct PokemonListItem: Codable {
    let name: String
    let url: String
}

struct PokemonDetails: Codable {
    let sprites: Sprites
}

struct Sprites: Codable {
    let front_default: String?
}

struct PokemonDetailResponse: Decodable {
    let height: Int
    let weight: Int
    let base_experience: Int
    let id: Int
    let types: [PokemonTypeEntry]
    let abilities: [PokemonAbilityEntry]
}

struct PokemonTypeEntry: Decodable {
    let slot: Int
    let type: NamedAPIResource
}

struct PokemonAbilityEntry: Decodable {
    let slot: Int
    let ability: NamedAPIResource
}

struct NamedAPIResource: Decodable, Hashable {
    let name: String
    let url: String
}
