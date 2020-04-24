//
//  BlockRow.swift
//  Blocks_X
//
//  Created by elber on 2/27/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI

enum DragState{
	case unknown
	case good
	case bad
}

struct BlockRow: View {
	@State private var dragState = DragState.unknown
	@State private var dragAmount = CGSize.zero
	
	var blockVar: Block
	var onChanged: ((CGPoint, Block) -> DragState)?
	var onEnded: ((CGPoint, Int, Block) -> Void)?
	var index: Int
	var newMovement: Int
	
	var body: some View {
		ZStack {
			if (blockVar.name == "Drop Area") { // Handles the block which creates the drop area
				ZStack {
					Rectangle()
						.foregroundColor(.gray)
						.frame(width: 320, height: 150)
						.overlay(
							Rectangle()
								.stroke(blockColor(bColor: blockVar.color), style: StrokeStyle(lineWidth: 4, dash: [10]))
					)
					Text("Drag and drop commands into this area!")
						.font(.title)
						.fontWeight(.heavy)
						.foregroundColor(Color.white)
						.multilineTextAlignment(.center)
						.frame(width: 200.0)
						.zIndex(5)
						.frame(width:50, height: 200)
				}
			} else if(blockVar.color == "clear"){ // Handles the empty blocks that make up the Scroll View
				ZStack {
					Rectangle()
						.foregroundColor(.clear)
						.padding()
						.frame(width: 320, height: 50)
				}
				.frame(width:300)
				.padding(.horizontal, 5)
			} else if (blockVar.category.rawValue == "Dropped") { // Handles when a command block is dropped
				if (newMovement == 0){
					Text("").hidden()
				} else {
					ZStack {
						Rectangle()
							.cornerRadius(12)
							.frame(width: 320, height: 50)
							.zIndex(1)
							.foregroundColor(blockColor(bColor: blockVar.color))
						HStack {
							if (blockVar.input.rawValue == "Units") {
								Text(blockVar.name + " " + String(newMovement) + " Times")
									.font(.headline)
									.fontWeight(.heavy)
									.foregroundColor(Color.white)
									.zIndex(1)
							} else if (blockVar.input.rawValue == "Degrees") {
								Text(blockVar.name + " " + String(newMovement) + " Degrees")
									.font(.headline)
									.fontWeight(.heavy)
									.foregroundColor(Color.white)
									.zIndex(1)
							} else if (blockVar.input.rawValue == "Colors"){
								Text(blockVar.name + " " + String(newMovement) + " Color")
									.font(.headline)
									.fontWeight(.heavy)
									.foregroundColor(Color.white)
									.zIndex(1)
							} else {
								Text(blockVar.name)
									.font(.headline)
									.fontWeight(.heavy)
									.foregroundColor(Color.white)
									.zIndex(1)
							}
							Image(systemName: blockVar.systemName)
								.resizable()
								.frame(width: 30, height: 30)
								.foregroundColor(Color.white)
                                .accessibility(hidden: true)
						}
						.zIndex(100)
						.frame(width: 320, height: 50)
                        .accessibilityElement(children: .combine)
					}
				}
			} else {
				// This builds the draggable command blocks. It is a ZStack with a rectangle at the bottom and an Image and Text over it.
				ZStack {
					Rectangle()
						.cornerRadius(12)
						.frame(width: 200, height: 70)
						.zIndex(-1)
						.foregroundColor(blockColor(bColor: blockVar.color))
					HStack {
						Text(blockVar.name)
							.font(.headline)
							.fontWeight(.heavy)
							.foregroundColor(Color.white)
							.zIndex(2)
						//Image Instead
                        Image(systemName: blockVar.systemName)
							.resizable()
							.frame(width: 30, height: 30)
							.foregroundColor(Color.white)
					}
					.zIndex(100)
					.frame(width: 200, height: 70)
					.padding(.vertical, 5)
				}

					// Drag & Drop Functionality applied to the draggable command block. The offset is controlled by dragAmount which is updated whenever the element is moved. The dragColor is based off of the dragState, which is updated whenever the position of the selected command block changes. Index is used to replace the command from the list of commands whenever it is dropped.
					.offset(dragAmount)
					.shadow(color: dragColor, radius: dragAmount == .zero ? 0 : 10)
					.shadow(color: dragColor, radius: dragAmount == .zero ? 0 : 10)
					.gesture(DragGesture(coordinateSpace: .global)
						.onChanged { value in
							self.dragAmount = CGSize(width: value.translation.width, height: value.translation.height)
							self.dragState = self.onChanged?(value.location, self.blockVar) ?? .unknown
					}
					.onEnded {
						if(self.dragState == .good){
							self.onEnded?($0.location, self.index, self.blockVar)
						}
						self.dragAmount = .zero
						}
				)
                    .accessibilityElement(children: .ignore)
                    .accessibility(label: Text(blockVar.name))
                    .accessibility(hint: Text("Double click and hold to drag."))
			}
		}
	}
	
	var dragColor: Color {
		switch dragState{
		case .unknown:
			return .black
		case .good:
			return .green
		case .bad:
			return .red
		}
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
		
	case "clear":
		return Color.white
		
	default:
		return Color.blue
	}
}

struct BlockRow_Previews: PreviewProvider {
	static var previews: some View {
		VStack{
			BlockRow(blockVar: blockData[0], index: 0, newMovement: 1)
			BlockRow(blockVar: blockData[6], index: 0, newMovement: 1)
			BlockRow(blockVar: blockData[11], index: 0, newMovement: 1)
			BlockRow(blockVar: blockData[13], index: 0, newMovement: 1)
		}
		.frame(width: 600, height: 600)
		.background(Color.black)
	}
}
