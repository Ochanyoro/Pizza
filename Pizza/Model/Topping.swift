//
//  Topping.swift
//  Pizza
//
//  Created by 大和田一裕 on 2022/07/30.
//

import SwiftUI

// Toppingモデル
struct Topping: Identifiable {
    var id = UUID().uuidString
    var toppingName: String
    var isAdded: Bool = false
    var randomToppingPositions: [CGSize] = []
}
