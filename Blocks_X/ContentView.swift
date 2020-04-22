//
//  ContentView.swift
//  Blocks_X
//
//  Created by elber on 2/26/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI

let controller = SpheroController()

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
						Rectangle()
							.fill(
								RadialGradient(gradient: self.gradient, center: .center, startRadius: 1, endRadius: 1100)
						).edgesIgnoringSafeArea(.all)

						if(self.playgroundShowing){
							MainBodyView()
						} else if(self.tutorialShowing){
							TutorialView().environmentObject(PlayerState())
						} else if(self.mazesShowing){
							MazesView()
						}
						
						if(!self.playgroundShowing && !self.tutorialShowing && !self.mazesShowing){ // Main home page view
							HStack{
								Text("BlockX")
									.fontWeight(.light)
									.shadow(color: Color.blue, radius: 15)
									.shadow(color: Color.white, radius: 5)
							}
							.multilineTextAlignment(.center)
							.padding(.top, 30.0)
							.font(.system(size: 100))
							.foregroundColor(.white)
							.accessibility(label: Text("BlockX"))
							.accessibility(hint: Text("Application Title"))
							.accessibility(hidden: self.playgroundShowing || self.tutorialShowing || self.mazesShowing ? true: false)
						}
						
						VStack{
							Spacer()
							Spacer()
							
							// When playground button is toggled, home view slides away and displays playground view.
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
							.accessibility(label: Text("Playground"))
							.accessibility(hint: Text("Tap to open the coding playground."))
							.accessibility(hidden: self.playgroundShowing || self.tutorialShowing || self.mazesShowing ? true: false)
							
							
							// When example maps button is toggled, home view slides away and displays example maps view.
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
							.accessibility(label: Text("Example maps"))
							.accessibility(hint: Text("Tap to view the example maps."))
							.accessibility(hidden: self.playgroundShowing || self.tutorialShowing || self.mazesShowing ? true: false)

							
							// When tutorial button is toggled, home view slides away and displays tutorial view.
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
							.accessibility(label: Text("Tutorial"))
							.accessibility(hint: Text("Tap to view the app tutorial."))
							.accessibility(hidden: self.playgroundShowing || self.tutorialShowing || self.mazesShowing ? true: false)

							
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
						// This the navigation menu across the entire application
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
								print("Sync Robot!")
                                controller.connectToSpheroIfAvailable()
							}) {
								HStack {
									Text("Sync Robot")
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
		ContentView()
	}
}
