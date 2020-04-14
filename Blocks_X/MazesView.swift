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
				Rectangle()
					.fill(
						RadialGradient(gradient: self.gradient, center: .center, startRadius: 1, endRadius: 1100)
				).edgesIgnoringSafeArea(.all)
				
				VStack {
					Text("Map Selector")
						.fontWeight(.light)
						.shadow(color: Color.blue, radius: 15)
						.shadow(color: Color.white, radius: 5)
						.multilineTextAlignment(.center)
						.padding(.top, 10.0)
						.font(.system(size: 72))
						.foregroundColor(.white)
					
					
					ToggleArea()
						.padding(.top, -45)
						.frame(width: geometry.size.width * (0.40))
					
					Spacer()
				}
				.frame(width: geometry.size.width)
			}
			.frame(minWidth: geometry.size.width)
			.zIndex(10)
		}
	}
}

extension MazesView {
	struct ToggleArea: View {
		@State var showEasy:Bool = true
		@State var showMedium:Bool = false
		@State var showHard:Bool = false
		
		var body: some View {
			let on1 = Binding<Bool>(get: { self.showEasy }, set: { self.showEasy = $0; self.showMedium = false; self.showHard = false })
			let on2 = Binding<Bool>(get: { self.showMedium }, set: { self.showEasy = false; self.showMedium = $0; self.showHard = false })
			let on3 = Binding<Bool>(get: { self.showHard }, set: { self.showEasy = false; self.showMedium = false; self.showHard = $0 })
			
			return VStack{
				
				VStack{
					Toggle(isOn: on1) {
						Text("Show Easy Map")
							.fontWeight(.heavy)
							.padding(.leading, 5)
					}.padding(.all, 7)
					Divider()
					Toggle(isOn: on2) {
						Text("Show Medium Map")
							.fontWeight(.heavy)
							.padding(.leading, 5)
					}.padding(.all, 7)
					Divider()
					Toggle(isOn: on3) {
						Text("Show Hard Map")
							.fontWeight(.heavy)
							.padding(.leading, 5)
					}.padding(.all, 7)
				}
				.foregroundColor(.white)
				.background(Color.black)
				
				VStack{
					if showEasy {
						Text("Easy")
					} else if showMedium {
						Text("Medium")
					} else if showHard {
						Text("Hard")
					}
					
					MapArea(easyMap: showEasy, mediumMap: showMedium, hardMap: showHard)
				}
			}
		}
	}
	
	struct GridStack<Content: View>: View {
		let rows: Int
		let columns: Int
		let content: (Int, Int) -> Content
		
		var body: some View {
			VStack {
				ForEach(0 ..< rows, id: \.self) { row in
					HStack {
						ForEach(0 ..< self.columns, id: \.self) { column in
							self.content(row, column)
						}
					}
				}
			}
		}
		
