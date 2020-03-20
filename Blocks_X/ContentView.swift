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
			HStack {
				Text("BlockX")
					.padding(.leading)
				Spacer()
				Text("Welcome!")
					.multilineTextAlignment(.center)
					.padding([.top, .leading, .bottom], 10.0)
				Spacer()
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
			.frame(height: 100.0)
			.background(Color.gray)
			
			Spacer()
			
			HStack {
				VStack{
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
					
					BlockList().frame(width: 200, height: 600)
				}
				.frame(width: 200.0)
				.background(Color.gray)
				
				Spacer()
				
				VStack(alignment: .leading) {
					HStack(spacing: 0.0) {
						Spacer()
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
					
					Section {
						Text("Drag and drop commands into this area!")
							.font(.headline)
							.fontWeight(.light)
							.multilineTextAlignment(.center)
							.frame(width: 120.0)
					}
					.frame(width: 800, height: 500).background(Color.gray)
					
					HStack(spacing: 0.0) {
						Spacer()
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
							.padding()
							.foregroundColor(.white)
							.background(Color.blue)
							.cornerRadius(90)
						}
					}
				}
				.padding()

				Spacer()
			}
			.padding(.top, -30.0)
			
			Spacer()
		}
	}
}

//struct BlockView: View {
//    let block: Block
//    
//    var body: some View {
//        VStack {
//            Image(system)
//        }
//    }
//}
struct ContentView_Previews: PreviewProvider { //doesn't execute in app
    static var previews: some View {
        ContentView(block: blockData[0])
    }
}
