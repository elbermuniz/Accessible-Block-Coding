//
//  ContentView.swift
//  Blocks_X
//
//  Created by elber on 2/26/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@State private var activeCommands: [[Int]] = Array(repeating: Array(repeating: 6, count: 6), count: 5)
	@State private var commandList = [Int] (repeating: 0, count: 6)
	@State private var commandFrames = [CGRect](repeating: .zero, count: 30)
	@State private var count = 0
	
	var block: Block
	
	var body: some View {
		VStack{
			
			// Start of header section
			HStack {
				Section{
					Image(systemName: "chevron.left")
						.font(.title)
						.padding(.leading)
					
					Text("BlockX")
				}
				.foregroundColor(.blue)
				
				Spacer()
				Spacer()
				Text("Welcome!")
					.multilineTextAlignment(.center)
					.padding(.vertical, 10.0)
				Spacer()
				
				Section {
					Button(action: {
						print("Robot Settings!")
					}) {
						HStack {
							Text("Robot Settings")
								.fontWeight(.semibold)
								.font(.title)
							Image(systemName: "gear")
								.font(.title)
								.padding(.vertical, 5)
						}
						.padding()
						.foregroundColor(.white)
						.background(Color.blue)
						.cornerRadius(90)
					}
					.padding(.trailing)
				}
			}
			.frame(height: 100.0)
			.background(Color.gray)
			// End of header section
			
			Spacer()
			
			// Start of main content area
			HStack {
				// Start of commands area
				VStack {
					HStack {
						Text("CODE")
							.font(.headline)
							.fontWeight(.semibold)
							.multilineTextAlignment(.leading)
							.padding([.top, .leading, .bottom])
							.foregroundColor(.white)
						
						Spacer()
						
						Image(systemName: "line.horizontal.3")
							.font(.title)
							.foregroundColor(.white)
							.padding(.trailing)
					}
					.background(Color.blue)
					
					VStack {
						ForEach(0..<6){ number in
							BlockRow(blockVar: blockData[self.commandList[number]], onChanged: self.commandMoved, onEnded: self.commandDropped, index: number)
						}.padding(-3.5)
					}
					.frame(width: 250, height: 600)
				}
				.frame(width: 250.0)
				.background(Color.gray)
				.zIndex(10)
				// End of commands area
				
				// Start of drop area and top and bottom buttons
				ZStack(alignment: .leading) {
					VStack {
						ForEach(0..<5) { row in
							HStack {
								ForEach(0..<6){ column in
									HStack{
										// Needed to increase global count variable
										Text("_____")
											.onAppear(perform: self.increaseCount)
									}
									.frame(width:0, height:0)
									
									BlockRow(blockVar: blockData[self.activeCommands[row][column]], onChanged: self.commandMoved, index: 5*row+column)
										.overlay(
											GeometryReader { geo in
												Color.clear
													.onAppear{
														self.commandFrames[self.count] = geo.frame(in: .global)
												}
											}
									)
								}
							}
							.offset(x:7,y:-25)
						}.foregroundColor(Color.white)
					}
					
					// Main drop area
					Section {
						Text("Drag and drop commands into this area!")
							.font(.headline)
							.fontWeight(.light)
							.foregroundColor(Color.white)
							.multilineTextAlignment(.center)
							.frame(width: 190.0)
							.zIndex(10)
							.offset(y:290)
					}
					.frame(width: 946, height: 660).background(Color(red: 0.6, green: 0.6, blue: 0.6, opacity: 0.2))
					.zIndex(-1)
					.border(/*@START_MENU_TOKEN@*/Color.white/*@END_MENU_TOKEN@*/, width: 7)
					
					// Bottom row of buttons
					HStack(spacing: 0.0) {
						//Spacer()
						Button(action: {
							print("Volume tapped!")
						}) {
							VStack {
								Image(systemName: "speaker.3")
									.font(.title)
									.padding(.vertical, 5)
							}
							.padding()
							.foregroundColor(.white)
							.background(Color.blue)
							.cornerRadius(90)
						}
						
						Button(action: {
							print("Help tapped!")
						}) {
							VStack {
								Image(systemName: "questionmark")
									.font(.title)
									.padding(.all, 5)
							}
							.padding()
							.foregroundColor(.white)
							.background(Color.blue)
							.cornerRadius(90)
						}
						
						Button(action: {
							print("Play tapped!")
						}) {
							VStack {
								Image(systemName: "play.circle")
									.font(.title)
									.padding(.all, 5)
								
							}
							.padding()
							.foregroundColor(.white)
							.background(Color.blue)
							.cornerRadius(90)
						}
						
						Button(action: {
							print("Trash tapped!")
							self.activeCommands = [[6,6,6,6,6,6],[6,6,6,6,6,6],[6,6,6,6,6,6],[6,6,6,6,6,6],[6,6,6,6,6,6]]
						}) {
							VStack {
								Image(systemName: "trash")
									.font(.title)
									.padding(.all, 5)
							}
							.padding(.all)
							.foregroundColor(.white)
							.background(Color.blue)
							.cornerRadius(90)
						}
					}
					.padding(.trailing, 10)
					.offset(x: 670, y: 290)
					.zIndex(20)
				}
					//.frame(width: 600, height: 400)
					.offset(x:-8)
				// End of main drop area
				
				//Spacer()
			}
			.padding(.top, -30.0)
			
			// End of center area
			Spacer()
		}
		.background(Color.black)
		.onAppear(perform: startApp)
	}
	
	func increaseCount() {
		print("Build count: ", count)
		count = count+1
	}
	
	func startApp() {
		let commands = [0,1,2,3,4,5]
		//	let test = [[6,6,6,6,6,6],[6,6,6,6,6,6],[6,6,6,6,6,6],[6,6,6,6,6,6],[6,6,6,6,6,6]]
		
		commandList = commands
		//	activeCommands = test
	}
	
	func commandDropped(location: CGPoint, blockIndex: Int, block: Block) {
		if let match = commandFrames.firstIndex(where: {$0.contains(location)}){
			let match = 29 - match
			
			let row = match/6
			let column = match % 6
			
			print("Block ID: ", block.id, "Block Index: ", blockIndex, "Original Command Block ID: ", activeCommands[row][column])
			activeCommands[row][column] = block.id
			
			commandList[blockIndex] = block.id
			
			print(activeCommands)
		}
	}
	
	func commandMoved(location: CGPoint, block: Block) -> DragState {
		if let match = commandFrames.firstIndex(where: {$0.contains(location)}){
			let match = 29 - match
			
			let row = match/6
			let column = match % 6
			
			if activeCommands[row][column] != 6 {
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



struct ContentView_Previews: PreviewProvider { //doesn't execute in app
	static var previews: some View {
		ContentView(block: blockData[0])
		//ContentView()
	}
}