		init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
			self.rows = rows
			self.columns = columns
			self.content = content
		}
	}
	
	
	// row and col info is within the view
	
	struct EasyMap: View {
		var body: some View {
			GeometryReader { geometry in
				GridStack(rows: 3, columns: 3) { row, col in
					if(row == 0 && col == 0){
						VStack {
							Image(systemName: "star.circle")
							Text("Starting Spot")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.green)
					} else if(row == 0 && col == 1){
						VStack {
							Image(systemName: "exclamationmark.octagon")
							Text("Obstacle")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.red)
					}else if(row == 1 && col == 1){
						VStack {
							Image(systemName: "exclamationmark.octagon")
							Text("Obstacle")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.red)
					} else if(row == 0 && col == 2){
						VStack {
							Image(systemName: "flag.circle")
							Text("Finish")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.green)
					} else {
						VStack{
							//Image(systemName: "square")
							
							// This is the row and col info:
							
							//Text("R\(row) C\(col)")
							Image("circle").hidden()
							Text("Open Spot")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.white)
					}
				}
					//.border(Color.black)
					.background(Color.clear)
					.frame(width: geometry.size.width, height: geometry.size.height)
			}
		}
	}
	
	struct MediumMap: View {
		var body: some View {
			GeometryReader { geometry in
				GridStack(rows: 4, columns: 4) { row, col in
					if(row == 0 && col == 0){
						VStack {
							Image(systemName: "star.circle")
							Text("Starting Spot")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.green)
					} else if(row == 3 && col == 0){
						VStack {
							Image(systemName: "exclamationmark.octagon")
							Text("Obstacle")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.red)
					} else if(row == 0 && col == 1){
						VStack {
							Image(systemName: "exclamationmark.octagon")
							Text("Obstacle")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.red)
					}else if(row == 0 && col == 2){
						VStack {
							Image(systemName: "exclamationmark.octagon")
							Text("Obstacle")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.red)
					} else if(row == 1 && col == 1){
						VStack {
							Image(systemName: "exclamationmark.octagon")
							Text("Obstacle")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.red)
					} else if(row == 0 && col == 2){
						VStack {
							Image(systemName: "exclamationmark.octagon")
							Text("Obstacle")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.red)
					} else if(row == 1 && col == 2){
						VStack {
							Image(systemName: "exclamationmark.octagon")
							Text("Obstacle")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.red)
					} else if(row == 2 && col == 2){
						VStack {
							Image(systemName: "exclamationmark.octagon")
							Text("Obstacle")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.red)
					}else if(row == 0 && col == 3){
						VStack {
							Image(systemName: "flag.circle")
							Text("Finish")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.green)
					} else {
						VStack{
							//Image(systemName: "square")
							
							// This is the row and col info:
							
							//Text("R\(row) C\(col)")
							Image("circle").hidden()
							Text("Open Spot")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.white)
					}
				}
					//.border(Color.black)
					//.background(Color.white)
					.frame(width: geometry.size.width, height: geometry.size.height)
			}
		}
	}
	
	struct HardMap: View {
		var body: some View {
			GeometryReader { geometry in
				GridStack(rows: 5, columns: 4) { row, col in
					if(row == 0 && col == 0){
						VStack {
							Image(systemName: "star.circle")
							Text("Starting Spot")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.green)
					} else if(row == 0 && col == 1){
						VStack {
							Image(systemName: "exclamationmark.octagon")
							Text("Obstacle")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.red)
					} else if(row == 1 && col == 1){
						VStack {
							Image(systemName: "exclamationmark.octagon")
							Text("Obstacle")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.red)
					}else if(row == 2 && col == 1){
						VStack {
							Image(systemName: "exclamationmark.octagon")
							Text("Obstacle")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.red)
					} else if(row == 3 && col == 1){
						VStack {
							Image(systemName: "exclamationmark.octagon")
							Text("Obstacle")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.red)
					} else if(row == 3 && col == 2){
						VStack {
							Image(systemName: "exclamationmark.octagon")
							Text("Obstacle")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.red)
					} else if(row == 1 && col == 3){
						VStack {
							Image(systemName: "exclamationmark.octagon")
							Text("Obstacle")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.red)
					} else if(row == 0 && col == 3){
						VStack {
							Image(systemName: "flag.circle")
							Text("Finish")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.green)
					} else {
						VStack{
							//Image(systemName: "square")
							
							// This is the row and col info:
							
							//Text("R\(row) C\(col)")
							Image("circle").hidden()
							Text("Open Spot")
						}
						.frame(width: 120, height: 80)
						.padding(.all, 0)
						.background(Color.white)
					}
				}
					.frame(width: geometry.size.width, height: geometry.size.height)
			}
		}
	}
	
	struct MapArea: View {
		let easyMap: Bool
		let mediumMap: Bool
		let hardMap: Bool
		
		var body: some View {
			GeometryReader { geo in
				HStack {
					if self.easyMap{
						EasyMap()
							.frame(width: geo.size.width * 2, height: geo.size.height)
					} else if self.mediumMap {
						MediumMap()
							.frame(width: geo.size.width * 2, height: geo.size.height)
					} else if self.hardMap {
						HardMap()
							.frame(width: geo.size.width * 2, height: geo.size.height)
					}
				}
			}
		}
	}
}

struct MazesView_Previews: PreviewProvider {
	static var previews: some View {
		MazesView()
	}
}
