//
//  ContentView.swift
//  Blocks_X
//
//  Created by elber on 2/26/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI

struct ContentView: View {	
	@State private var playgroundShowing = false
	@State private var tutorialShowing = false
	@State private var mazesShowing = false
	
	let views = ["Playground", "Tutorial", "Mazes"]
	let gradient = Gradient(colors: [.gray, .black])
	
	var body: some View {
		VStack {
			GeometryReader { geometry in
				NavigationView {
					ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
						//Color.black.edgesIgnoringSafeArea(.all)
						Rectangle()
							.fill(
								RadialGradient(gradient: self.gradient, center: .center, startRadius: 1, endRadius: 1100)
						).edgesIgnoringSafeArea(.all)
						
						// A card-like view that is initially offscreen,
						// and slides on when detailShowing == true
						if(self.playgroundShowing){
							MainBodyView()
						} else if(self.tutorialShowing){
							TutorialView().environmentObject(PlayerState())
						} else if(self.mazesShowing){
							MazesView()
						}
						
						if(!self.playgroundShowing && !self.tutorialShowing && !self.mazesShowing){
							HStack{
								Text("CodeSphere")
									.fontWeight(.light)
									.shadow(color: Color.blue, radius: 15)
									.shadow(color: Color.white, radius: 5)
							}
							.multilineTextAlignment(.center)
							.padding(.top, 30.0)
							.font(.system(size: 100))
							.foregroundColor(.white)
						}
						
						VStack{
							// Just here to change state
							Spacer()
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
							.shadow(color: Color.blue, radius: 10)
							.shadow(color: Color.white, radius: 10)
							.animation(.easeInOut)
							.frame(width: 400, height: 120)
							.offset(x: 0, y: self.playgroundShowing || self.tutorialShowing || self.mazesShowing ? geometry.size.height : 0)
							.padding()
							
							
							Button(action: {
								self.mazesShowing.toggle()
							}) {
								ZStack{
									Rectangle()
										.cornerRadius(12)
									Text("Example Maps")
										.font(.largeTitle)
										.fontWeight(.heavy)
										.foregroundColor(.white)
								}
							}
							.shadow(color: Color.blue, radius: 10)
							.shadow(color: Color.white, radius: 10)
							.animation(.linear)
							.frame(width: 400, height: 120)
							.offset(x: 0, y: self.playgroundShowing || self.tutorialShowing || self.mazesShowing ? geometry.size.height : 0)
							.padding()

							
							
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
							.shadow(color: Color.blue, radius: 10)
							.shadow(color: Color.white, radius: 10)
							.animation(.interactiveSpring())
							.frame(width: 400, height: 120)
							.offset(x: 0, y: self.playgroundShowing || self.tutorialShowing || self.mazesShowing ? geometry.size.height : 0)
							.padding()

							
							Spacer()
							if(!self.playgroundShowing && !self.tutorialShowing && !self.mazesShowing){
								HStack{
									Text("Sphero Device & iOS 13+ Necessary")
										.fontWeight(.light)
								}
								.multilineTextAlignment(.center)
								.padding(.bottom, geometry.size.height * (0.05))
								.font(.system(size: 16))
								.foregroundColor(.white)
							}}
					}
						// This is the key modifier
						.navigationBarHidden(!self.playgroundShowing && !self.tutorialShowing && !self.mazesShowing)
						.navigationBarTitle("Welcome!", displayMode: .inline)
						.navigationBarItems(leading:
							Button(action: {
								self.playgroundShowing = false
								self.tutorialShowing = false
								self.mazesShowing = false
							}) {
								HStack{
									Image(systemName: "chevron.left")
										.font(.title)
										.padding(.leading)
									Text("Home")
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
										.font(.headline)
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
			}
		}
		.background(self.playgroundShowing || self.tutorialShowing || self.mazesShowing ? Color.gray: Color.white).edgesIgnoringSafeArea(.bottom)
	}
}

struct ContentView_Previews: PreviewProvider { //doesn't execute in app
	static var previews: some View {
		//ContentView(block: blockData[0])
		ContentView()
	}
}
