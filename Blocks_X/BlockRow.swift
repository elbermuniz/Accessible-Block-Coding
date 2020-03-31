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
	@EnvironmentObject var pickerMovement: UserSettings
	@State private var dragState = DragState.unknown
	@State private var dragAmount = CGSize.zero
	
	var blockVar: Block
	var onChanged: ((CGPoint, Block) -> DragState)?
	var onEnded: ((CGPoint, Int, Block) -> Void)?
	var index: Int

	var body: some View {
		ZStack {
			//createBlock(block: blockVar)
			if(blockVar.color == "clear"){
				ZStack {
					Rectangle()
						.foregroundColor(.clear)
						.padding()
						.frame(width: 190, height: 70)
						.overlay(
							Capsule(style: .continuous)
								.stroke(blockColor(bColor: blockVar.color), style: StrokeStyle(lineWidth: 5, dash: [10]))
						)
				}
				.padding(.horizontal, 5)
			} else if (blockVar.category.rawValue == "Dropped"){
				ZStack {
					Rectangle()
						.cornerRadius(12)
						.frame(width: 200, height: 70)
						.zIndex(-10)
						.foregroundColor(blockColor(bColor: blockVar.color))
					HStack {
						Text(blockVar.name)
							.foregroundColor(Color.black)
							.zIndex(10)
						PickerView(pickerImageVar: blockVar.systemName)
							.zIndex(100)
							.frame(width: 30, height: 30)
					}
					.zIndex(100)
					.frame(width: 200, height: 70)
					}
			} else {
				ZStack {
					Rectangle()
						.cornerRadius(12)
						.frame(width: 200, height: 70)
						.zIndex(-10)
						.foregroundColor(blockColor(bColor: blockVar.color))
					HStack {
						Text(blockVar.name)
							.foregroundColor(Color.black)
							.zIndex(10)
						//Image Instead
						Image(systemName: blockVar.systemName)
							.resizable()
							.frame(width: 30, height: 30)
					}
					.zIndex(100)
					.frame(width: 200, height: 70)
					}
						//Drag & Drop Functionality
						.offset(dragAmount)
						//.zIndex(dragAmount == .zero ? 0 : 30) // TODO: Figure out why block goes behind
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
					)//.zIndex(dragAmount == .zero ? 0 : 1)
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

//extension View {
//	func createBlock(block: Block) -> some View {
//		if(block.color == "clear"){
//			return AnyView(ZStack {
//				Rectangle()
//					.foregroundColor(.clear)
//					.padding()
//					.frame(width: 190, height: 70)
//					.overlay(
//						Capsule(style: .continuous)
//							.stroke(blockColor(bColor: block.color), style: StrokeStyle(lineWidth: 5, dash: [10]))
//					)
//			}
//			.padding(.horizontal, 5)
//			)
//		} else {
//			return AnyView(ZStack {
//				Rectangle()
//					.cornerRadius(12)
//					.frame(width: 200, height: 70)
//					.zIndex(-10)
//					.foregroundColor(blockColor(bColor: block.color))
//				HStack {
//					Text(block.name)
//						.foregroundColor(Color.black)
//						.zIndex(10)
//					SliderView(pickerImageVar: block.systemName)
//						.frame(width: 30, height: 30)
//				}
//				.frame(width: 200, height: 70)
//				}
//					//Drag & Drop Functionality
//					.offset(dragAmount)
//					.zIndex(dragAmount == .zero ? 0 : 30) // TODO: Figure out why block goes behind
//					.shadow(color: dragColor, radius: dragAmount == .zero ? 0 : 10)
//					.shadow(color: dragColor, radius: dragAmount == .zero ? 0 : 10)
//					.gesture(DragGesture(coordinateSpace: .global)
//						.onChanged { value in
//							self.dragAmount = CGSize(width: value.translation.width, height: value.translation.height)
//							self.dragState = self.onChanged?(value.location, self.blockVar) ?? .unknown
//					}
//					.onEnded {
//						if(self.dragState == .good){
//							self.onEnded?($0.location, self.index, self.blockVar)
//						}
//							self.dragAmount = .zero
//						}
//				)
//					.zIndex(dragAmount == .zero ? 0 : 1)
//			)
//		}
//	}
//}

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

//func blockDropState(state: Block.Category) -> String {
//	//let temp =  state
//
//	if(state.rawValue == "dropped"){
//		return "Dropped"
//	}
//}

struct BlockRow_Previews: PreviewProvider {
	static var previews: some View {
		VStack{
			BlockRow(blockVar: blockData[6], index: 0)
			BlockRow(blockVar: blockData[7], index: 0)
		}
		.frame(width: 600, height: 600)
		.background(Color.black)
	}
}
