//
//  MainBodyView.swift
//  Blocks_X
//
//  Created by elber on 3/25/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI

struct MainBodyView: View {
	@EnvironmentObject var pickerMovement: UserSettings
	
	@State private var commandList = [Int] (repeating: 0, count: 6) //commands on the left
	@State private var dropBlock = [Int] (repeating: 13, count: 1) // the value of the block where commands are dropped
	@State private var dropArea = [CGRect](repeating: .zero, count: 1) // the frame of the area to drop commands
	@State private var enableMovementPicker = false
	@State private var enableDegreePicker = false
	@State private var enableColorPicker = false
	@State var timeRemaining = 3
	
	let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
	//let spheroController = SpheroController()
	
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
								.fontWeight(.bold)
								.multilineTextAlignment(.leading)
								.padding([.top, .leading, .bottom])
								.foregroundColor(.white)
							
							Spacer()
							
							Image(systemName: "line.horizontal.3")
								.font(.title)
								.foregroundColor(.white)
								.padding(.trailing)
                                .accessibility(hidden: true)
						}
						.background(Color.blue)
						.frame(minWidth: geo.size.width * (0.25), maxWidth: geo.size.width)
                        .accessibility(sortPriority: 2)
						
						//Comands are created on left side
						VStack {
							ForEach(0..<6){ number in
                                BlockRow(blockVar: blockData[self.commandList[number]], onChanged: self.commandMoved, onEnded: self.commandDropped, index: number, newMovement: 0)
							}
							.padding(-3.5)
							.zIndex(30)
						}
						.zIndex(30)
						.frame(width: 250, height: 525)
                        .accessibility(sortPriority: 1)
												
						Spacer()
						
						Button(action: {
							print("Trash tapped!")
							self.pickerMovement.activeCommands = [(Int, Int)]  (repeating: (6,0), count: 30)
							self.pickerMovement.count = 0
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
                            .accessibility(sortPriority: 0)
							.accessibility(label: Text("Delete"))
							.accessibility(hint: Text("Tap to delete all code."))
						}
						.padding([.bottom, .trailing], 20)
					}
					.frame(minWidth: geo.size.width * (0.25), maxWidth: geo.size.width, minHeight: geo.size.height * (0.25), maxHeight: geo.size.height)
					.background(Color.gray)
                    .accessibilityElement(children: .contain)
                    .accessibility(sortPriority: 1)
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
										ForEach(0..<30){ number in
											BlockRow(blockVar: blockData[self.pickerMovement.activeCommands[number].0], onChanged: self.commandMoved, index: number, newMovement: self.pickerMovement.activeCommands[number].1)
										}
										.padding(.vertical, 5)
										.frame(width: 500)
									}
									.overlay(
										GeometryReader { geos in
											Color.clear
												.onAppear{
													self.pickerMovement.commandFrames[0] = geos.frame(in: .global)
											}
										}
									)
								}
								.frame(minWidth: 0, maxWidth: geo.size.width / 3, minHeight: 0, maxHeight: geo.size.height * (0.8))
								.allowsHitTesting(false)
								.foregroundColor(Color.white)
								.padding(.top, 15)
								.padding(.horizontal, 40)
								.zIndex(3)
								Divider().background(Color.white)
								Spacer()
								
								BlockRow(blockVar: blockData[13], onChanged: self.commandMoved, index: 0, newMovement: 0)
									.overlay(
										GeometryReader { geos in
											Color.clear
												.inputPicker(movementState: self.$enableMovementPicker, degreeState: self.$enableDegreePicker, colorState: self.$enableColorPicker)
												.onAppear{
													self.dropArea[0] = geos.frame(in: .global)
												}
										}
									)
									.zIndex(4)
							}
							.zIndex(1)
                            .accessibility(sortPriority: 1)
							
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
                                    Button(action: {
                                        print("Back tapped!")
                                        let count = self.pickerMovement.count
                                        if count > 0 {
                                            self.pickerMovement.activeCommands[count-1] = (6,0)
                                            self.pickerMovement.count -= 1
                                        }
                                    }) {
                                        VStack {
                                            Image(systemName: "arrow.left.circle")
                                                .font(.title)
                                                .padding(.all, 5)
                                        }
                                        .padding(.all)
                                        .foregroundColor(.white)
                                        .background(Color.blue)
                                        .cornerRadius(90)
                                        .zIndex(100)
                                        .accessibility(label: Text("Erase"))
                                        .accessibility(hint: Text("Tap to delete last command."))
                                    }
									Button(action: {
										print("Trash tapped!")
										self.pickerMovement.activeCommands = [(Int, Int)]  (repeating: (6,0), count: 30)
										self.pickerMovement.count = 0
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
                                        .accessibility(label: Text("Delete"))
                                        .accessibility(hint: Text("Tap to delete all code."))
									}
									
									Button(action: {
										print("Play tapped!")
										self.playCommands()
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
                                        .accessibility(label: Text("Play"))
                                        .accessibility(hint: Text("Double tap to run commands on Sphero."))
									}
								}
								.padding([.bottom, .trailing], 20)
							}
							.zIndex(-1)
                            .accessibility(sortPriority: 0)
						}
						.frame(minWidth: geo.size.width, maxWidth: geo.size.width, minHeight: 0, maxHeight: geo.size.height).background(Color(red: 0.6, green: 0.6, blue: 0.6, opacity: 0.2))
						.border(/*@START_MENU_TOKEN@*/Color.white/*@END_MENU_TOKEN@*/, width: 7)
						.zIndex(0)
                        .accessibilityElement(children: .contain)
					}
					// Bottom row of buttons
					
				}
				.zIndex(-1)
				.background(Color.black)
				.frame(width: geometry.size.width * (0.70))
				.offset(x: -7.5)
                .accessibility(sortPriority: 0)
				// End of main drop area
				
				Spacer()
			}
			.frame(width: geometry.size.width)
			.onAppear(perform: self.startApp)
            .accessibilityElement(children: .contain)
			.onReceive(self.timer) { _ in
				if self.timeRemaining > 0 {
					self.timeRemaining -= 1
				} else {
					self.timeRemaining = 3
				}
			}
		}
	}
	
	func playCommands() {
		//let spheroController = SpheroController()
		//spheroController.connectToSpheroIfAvailable()
		
		sleep(10)
		
		var commands: [(commandType: Int, unit: Int)] = []
		for value in 0..<30 {
			if(pickerMovement.activeCommands[value].0 != 6 && pickerMovement.activeCommands[value].0 != 11){
				print(pickerMovement.activeCommands[value])
				commands.append((pickerMovement.activeCommands[value].0, pickerMovement.activeCommands[value].1))
			}
		}
		
//		for index in 0..<commands.count {
//
//			if(commands[index].commandType == 7) { // Move Forward
//				spheroController.rollDistance(distance: Double(commands[index].unit), heading: 0)
//
//			} else if(commands[0].commandType == 8) { // Move Backwards
//				// Spin 180 degrees
//				spheroController.turnRight(heading: UInt16(180))
//				spheroController.rollDistance(distance: Double(commands[index].unit), heading: 0)
//
//			} else if(commands[0].commandType == 9) { // Turn Right
//				//Turn Right
//				spheroController.turnRight(heading: UInt16(commands[index].unit))
//
//			} else if(commands[0].commandType == 10) { // Turn Left
//				//Turn Left
//				spheroController.turnLeft(heading: UInt16(commands[index].unit))
//
//			} else if(commands[0].commandType == 12) { // Set Color
//				// Set Color
//				// spheroController.rearLedBrightness(UInt8(commands[index].unit))
//				// Not sure
//			}
//
//		}
//		self.pickerMovement.activeCommands = [(Int, Int)]  (repeating: (6,0), count: 30)
//		self.pickerMovement.count = 0
	}
	
	func increaseCount() {
		print("Build count: ", pickerMovement.count)
		pickerMovement.count = pickerMovement.count+1
	}
	
	func startApp() {
		let commands = [0,1,2,3,4,5]
		commandList = commands
	}
	
	func commandDropped(location: CGPoint, blockIndex: Int, block: Block) {
		let newBlockID = block.id + 7
		
		if pickerMovement.count < 30 {
			if(newBlockID == 7 || newBlockID == 8){
				enableMovementPicker = true
			} else if (newBlockID == 9 || newBlockID == 10) {
				enableDegreePicker = true
			} else if (newBlockID == 12) {
				enableColorPicker = true
			} else {
				enableDegreePicker = false
				enableMovementPicker = false
				enableColorPicker = false
			}
			pickerMovement.activeCommands[pickerMovement.count].0 = newBlockID
			commandList[blockIndex] = block.id
			
			if(newBlockID == 11){
				self.pickerMovement.activeCommands[self.pickerMovement.count].1 = 1
			}
			
			increaseCount()
		}
	}
	func commandMoved(location: CGPoint, block: Block) -> DragState {
		//print(location)
		if let match = pickerMovement.commandFrames.firstIndex(where: {$0.contains(location)}){
			if pickerMovement.activeCommands[match].0 != 13 {
				
//				if(timeRemaining == 1) {
//					playSound(sound: "bad-sound", type: "mp3")
//				}
				return .bad
			}
			else {
				return .good
			}
		} else if let dropMatch = dropArea.firstIndex(where: {$0.contains(location)}){
			if(dropBlock[dropMatch] == 13) {
				if pickerMovement.count < 30 {
					if pickerMovement.activeCommands[pickerMovement.count].0 != 6 {
						return .bad
					} else {
//						if(timeRemaining == 1) {
//							playSound(sound: "good-sound", type: "mp3")
//						}
						return .good
					}
				} else {
//					if(timeRemaining == 1) {
//						playSound(sound: "bad-sound", type: "mp3")
//					}
					return .bad
				}
			} else {
				print("here")
				return .unknown
			}
		} else {
			return .unknown
		}
	}
}

