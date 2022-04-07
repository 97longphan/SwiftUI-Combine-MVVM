//
//  PokemonView.swift
//  SwiftUI-Combine-MVVM
//
//  Created by Mango on 07/04/2022.
//

import Foundation
import SwiftUI
import Combine
import Kingfisher

struct PokemonView: View {
    @ObservedObject var output: PokemonViewModel.Output
    private var cancelBag = CancelBag()
    
    private let appearTrigger = PassthroughSubject<Void, Never>()
    
    var body: some View {
        NavigationView {
            ZStack {
                List(output.listPokemon) {
                    ListPokemonCell(model: $0)
                }.navigationTitle("Pokémon")
                ActivityIndicator(isAnimating: output.isLoading)
            }
            
        }.onAppear {
            self.appearTrigger.send(())
        }
    }
    
    init(viewModel: PokemonViewModel) {
        let input = PokemonViewModel.Input(onAppearTrigger: appearTrigger.eraseToAnyPublisher())
        let output = viewModel.transform(input: input, cancelBag: cancelBag)
        self.output = output
    }
}
