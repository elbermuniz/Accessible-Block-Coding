//
//  ContentView.swift
//  Blocks_X
//
//  Created by elber on 2/26/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	//@EnvironmentObject var pickerMovement: UserSettings
	let views = ["Playground", "Tutorial"]
	@State private var playgroundShowing = false
	@State private var tutorialShowing = false
	
	//var block: Block
	
	var body: some View {
		VStack {
			GeometryReader { geometry in
				NavigationView {
					ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
						Color.black.edgesIgnoringSafeArea(.all)
						
						// A card-like view that is initially offscreen,
						// and slides on when detailShowing == true
						if(self.playgroundShowing){
							MainBodyView()
						} else if(self.tutorialShowing){
							MainHeaderView()
						}
						
						if(!self.playgroundShowing && !self.tutorialShowing){
							HStack{
								Text("Block X")
									.fontWeight(.black)
							}
							.multilineTextAlignment(.center)
							.padding(.bottom, -15.0)
							.font(.system(size: 72))
							.foregroundColor(.white)
						}
						
						VStack{
							// Just here to change state
							Spacer()
							
							Button(action: {
								self.playgroundShowing.toggle()
							}) {
								ZStack{
									Rectangle()
										.cornerRadius(12)
									Text("Playground")
										.font(.largeTitle)
										.fontWeight(.heavy)
										.foregroundColor(.white)
								}
							}
							.animation(.default)
							.frame(width: 400, height: 120)
							.offset(x: 0, y: self.playgroundShowing || self.tutorialShowing ? geometry.size.height : 0)
							
							
							Button(action: {
								self.tutorialShowing.toggle()
							}) {
								ZStack{
									Rectangle()
										.cornerRadius(12)
									Text("Tutorial")
										.font(.largeTitle)
										.fontWeight(.heavy)
										.foregroundColor(.white)
								}
							}
							.animation(.linear)
							.frame(width: 400, height: 120)
							.offset(x: 0, y: self.playgroundShowing || self.tutorialShowing ? geometry.size.height : 0)
							
							Spacer()
						}
					}
						// This is the key modifier
						.navigationBarHidden(!self.playgroundShowing && !self.tutorialShowing)
						.navigationBarTitle("Welcome!", displayMode: .inline)
						.navigationBarItems(leading:
							Button(action: {
								self.playgroundShowing = false
								self.tutorialShowing = false
							}) {
								HStack{
									Image(systemName: "chevron.left")
										.font(.title)
										.padding(.leading)
									Text("BlockX")
										.font(.headline)
										.fontWeight(.heavy)
								}.foregroundColor(.blue)
							}
							,trailing:
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
								.padding(7)
								.foregroundColor(.white)
								.background(Color.blue)
								.cornerRadius(90)
							}
					)
				}
				.frame(width: geometry.size.width, height: geometry.size.height)
				.navigationViewStyle(StackNavigationViewStyle())
				//.frame(width: geometry.size.width, height: geometry.size.height)
			}
		}
		.background(self.playgroundShowing || self.tutorialShowing ? Color.gray: Color.black).edgesIgnoringSafeArea(.bottom)
		//		VStack{
		//			GeometryReader { geometry in
		//				VStack {
		//					// Start of header section
		//					MainHeaderView()
		//						.frame(height: geometry.size.height * (0.14))
		//					// End of header section
		//
		//					//Spacer()
		//
		//					MainBodyView()
		//						.frame(height: geometry.size.height * (0.86))
		//						.padding(.top, -10)
		//
		//					// End of center area
		//					//Spacer()
		//				}
		//				.frame(width: geometry.size.width)
		//				.zIndex(1)
		//			}
		//		}
		//		.background(Color.black).edgesIgnoringSafeArea(.vertical)
		//		.zIndex(0)
	}
}

struct DetailView: View {
	//let view: String
	var body: some View{
		VStack{
			MainBodyView()
		}
	}
}



struct ContentView_Previews: PreviewProvider { //doesn't execute in app
	static var previews: some View {
		//ContentView(block: blockData[0])
		ContentView()
	}
}
