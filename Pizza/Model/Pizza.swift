//
//  Pizza.swift
//  Pizza
//
//  Created by 大和田一裕 on 2022/07/29.
//

import SwiftUI

struct Pizza: Identifiable, Hashable {
    var id = UUID().uuidString
    var breadName: String
}
