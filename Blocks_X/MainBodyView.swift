//
//  MainBodyView.swift
//  Blocks_X
//
//  Created by elber on 3/25/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI

struct MainBodyView: View {
	@State private var activeCommands = [Int] (repeating: 6, count: 10)
	//	@State private var activeCommands: [[Int]] = Array(repeating: Array(repeating: 6, count: 5), count: 5) // what block is inside grid
	@State private var commandList = [Int] (repeating: 0, count: 6) //commands on the left
	@State private var commandFrames = [CGRect](repeating: .zero, count: 10) // the grid values
	@State private var count = 0
	
	var body: some View {
		GeometryReader { geometry in
			HStack {
				Spacer()
				// Start of commands area
				GeometryReader { geo in
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
						.frame(minWidth: geo.size.width * (0.25), maxWidth: geo.size.width)
						
						Spacer()
						
						//Comands are created on left side
						VStack {
							ForEach(0..<6){ number in
								BlockRow(blockVar: blockData[self.commandList[number]], onChanged: self.commandMoved, onEnded: self.commandDropped, index: number)
							}.padding(-3.5)
						}
						.frame(width: 250, height: 525)
						
						//SliderView().offset(y:-20)
						
						Spacer()
					}
					.frame(minWidth: geo.size.width * (0.25), maxWidth: geo.size.width, minHeight: geo.size.height * (0.25), maxHeight: geo.size.height)
					.background(Color.gray)
					.zIndex(20)
				}
				.frame(width: geometry.size.width * (0.3))
				// End of commands area
				
				// Start of drop area and top and bottom buttons
				ZStack(alignment: .leading) {
					GeometryReader { geo in
						HStack {
							Spacer()
							Spacer()
							
							VStack {
								ScrollView(.vertical) {
									VStack {
										ForEach(0..<10){ number in
											BlockRow(blockVar: blockData[self.activeCommands[number]], onChanged: self.commandMoved, index: number)
												.overlay(
													GeometryReader { geos in
														Color.clear
															.onAppear{
																self.commandFrames[number] = geos.frame(in: .global)
														}
													}
											)
										}
									}
									.foregroundColor(Color.white)
									.padding(.top, 15)
									.padding(.horizontal, 40)
								}
								.frame(minWidth: 0, maxWidth: geo.size.width / 3, minHeight: 0, maxHeight: geo.size.height * (0.8))
								
								//.offset(y: -geo.size.height * (0.1))
								.zIndex(14)
								
								Spacer()
								
								Text("Drag and drop commands into this area!")
									.font(.headline)
									.fontWeight(.light)
									.foregroundColor(Color.white)
									.multilineTextAlignment(.center)
									.frame(width: 190.0)
									.zIndex(1)
									.padding(.bottom, 20)
							}
							
							Spacer()
							
							VStack {
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
										.zIndex(100)
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
										.zIndex(100)
									}
								}
								.padding([.top, .trailing], 20)

								Spacer()
								
								HStack(spacing: 0.0) {
									//Spacer()
									Button(action: {
										print("Trash tapped!")
										self.activeCommands = [Int] (repeating: 6, count: 10)
										//							self.activeCommands = [[6,6,6,6,6,6],[6,6,6,6,6,6],[6,6,6,6,6,6],[6,6,6,6,6,6],[6,6,6,6,6,6]]
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
										.zIndex(100)
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
										.zIndex(100)
									}
								}
								.padding([.bottom, .trailing], 20)

									//.padding(.trailing, 10)
									//.offset(x: geo.size.width * (0.75), y: geo.size.height * (0.89))
							}
						}
						.frame(minWidth: geo.size.width, maxWidth: geo.size.width, minHeight: 0, maxHeight: geo.size.height).background(Color(red: 0.6, green: 0.6, blue: 0.6, opacity: 0.2))
						.border(/*@START_MENU_TOKEN@*/Color.white/*@END_MENU_TOKEN@*/, width: 7)
						.zIndex(0)
						//.offset(y:geo.size.height/6)
					}
					// Bottom row of buttons
					
				}
				.frame(width: geometry.size.width * (0.70))
				.offset(x: -7.5)
				// End of main drop area
				
				Spacer()
			}
			.frame(width: geometry.size.width)
			.onAppear(perform: self.startApp)
		}
	}
	
	func increaseCount() {
		print("Build count: ", count)
		count = count+1
	}
	
	func startApp() {
		let commands = [0,1,2,3,4,5]
		commandList = commands
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

struct MainBodyView_Previews: PreviewProvider {
	static var previews: some View {
		MainBodyView()
			.background(Color.black)
	}
}
