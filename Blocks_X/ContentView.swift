//
//  ContentView.swift
//  Blocks_X
//
//  Created by elber on 2/26/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI

struct ContentView: View {
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
						print("Volume tapped!")
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

					BlockList()
						.frame(width: 250, height: 600)
				}
				.frame(width: 250.0)
				.background(Color.gray)
				.zIndex(10)
// End of commands area

				//Spacer()

// Start of drop area and top and bottom buttons
				ZStack(alignment: .leading) {
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
					}
					.padding(.trailing, 10)
					.offset(x: 800, y: -290)

// Main drop area
					Section {
						Text("Drag and drop commands into this area!")
							.font(.headline)
							.fontWeight(.light)
							.foregroundColor(Color.white)
							.multilineTextAlignment(.center)
							.frame(width: 120.0)
					}
					.frame(width: 946, height: 660).background(Color(red: 0.6, green: 0.6, blue: 0.6, opacity: 0.2))
					//.padding(.leading, 0)
					.zIndex(-1)
					.border(/*@START_MENU_TOKEN@*/Color.white/*@END_MENU_TOKEN@*/, width: 7)

// Botttom row of buttons
					HStack(spacing: 0.0) {
						//Spacer()
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
					.offset(x: 800, y: 290)
				}
				.offset(x:-8)
// End of main drop area

				//Spacer()
			}
			.padding(.top, -30.0)
			
// End of center area
			Spacer()
		}
		.background(Color.black)
	}
}


struct ContentView_Previews: PreviewProvider { //doesn't execute in app
    static var previews: some View {
       ContentView(block: blockData[0])
		//ContentView()
    }
}
