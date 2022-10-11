//
//  Others.swift
//  PokemonList
//
//  Created by user on 10/10/22.
//

import Foundation
import UIKit

extension Dictionary {
    mutating func changeKey(from: Key, to: Key) {
        self[to] = self[from]
//        self.removeValueForKey(from)
        self.removeValue(forKey: from)
    }
}
