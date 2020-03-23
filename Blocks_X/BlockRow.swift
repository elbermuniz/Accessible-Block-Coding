//
//  BlockRow.swift
//  Blocks_X
//
//  Created by elber on 2/27/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI

struct BlockRow: View {
	
	var block: Block
	
	@State private var currentPosition: CGSize = .zero
	@State private var newPosition: CGSize = .zero
	
    var body: some View {
		ZStack {
			Rectangle()
				.frame(width: 130, height: 90)
				.zIndex(-10)
				.foregroundColor(blockColor(bColor: block.color))
			VStack {
				Text(block.name)
					.foregroundColor(Color.black)
					.zIndex(10)
				Image(systemName: block.systemName)
					.resizable()
					.frame(width: 30, height: 30)
				}
				.padding(.all, 10)
				.frame(width: 150, height: 90)
		}
// Drag & Drop Functionality
		.offset(x: self.currentPosition.width, y: self.currentPosition.height)
		.gesture(DragGesture()
				.onChanged { value in
					self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
			}
				.onEnded { value in
					self.currentPosition = CGSize(width: value.translation.width + self.newPosition.width, height: value.translation.height + self.newPosition.height)
					print("update: ", self.currentPosition)
					self.newPosition = self.currentPosition
				}
	)
	}
}

func blockColor(bColor: String) -> Color {
	let temp = bColor
	
	switch temp {
		
	case "red":
		return Color.red

	case "blue":
		return Color.blue

	case "green":
		return Color.green
		
	case "orange":
		return Color.orange

	case "yellow":
		return Color.yellow

	case "purple":
		return Color.purple
		
	default:
		return Color.blue
	}
}

struct BlockRow_Previews: PreviewProvider {
    static var previews: some View {
		BlockRow(block: blockData[0])
    }
}
