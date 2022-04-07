//
//  PokemonUseCase.swift
//  SwiftUI-Combine-MVVM
//
//  Created by Mango on 07/04/2022.
//

import Foundation
import Alamofire
import Combine

protocol PokemonUseCase {
    func getListPokemon(limit: Int, loadMore: String?) -> AnyPublisher<PokemonListModel, Error>
    func getDetailPokemon(id: String) -> AnyPublisher<PokemonDetailModel, Error>
}

class DefaultPokemonUseCase: PokemonUseCase {
    func getListPokemon(limit: Int, loadMore: String?) -> AnyPublisher<PokemonListModel, Error> {
        var loadMoreString: String? = nil
        if loadMore != "" {
            loadMoreString = loadMore
        }
        let request = ApiRouter.getListPokemon(limit: limit, loadMore: loadMoreString).urlRequest
        
        return URLSession.shared
            .dataTaskPublisher(for: request!)
            .mapError { $0 as Error }
            .map { $0.data }
            .decode(type: PokemonListModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getDetailPokemon(id: String) -> AnyPublisher<PokemonDetailModel, Error> {
        let request = ApiRouter.getDetailPokemon(id: id).urlRequest
        
        return URLSession.shared
            .dataTaskPublisher(for: request!)
            .mapError { $0 as Error }
            .map { $0.data }
            .decode(type: PokemonDetailModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
