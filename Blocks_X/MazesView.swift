//
//  MazesView.swift
//  Blocks_X
//
//  Created by elber on 4/8/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI

struct MazesView: View {
	@State private var activeCommands: [[Int]] = Array(repeating: Array(repeating: 14, count: 3), count: 6)
	@State private var commandList = [Int] (repeating: 15, count: 2)
	@State private var commandFrames = [CGRect](repeating: .zero, count: 18)
	@State private var count = 0
	
	let gradient = Gradient(colors: [.gray, .black])
	
	var body: some View {
		GeometryReader { geometry in
			ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
				//Color.black.edgesIgnoringSafeArea(.all)
				Rectangle()
					.fill(
						RadialGradient(gradient: self.gradient, center: .center, startRadius: 1, endRadius: 1100)
				).edgesIgnoringSafeArea(.all)
				
				HStack{
					Text("Map Customizer")
						.fontWeight(.heavy)
				}
				.multilineTextAlignment(.center)
				.padding(.top, 0.0)
				.font(.system(size: 72))
				.foregroundColor(.white)
				
				VStack {
					
					Text("").font(.title).padding()
					Text("").font(.title).padding()
					Text("").font(.title).padding()
					
					ZStack{
						VStack {
							ForEach(0..<6) { row in
								HStack {
									ForEach(0..<3){ column in
										HStack{
											// Needed to increase global count variable
											Text("_____")
												.onAppear(perform: self.increaseCount)
										}
										.hidden()
										
										BlockRow(blockVar: blockData[self.activeCommands[row][column]], onChanged: self.commandMoved, index: 5*row+column, newMovement: 0)
											.overlay(
												GeometryReader { geo in
													Color.clear
														.onAppear{
															self.commandFrames[self.count] = geo.frame(in: .global)
													}
												}
										)
										//.border(Color.white)
									}
								}
							}
							.foregroundColor(Color.white)
						}
					}
					
				}
				.frame(width: geometry.size.width)
				//.onAppear(perform: self.startApp)
			}
			.frame(minWidth: geometry.size.width)
				//.background(Color.gray)
				.zIndex(10)
			// End of commands area
			
			
			// Start of drop area and top and bottom buttons
		}
	}
	
	func increaseCount() {
		print("Build count: ", count)
		count = count+1
	}
	
	func startApp() {
		let commands = [15, 15]
		//		commandList = commands
	}
	
	func commandDropped(location: CGPoint, blockIndex: Int, block: Block) {
		if let match = commandFrames.firstIndex(where: {$0.contains(location)}){
			let match = 17 - match
			let row = match/3
			let column = match % 3
			
			print("Block ID: ", block.id, "Block Index: ", blockIndex, "Original Command Block ID: ", activeCommands[row][column])
			activeCommands[row][column] = block.id
			
			//        bcommandList[blockIndex] = block.id
			
			print(activeCommands)
		}
	}
	
	func commandMoved(location: CGPoint, block: Block) -> DragState {
		if let match = commandFrames.firstIndex(where: {$0.contains(location)}){
			let match = 17 - match
			let row = match/3
			let column = match % 3
			
			if activeCommands[row][column] != 14 {
				return .bad
			}
			else {
				return .good
			}
		} else {
			return .unknown
		}
	}
}
//

struct MazesView_Previews: PreviewProvider {
	static var previews: some View {
		MazesView()
	}
}
