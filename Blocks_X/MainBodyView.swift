//
//  MainBodyView.swift
//  Blocks_X
//
//  Created by elber on 3/25/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI

struct MainBodyView: View {
	@EnvironmentObject var globalVariables: UserSettings
	
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
						
						// The list of draggble commands created on the left hand side of the Playground.
						VStack {
							ForEach(0..<4){ number in
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
							self.globalVariables.scrollViewCommands = [(Int, Int)]  (repeating: (6,0), count: 30)
							self.globalVariables.count = 0
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
				
				// Start of the right side of the main playground view.
				ZStack(alignment: .leading) {
					GeometryReader { geo in
						HStack {
							Spacer()
							Spacer()
							
							VStack {
								
								// This is the scrollable area in the middle of the screen where the commands appear once they are dropped in the droppable area. It is automatically populated with the original values from the self.globalVariables.scrollViewCommands array of tuples with (0,0) that are mapped from our JSON file to an empty block. The index is updated incrementally to match the size of the self.globalVariables.scrollViewCommands array. It's location on the screen is tracked by the self.globalVariables.scrollViewFrame with the GeometryReader. The self.globalVariables.scrollViewFrame is a big rectangle around the entire ScrollView which prevents any blocks from being dropped into that area and returns a .bad state whenever one drags a command over it.
								VStack {
									ScrollView(.vertical) {
										ForEach(0..<30){ number in
											BlockRow(blockVar: blockData[self.globalVariables.scrollViewCommands[number].0], onChanged: self.commandMoved, index: number, newMovement: self.globalVariables.scrollViewCommands[number].1)
										}
										.padding(.vertical, 5)
										.frame(width: 500)
									}
									.overlay(
										GeometryReader { geos in
											Color.clear
												.onAppear{
													self.globalVariables.scrollViewFrame[0] = geos.frame(in: .global)
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
								
								// This is the drop area. blockData[13] is the element from the JSON file which corresponds to the drop area element. It does not need an index or newMovement value as this element will never be replaced. It uses the GeometryReader to keep track of it's location on the screen.
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
                                        let count = self.globalVariables.count
                                        if count > 0 {
                                            self.globalVariables.scrollViewCommands[count-1] = (6,0)
                                            self.globalVariables.count -= 1
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
		
		sleep(10)
		
		var commands: [(commandType: Int, unit: Int)] = []
		for value in 0..<30 {
			if(globalVariables.scrollViewCommands[value].0 != 6 && globalVariables.scrollViewCommands[value].0 != 11){
				print(globalVariables.scrollViewCommands[value])
				commands.append((globalVariables.scrollViewCommands[value].0, globalVariables.scrollViewCommands[value].1))
			}
		}
	}
	
	func increaseCount() {
		print("Build count: ", globalVariables.count)
		globalVariables.count = globalVariables.count+1
	}
	
	func startApp() {
		let commands = [0,1,2,3,4,5]
		commandList = commands
	}
	
	
// This function handles the event of a command being dropped.
	func commandDropped(location: CGPoint, blockIndex: Int, block: Block) {
		let newBlockID = block.id + 7 // Used to map the command that is dropped from a draggable version of the block, to a non-dragabble version of the block that will appear in the ScrollView.
		
		if globalVariables.count < 30 { // Max amount of commands in the ScrollView
			if(newBlockID == 7 || newBlockID == 8){
				enableMovementPicker = true // Overlays the picker that uses distances.
				
			} else if (newBlockID == 9 || newBlockID == 10) {
				enableDegreePicker = true // Overlays the picker that uses degrees.
				
			} else if (newBlockID == 12) {
				enableColorPicker = true // // Overlays the picker that uses colors.
				
			} else { // This is used for the "Stop" command where no picker is necessary.
				enableDegreePicker = false
				enableMovementPicker = false
				enableColorPicker = false
				
			}
			// globalVariables.scrollViewCommands is updated from an empty block in the ScrollView, to a non-draggable version of the block that was dragged and dropped in the droppable area.
			globalVariables.scrollViewCommands[globalVariables.count].0 = newBlockID
			
			// List of commands on the left hand side replaces the block that was just dropped.
			commandList[blockIndex] = block.id
			
			// Updates the stop tuple value to (11,1) in order to avoid conflicting instantiation of non-draggable version.
			if(newBlockID == 11){
				self.globalVariables.scrollViewCommands[self.globalVariables.count].1 = 1
			}
			
			// increases counter which tracks how many elements are in the ScrollView.
			increaseCount()
		}
	}
	
// This function handles the event when a command is being dragged.
	func commandMoved(location: CGPoint, block: Block) -> DragState {
		
		if let scrollViewMatch = globalVariables.scrollViewFrame.firstIndex(where: {$0.contains(location)}){ // Checks if command is being dragged over the ScrollView area. The variable scrollViewMatch will only be instantiated if the command is over the ScrollView area, otherwise it will move to the next case.
			
			if globalVariables.scrollViewCommands[scrollViewMatch].0 == 6 { // If the current block is being dragged over the ScrollView area then 'globalVariables.scrollViewCommands[scrollViewMatch].0' will equal 6.
				
				if(timeRemaining == 1) { // Our current audio cue implementation is the call the playSound command if the 3 second global countdown timer is at 1.
					playSound(sound: "bad-sound", type: "mp3")
				}
				
				// Will return a bad state when command is dragged over ScrollView as commands cannot be dropped here.
				return .bad
			}
			
			else { // This else case is unreachable based on the current implementation. In the future it could be used to drop commands straight into the ScrollView area.
				return .good
			}
			
		} else if let dropMatch = dropArea.firstIndex(where: {$0.contains(location)}){  // Checks if command is being dragged over the drop area. The variable dropMatch will only be instantiated if the command is over the drop area, otherwise it will move to the next case.
			
			if(dropBlock[dropMatch] == 13) {  // If the current block is being dragged over the drop area then 'dropBlock[dropMatch]' will equal 13. This corresponds to the JSON element that maps to the Drop Area.
				
				if globalVariables.count < 30 { // Checks to make sure there is available room in the ScrollView.
					
					if globalVariables.scrollViewCommands[globalVariables.count].0 == 6 { // Checks that the ScrollView has an empty slot which corresponds to the value 6 in the JSON file.
						if(timeRemaining == 1) {
							playSound(sound: "good-sound", type: "mp3")
						}
						// Will return a good state when command is dragged over Drop Area and meets the requirements for a command to be dropped.
						return .good
					} else {
						return .bad
					}
				} else { // When the ScrollView is full, it will not allow more commands to be dropped
					if(timeRemaining == 1) {
						playSound(sound: "bad-sound", type: "mp3")
					}
					return .bad
				}
			} else { // This else case is unreachable based on the current implementation as it will not be triggered unless command block is over the Drop Area.
				return .unknown
			}
		} else { // If the command is being dragged over an area that is not the ScrollView or the Drop Area, it will return an unknown state.
			return .unknown
		}
	}
}

// Handles the 3 different types of pickers used when a command is dropped
struct blockPicker: ViewModifier {
	@EnvironmentObject var globalVariables: UserSettings
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
									
									self.globalVariables.value = self.slectedObj + 1
									self.globalVariables.scrollViewCommands[self.globalVariables.count - 1].1 = self.globalVariables.value
									self.globalVariables.value = 0
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
									self.globalVariables.value = self.slectedObj + 1
									
									self.globalVariables.scrollViewCommands[self.globalVariables.count - 1].1 = self.globalVariables.value * 15
									self.globalVariables.value = 0
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
									self.globalVariables.value = self.slectedObj + 1
									
									self.globalVariables.scrollViewCommands[self.globalVariables.count - 1].1 = self.globalVariables.value
									self.globalVariables.value = 0
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
