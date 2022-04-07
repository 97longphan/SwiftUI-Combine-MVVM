//
//  PokemonViewModel.swift
//  SwiftUI-Combine-MVVM
//
//  Created by Mango on 07/04/2022.
//

import Combine
import Foundation

struct PokemonViewModel {
    private let useCase: PokemonUseCase
    
    init(useCase: PokemonUseCase = DefaultPokemonUseCase()) {
        self.useCase = useCase
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
        
        input.onAppearTrigger
            .flatMap {
                self.useCase.getListPokemon(limit: 2000, loadMore: nil)
                    .trackActivity(activityTracker)
                    .catch { _ in Empty() }
                .eraseToAnyPublisher() }
            .map { $0.results }
            .assign(to: \.listPokemon, on: output)
            .store(in: cancelBag)
        
        activityTracker.assign(to: \.isLoading, on: output)
            .store(in: cancelBag)
        
        return output
    }
}


