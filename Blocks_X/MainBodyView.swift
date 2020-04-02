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
//	@State private var activeCommands = [Int] (repeating: 6, count: 30) // contains the actual blocks in list
//	@State private var commandFrames = [CGRect](repeating: .zero, count: 1) // the frame of the list area
	@State private var dropBlock = [Int] (repeating: 13, count: 1) // the value of the block where commands are dropped
	@State private var dropArea = [CGRect](repeating: .zero, count: 1) // the frame of the area to drop commands
//	@State public var count = 0 // keeps track of which block has been filled in the list
	@State private var enablePicker = false
	
	
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
						
//						Spacer()
						
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
												.inputPicker(state: self.$enablePicker)
												.onAppear{
													self.dropArea[0] = geos.frame(in: .global)
											}
										}
								)
								.zIndex(4)
								
								
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
		print("Build count: ", pickerMovement.count)
		pickerMovement.count = pickerMovement.count+1
	}
	
	func startApp() {
		let commands = [0,1,2,3,4,5]
		commandList = commands
	}
	
	func commandDropped(location: CGPoint, blockIndex: Int, block: Block) {
		if pickerMovement.count < 30 {
			enablePicker = true
			//print(enablePicker)
			pickerMovement.activeCommands[pickerMovement.count].0 = block.id + 7
			commandList[blockIndex] = block.id
			increaseCount()
			
		}
	}
	func commandMoved(location: CGPoint, block: Block) -> DragState {
		//print(location)
		if let match = pickerMovement.commandFrames.firstIndex(where: {$0.contains(location)}){
			if pickerMovement.activeCommands[match].0 != 13 {
				return .bad
			}
			else {
				//	print("this is good: ", activeCommands[match])
				return .good
			}
		} else if let dropMatch = dropArea.firstIndex(where: {$0.contains(location)}){
			if(dropBlock[dropMatch] == 13) {
				if pickerMovement.count < 30 {
					if pickerMovement.activeCommands[pickerMovement.count].0 != 6 {
							return .bad
						} else {
							return .good
						}
				} else {
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

struct blockPicker: ViewModifier {
	@EnvironmentObject var pickerMovement: UserSettings
	@Binding var state: Bool

	let inputArray = ["01","02","03","04","05","06","07","08","09","10"]
	@State var slectedObj = 0

    func body(content: Content) -> some View {
		ZStack {
			VStack() {
				Text("")
					.hidden()
			}.blur(radius: $state.wrappedValue ? 1 : 0)
				.overlay(
					$state.wrappedValue ? Color.black.opacity(0.6) : nil
			)
		   if $state.wrappedValue {
				GeometryReader { gr in
					VStack {
						VStack {
							Text("PickerView")
								.font(.headline)
								.foregroundColor(.gray)
								.padding(.top, 10)
							Text("Choose Value")
								.padding(.top, 5)
								.foregroundColor(.black)
							Picker("test", selection: self.$slectedObj) {
								ForEach(0 ..< self.inputArray.count) {
									Text(self.inputArray[$0]).tag($0)
								}
							}
							.foregroundColor(.black)
							.labelsHidden()
//							.onReceive([self.slectedObj].publisher.first()) { (value) in
//								print(value)}
						}.background(RoundedRectangle(cornerRadius: 10)
							.foregroundColor(Color.white).shadow(radius: 1))
						VStack {
							Button(action: {
								debugPrint("Done Selected")
								self.state = false
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
		}.edgesIgnoringSafeArea(.all)
    }
}

extension View {
    func inputPicker(state: Binding<Bool>) -> some View {
		self.modifier(blockPicker(state: state))
    }
}

struct MainBodyView_Previews: PreviewProvider {
	static var previews: some View {
		MainBodyView()
			.background(Color.black)
	}
}