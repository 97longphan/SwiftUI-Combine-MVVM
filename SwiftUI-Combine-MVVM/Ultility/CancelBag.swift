//
//  CancelBag.swift
//  SwiftUI-Combine-MVVM
//
//  Created by Mango on 07/04/2022.
//

import Combine

final class CancelBag {
    var subscriptions = Set<AnyCancellable>()
    
    func cancel() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
}

extension AnyCancellable {
    func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}
