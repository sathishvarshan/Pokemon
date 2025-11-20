//
//  PokemonViewModel.swift
//  pokemon
//
//  Created by Sathish  on 19/11/25.
//

import Foundation
import SwiftUI
internal import Combine

    
class PokemonViewModel: ObservableObject {
    @Published var pokemons: [(name: String, image: UIImage?, isLoading: Bool, url: String)] = []
    
    private var offset = 0
    private let limit = 50
    private var isLoading = false
    
    @Published var pokemon: PokemonDetailResponse?
    
    let api = NetworkManager.shared
    
    func load(offset: Int = 0) {
        guard !isLoading else { return }
        isLoading = true
        
        Task {
            do {
                let array = try await api.fetchPokemon(PokemonListResponse.self, from: offset)
                let results = array.results
                let startIndex = pokemons.count
                await MainActor.run {
                    self.pokemons.append(contentsOf: results.map { (name: $0.name.capitalized, image: nil, isLoading: true, url: $0.url) }
                    )
                }
                
                for (i, item) in results.enumerated() {
                    let pokemonIndex = startIndex + i
                    let urlString = try await api.fetchPokemonImage(for: item.url)
                    let img = await downloadImage(from: urlString ?? "")
                    await MainActor.run {
                        self.pokemons[pokemonIndex].image = img
                        self.pokemons[pokemonIndex].isLoading = false
                    }
                }
                await MainActor.run {
                    self.offset += self.limit
                }
                
                isLoading = false
                
            } catch {
                print("Error:", error)
                isLoading = false
            }
        }
    }
    
    
    func downloadImage(from urlString: String) async -> UIImage? {
        if let cached = await ImageCache.shared.get(urlString) {
            return cached
        }
        
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                await ImageCache.shared.set(urlString, image)
                return image
            }
            return nil
        } catch {
            return nil
        }
    }
    
    func fetchPokemonDetail(id: String) {
        Task{
            do{
                let result = try await api.fetchPokemon(PokemonDetailResponse.self, apiFor: .Detail, id: id)
                await MainActor.run {
                    self.pokemon = result
                }
            }catch{
                print("Error: ",error)
            }
        }
    }

    
}