// Handles the 3 different types of pickers used when a command is dropped
struct blockPicker: ViewModifier {
	@EnvironmentObject var pickerMovement: UserSettings
	//@Binding var state: Bool
	@Binding var movementState: Bool
	@Binding var degreeState: Bool
	@Binding var colorState: Bool
	
	let inputArray = Array(1...100)
	let degreeArray: [Int] = [15, 30, 45, 60, 75, 90, 105, 120, 135, 150, 165, 180]
	let colorArray = Array(0...5) //["Red", "Blue", "Green", "Yellow", "Purple", "Orange"] <- these are the color values
	let colors = ["Red", "Blue", "Green", "Yellow", "Purple", "Orange"]
	@State var slectedObj = 0
	
	func body(content: Content) -> some View {
		ZStack {
			if(movementState){ // if a command is dropped which uses distances
				VStack() {
					Text("")
						.hidden()
				}.blur(radius: $movementState.wrappedValue ? 1 : 0)
					.overlay(
						$movementState.wrappedValue ? Color.black.opacity(0.6) : nil
				)
				if $movementState.wrappedValue {
					GeometryReader { gr in
						VStack {
							VStack {
								Text("Units")
									.font(.headline)
									.foregroundColor(.gray)
									.padding(.top, 10)
								Text("Choose Distance")
									.padding(.top, 5)
									.foregroundColor(.black)
								Picker("test", selection: self.$slectedObj) {
									ForEach(0 ..< self.inputArray.count) {
										Text(String(self.inputArray[$0])).tag($0)
									}
								}
								.foregroundColor(.black)
								.labelsHidden()
							}.background(RoundedRectangle(cornerRadius: 10)
								.foregroundColor(Color.white).shadow(radius: 1))
							VStack {
								Button(action: {
									debugPrint("Done Selected")
									self.movementState = false
									
									self.pickerMovement.value = self.slectedObj + 1
									self.pickerMovement.activeCommands[self.pickerMovement.count - 1].1 = self.pickerMovement.value
									self.pickerMovement.value = 0
								}) {
									Text("Done").fontWeight(Font.Weight.bold).foregroundColor(.black)
								}.padding()
									.frame(maxWidth: 600)
									.background(RoundedRectangle(cornerRadius: 10)
										.foregroundColor(Color.white).shadow(radius: 1))
								
							}
						}
						.frame(width: gr.size.width, height: gr.size.height)
						.zIndex(100)
						.offset(y:-300)
					}
				}
			} else if (degreeState){ // if a command is dropped which uses degrees
				VStack() {
					Text("")
						.hidden()
				}.blur(radius: $degreeState.wrappedValue ? 1 : 0)
					.overlay(
						$degreeState.wrappedValue ? Color.black.opacity(0.6) : nil
				)
				if $degreeState.wrappedValue {
					GeometryReader { gr in
						VStack {
							VStack {
								Text("Degrees")
									.font(.headline)
									.foregroundColor(.gray)
									.padding(.top, 10)
								Text("Choose Value")
									.padding(.top, 5)
									.foregroundColor(.black)
								Picker("test", selection: self.$slectedObj) {
									ForEach(0 ..< self.degreeArray.count) {
										Text(String(self.degreeArray[$0])).tag($0)
									}
								}
								.foregroundColor(.black)
								.labelsHidden()
							}.background(RoundedRectangle(cornerRadius: 10)
								.foregroundColor(Color.white).shadow(radius: 1))
							VStack {
								Button(action: {
									debugPrint("Done Selected")
									self.degreeState = false
									self.pickerMovement.value = self.slectedObj + 1
									
									self.pickerMovement.activeCommands[self.pickerMovement.count - 1].1 = self.pickerMovement.value * 15
									self.pickerMovement.value = 0
								}) {
									Text("Done").fontWeight(Font.Weight.bold).foregroundColor(.black)
								}.padding()
									.frame(maxWidth: 600)
									.background(RoundedRectangle(cornerRadius: 10)
										.foregroundColor(Color.white).shadow(radius: 1))
								
							}
						}
						.frame(width: gr.size.width, height: gr.size.height)
						.zIndex(100)
						.offset(y:-300)
					}
				}
			} else if (colorState){ // if a command is dropped which uses colors
				VStack() {
					Text("")
						.hidden()
				}.blur(radius: $colorState.wrappedValue ? 1 : 0)
					.overlay(
						$colorState.wrappedValue ? Color.black.opacity(0.6) : nil
				)
				if $colorState.wrappedValue {
					GeometryReader { gr in
						VStack {
							VStack {
								Text("Colors")
									.font(.headline)
									.foregroundColor(.gray)
									.padding(.top, 10)
								Text("Choose a color")
									.padding(.top, 5)
									.foregroundColor(.black)
								Picker("test", selection: self.$slectedObj) {
									ForEach(0 ..< self.colorArray.count) {
										Text(self.colors[$0]).tag($0)
									}
								}
								.foregroundColor(.black)
								.labelsHidden()
							}.background(RoundedRectangle(cornerRadius: 10)
								.foregroundColor(Color.white).shadow(radius: 1))
							VStack {
								Button(action: {
									debugPrint("Done Selected")
									self.colorState = false
									self.pickerMovement.value = self.slectedObj + 1
									
									self.pickerMovement.activeCommands[self.pickerMovement.count - 1].1 = self.pickerMovement.value
									self.pickerMovement.value = 0
									//self.slectedObj = 0
								}) {
									Text("Done").fontWeight(Font.Weight.bold).foregroundColor(.black)
								}.padding()
									.frame(maxWidth: 600)
									.background(RoundedRectangle(cornerRadius: 10)
										.foregroundColor(Color.white).shadow(radius: 1))
								
							}
						}
						.frame(width: gr.size.width, height: gr.size.height)
						.zIndex(100)
						.offset(y:-300)
					}
				}
			}
		}.edgesIgnoringSafeArea(.all)
	}
}

extension View {
	func inputPicker(movementState: Binding<Bool>, degreeState: Binding<Bool>, colorState: Binding<Bool>) -> some View {
		self.modifier(blockPicker(movementState: movementState, degreeState: degreeState, colorState: colorState))
	}
}

struct MainBodyView_Previews: PreviewProvider {
	static var previews: some View {
		MainBodyView()
			.background(Color.black)
	}
}
