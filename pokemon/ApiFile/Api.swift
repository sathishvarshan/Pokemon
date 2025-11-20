//
//  Api.swift
//  pokemon
//
//  Created by Sathish  on 19/11/25.
//

import Foundation

class NetworkManager{
    
    static let shared = NetworkManager()
    
    func fetchPokemon<T: Decodable>(_ type: T.Type, apiFor: ApiType = .List, id: String = "0",from offset: Int = 0) async throws -> T {
        var fullUrl = BaseUrl
        if apiFor == .List{
            if offset != 0 {
                fullUrl = BaseUrl + "?limit=50&offset=\(offset)"
            }else if offset == 0{
                fullUrl = BaseUrl + "?limit=50&offset=0"
            }
        }else{
            fullUrl = BaseUrl + "/\(id)"
        }
        print("Url: ",fullUrl)
        let url = URL(string: fullUrl)!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func fetchPokemonImage(for url: String) async throws -> String? {
        let detailURL = URL(string: url)!
        let (data, _) = try await URLSession.shared.data(from: detailURL)
        let details = try JSONDecoder().decode(PokemonDetails.self, from: data)
        return details.sprites.front_default
    }

    
}

enum ApiType{
    case List
    case Detail
}
