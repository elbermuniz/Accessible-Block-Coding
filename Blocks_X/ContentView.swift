//
//  ContentView.swift
//  Blocks_X
//
//  Created by elber on 2/26/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@State private var activeCommands = [Int] (repeating: 6, count: 6)
	@State private var commandList = [Int] (repeating: 0, count: 6)
	@State private var commandFrames = [CGRect](repeating: .zero, count: 6)
	
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
//						ForEach(blockData) { block in
//							if(block.color != "clear"){
//								BlockRow(blockVar: block, onChanged: self.commandMoved, index: block.id)
//							}
//						}.padding(-3.5)
					}
					.frame(width: 250, height: 600)
				}
				.frame(width: 250.0)
				.background(Color.gray)
				.zIndex(10)
				// End of commands area
				
				// Start of drop area and top and bottom buttons
				ZStack(alignment: .leading) {
//					VStack {
//						ForEach(0..<5) { _ in
//							HStack {
//								ForEach(0..<6){ number in
//									BlockRow(blockVar: blockData[self.activeCommands[number]], onChanged: self.commandMoved, index: number)
//										.overlay(
//											GeometryReader { geo in
//												Color.clear
//													.onAppear{
//														self.commandFrames[number] = geo.frame(in: .global)
//												}
//											}
//									)
//								}
//							}
//							.offset(x:10,y:-25)
//						}.foregroundColor(Color.white)
//					}
					HStack {
						ForEach(0..<6){ number in
							BlockRow(blockVar: blockData[self.activeCommands[number]], onChanged: self.commandMoved, index: number)
								.overlay(
									GeometryReader { geo in
										Color.clear
											.onAppear{
												self.commandFrames[number] = geo.frame(in: .global)
										}
									}
							)
						}
					}
					.offset(x:10,y:-270)
					
					
//					VStack {
//						ForEach(0..<8) { _ in
////							HStack {
////								ForEach(0..<3) { _ in
////									Text("he")
////										//.resizable()
////										.scaledToFit()
////								}
////							}
//						}
//						.foregroundColor(Color.white)
//					}
//					.frame(width: 600, height: 400).background(Color.clear)
					


					HStack {
						ForEach(0..<6){ number in
							BlockRow(blockVar: blockData[6], onChanged: self.commandMoved, index: number)
								.overlay(
									GeometryReader { geo in
										Color.clear
											.onAppear{
												self.commandFrames[number] = geo.frame(in: .global)
										}
									}
							)
						}
						//.padding(.horizontal,11)
					}
					.offset(x:10,y:-150)

					HStack {
						ForEach(0..<6){ number in
							BlockRow(blockVar: blockData[6], onChanged: self.commandMoved, index: number)
								.overlay(
									GeometryReader { geo in
										Color.clear
											.onAppear{
												self.commandFrames[number] = geo.frame(in: .global)
										}
									}
							)
						}
						//.padding(.horizontal,11)
					}
					.offset(x:10,y:-30)

					HStack {
						ForEach(0..<6){ number in
							BlockRow(blockVar: blockData[6], onChanged: self.commandMoved, index: number)
								.overlay(
									GeometryReader { geo in
										Color.clear
											.onAppear{
												self.commandFrames[number] = geo.frame(in: .global)
										}
									}
							)
						}
						//.padding(.horizontal,11)
					}
					.offset(x:10,y:90)

					HStack {
						ForEach(0..<6){ number in
							BlockRow(blockVar: blockData[6], onChanged: self.commandMoved, index: number)
								.overlay(
									GeometryReader { geo in
										Color.clear
											.onAppear{
												self.commandFrames[number] = geo.frame(in: .global)
										}
									}
							)
						}
						//.padding(.horizontal,11)
					}
					.offset(x:10,y:210)

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
						//.padding(.leading, 0)
						.zIndex(-1)
						.border(/*@START_MENU_TOKEN@*/Color.white/*@END_MENU_TOKEN@*/, width: 7)
					
					// Botttom row of buttons
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
	
	func startApp() {
		let commands = [0,1,2,3,4,5]
		let test = [6,6,6,6,6,6]
		
		commandList = commands
		activeCommands = test
		print(activeCommands)
		print(commandList)
	}
	
	func commandDropped(location: CGPoint, blockIndex: Int, block: Block) {
		if let match = commandFrames.firstIndex(where: {$0.contains(location)}){
			
			print("Block ID: ", block.id, "Block Index: ", blockIndex, "Original Command Block ID: ", activeCommands[match])
			activeCommands[match] = block.id
			
			commandList[blockIndex] = block.id
		}
	}
	
	func commandMoved(location: CGPoint, block: Block) -> DragState {
		if let match = commandFrames.firstIndex(where: {$0.contains(location)}){
			if activeCommands[match] != 6 {
			//	print("this is bad: ", activeCommands[match])
				return .bad
			}
			else {
			//	print("this is good: ", activeCommands[match])
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
