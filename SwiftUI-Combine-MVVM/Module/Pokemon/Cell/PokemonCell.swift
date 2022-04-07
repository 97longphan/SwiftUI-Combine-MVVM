//
//  PokemonCell.swift
//  SwiftUI-Combine-MVVM
//
//  Created by Mango on 07/04/2022.
//

import SwiftUI
import Kingfisher

struct ListPokemonCell: View {
    let model: PokemonModel
    
    var body: some View {
        VStack(alignment: .leading) {
            KFImage(URL(string: model.avatar ?? ""))
                .resizable()
                .frame(width: 20, height: 20)
            Text(model.name)
                .font(.system(size: 18))
        }
    }
}
