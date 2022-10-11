//
//  Pokemon.swift
//  PokemonList
//
//  Created by user on 03/10/22.
//
// url : https://pokeapi.co/api/v2/pokemon?limit=30

import Foundation

struct Pokemon : Codable {
    var results: [PokemonEntry]
}

struct PokemonEntry : Codable, Identifiable {
    let id = UUID()
    var name: String
    var url: String
}

class PokeApi {
    func getData(completion: @escaping ([PokemonEntry]) -> ()) {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=30") else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, respose, error) in
            guard let data = data else { return }
            
            let pokemonlist = try! JSONDecoder().decode(Pokemon.self, from: data)
            
            DispatchQueue.main.async {
                completion(pokemonlist.results)
            }
            
        }.resume()
    }
}
