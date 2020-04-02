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
	var color: String
	var input: Input
	
    enum Category: String, CaseIterable, Codable, Hashable {
		case normal = "Normal"
		case dropped = "Dropped"
    }
	
	enum Input: String, CaseIterable, Codable, Hashable {
		case degrees = "Degrees"
		case unit = "Units"
		case colors = "Colors"
		case none = "None"
	}
}
