//
//  MainBodyView.swift
//  Blocks_X
//
//  Created by elber on 3/25/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI

struct MainBodyView: View {
	@State private var commandList = [Int] (repeating: 0, count: 6) //commands on the left
	@State private var activeCommands = [Int] (repeating: 6, count: 15) // contains the actual blocks in list
	@State private var commandFrames = [CGRect](repeating: .zero, count: 1) // the frame of the list area
	@State private var dropBlock = [Int] (repeating: 13, count: 1) // the value of the block where commands are dropped
	@State private var dropArea = [CGRect](repeating: .zero, count: 1) // the frame of the area to drop commands
	@State private var count = 0 // keeps track of which block has been filled in the list
	
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
							}
							.padding(-3.5)
							.zIndex(30)
						}
						.zIndex(30)
						.frame(width: 250, height: 525)
						
						//SliderView().offset(y:-20)
						
						Spacer()
					}
					.frame(minWidth: geo.size.width * (0.25), maxWidth: geo.size.width, minHeight: geo.size.height * (0.25), maxHeight: geo.size.height)
					.background(Color.gray)
				}
				.zIndex(20)
				.frame(width: geometry.size.width * (0.3))
				// End of commands area
				
				// Start of drop area and top and bottom buttons
				ZStack(alignment: .leading) {
					GeometryReader { geo in
						HStack {
							Spacer()
							Spacer()
							
							VStack {
								VStack {
									ScrollView(.vertical) {
										ForEach(0..<15){ number in
											BlockRow(blockVar: blockData[self.activeCommands[number]], onChanged: self.commandMoved, index: number)
//												.overlay(
//													GeometryReader { geos in
//														Color.clear
//															.onAppear{
//																self.commandFrames[number] = geos.frame(in: .global)
//														}
//													}
//												)
										}
										.padding(.vertical, 5)
										.frame(width: 500)
									}
									.overlay(
										GeometryReader { geos in
											Color.clear
												.onAppear{
													self.commandFrames[0] = geos.frame(in: .global)
											}
										}
									)
								}
								.frame(minWidth: 0, maxWidth: geo.size.width / 3, minHeight: 0, maxHeight: geo.size.height * (0.8))
									.allowsHitTesting(false)
									.foregroundColor(Color.white)
									.padding(.top, 15)
									.padding(.horizontal, 40)
								
								//.offset(y: -geo.size.height * (0.1))
								.zIndex(3)
								
								Spacer()

//									.frame(width:200, height: 200)
								BlockRow(blockVar: blockData[13], onChanged: self.commandMoved, index: 0)
									.overlay(
										GeometryReader { geos in
											Color.clear
												.onAppear{
													self.dropArea[0] = geos.frame(in: .global)
											}
										}
									)
							}
							.zIndex(1)
							
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
										self.activeCommands = [Int] (repeating: 6, count: 15)
										self.count = 0
										//self.activeCommands = [[6,6,6,6,6,6],[6,6,6,6,6,6],[6,6,6,6,6,6],[6,6,6,6,6,6],[6,6,6,6,6,6]]
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
						.zIndex(-1)
						}
						.frame(minWidth: geo.size.width, maxWidth: geo.size.width, minHeight: 0, maxHeight: geo.size.height).background(Color(red: 0.6, green: 0.6, blue: 0.6, opacity: 0.2))
						.border(/*@START_MENU_TOKEN@*/Color.white/*@END_MENU_TOKEN@*/, width: 7)
						.zIndex(0)
						//.offset(y:geo.size.height/6)
					}
					// Bottom row of buttons
					
				}
				.zIndex(-1)
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
//		if let match = commandFrames.firstIndex(where: {$0.contains(location)}){
//
//			print("Block ID: ", block.id, "Block Index: ", blockIndex, "Original Command Block ID: ", activeCommands[match])
//			activeCommands[match] = block.id + 7
//
//			commandList[blockIndex] = block.id
//		} else
			if count < 15 {
			activeCommands[count] = block.id + 7
			
			commandList[blockIndex] = block.id
			
			self.increaseCount()
		}
	}
	
	func commandMoved(location: CGPoint, block: Block) -> DragState {
		//print(location)
		if let match = commandFrames.firstIndex(where: {$0.contains(location)}){
			if activeCommands[match] != 13 {
//				print(match)
//				print(activeCommands[match])
//				print(commandFrames)
				//	print("this is bad: ", activeCommands[match])
				return .bad
			}
			else {
				//	print("this is good: ", activeCommands[match])
				return .good
			}
		} else if let dropMatch = dropArea.firstIndex(where: {$0.contains(location)}){
			if(dropBlock[dropMatch] == 13) {
				if count < 15 {
					if activeCommands[count] != 6 {
							print(dropMatch)
							print(dropBlock[dropMatch])
							print(dropArea)
							return .bad
						} else {
							print(dropMatch)
							print(dropBlock[dropMatch])
							print(dropArea)
							return .good
						}
				} else {
					return .bad
				}
			} else {
				return .unknown
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
