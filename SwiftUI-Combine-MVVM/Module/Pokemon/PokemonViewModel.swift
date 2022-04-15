//
//  PokemonViewModel.swift
//  SwiftUI-Combine-MVVM
//
//  Created by Mango on 07/04/2022.
//

import Combine
import Foundation

class PokemonViewModel {
    private let useCase: PokemonUseCase
    private var pokemonListModelNew: [PokemonModel] = []
    init(useCase: PokemonUseCase = DefaultPokemonUseCase()) {
        self.useCase = useCase
    }
    
    func mergeObjectData(pokemonDetail: PokemonDetailModel, pokemonListModel: [PokemonModel]) -> Future<[PokemonModel], Never> {
        return Future {[weak self] promise in
            guard let self = self else {return}
            pokemonListModel.forEach { pokemonModel in
                if pokemonModel.name == pokemonDetail.name {
                    var pokemonModelNew = pokemonModel
                    pokemonModelNew.avatar = pokemonDetail.sprites?.front_default
                    self.pokemonListModelNew.append(pokemonModelNew)
                }
            }
            promise(.success(self.pokemonListModelNew))
        }
    }
}

extension PokemonViewModel: ViewModelType {
    struct Input {
        let onAppearTrigger: AnyPublisher<Void, Never>
    }
    
    final class Output: ObservableObject {
        @Published var listPokemon: [PokemonModel] = []
        @Published var isLoading = false
    }
    
    func transform(input: Input, cancelBag: CancelBag) -> Output {
        let output = Output()
        let activityTracker = ActivityTracker(false)
        var tempListPokemon: [PokemonModel] = []
        
        let onAppearTriggerShare = input.onAppearTrigger.share()
        
        onAppearTriggerShare
            .flatMap {
                self.useCase.getListPokemon(limit: 5, loadMore: nil)
                    .trackActivity(activityTracker)
                    .catch { _ in Empty() }
                    .eraseToAnyPublisher() }
            .map { $0.results } // results is list pokemon
            .handleEvents(receiveOutput: {
                tempListPokemon = $0 }) // set list pokemon to temp
            .flatMap {
                $0.map { $0.url }.publisher } // emit all values of url in list ["", "", ""].publisher
            .flatMap {
                self.useCase.getDetailPokemon(id: $0)
                    .trackActivity(activityTracker)
                    .catch { _ in Empty() }
                    .eraseToAnyPublisher() }
            .flatMap({
                self.mergeObjectData(pokemonDetail: $0, pokemonListModel: tempListPokemon)
                    
            })
            .assign(to: \.listPokemon, on: output)
            .store(in: cancelBag)
        
        activityTracker.assign(to: \.isLoading, on: output)
            .store(in: cancelBag)
        
        return output
    }
}


