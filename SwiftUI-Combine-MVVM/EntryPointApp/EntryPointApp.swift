//
//  EntryPointApp.swift
//  SwiftUI-Combine-MVVM
//
//  Created by Mango on 07/04/2022.
//

import SwiftUI

@main
struct SwiftUI_Combine_MVVMApp: App {
    var body: some Scene {
        WindowGroup {
            PokemonView(viewModel: PokemonViewModel())
        }
    }
}
