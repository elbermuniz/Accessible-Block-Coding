//
//  Block.swift
//  Blocks_X
//
//  Created by elber on 2/27/20.
//  Copyright © 2020 COMP523. All rights reserved.
//


import SwiftUI
import CoreLocation

struct Block: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var category: Category
	var systemName: String

    enum Category: String, CaseIterable, Codable, Hashable {
        case count = "Count"
        case degrees = "Degrees"
        case colors = "Colors"
    }
}
