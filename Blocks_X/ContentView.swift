//
//  ContentView.swift
//  Blocks_X
//
//  Created by elber on 2/26/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	@EnvironmentObject var pickerMovement: UserSettings
	
	@State private var activeCommands: [[Int]] = Array(repeating: Array(repeating: 6, count: 6), count: 5)
	@State private var commandList = [Int] (repeating: 0, count: 6)
	@State private var commandFrames = [CGRect](repeating: .zero, count: 30)
	@State private var count = 0
	
	var block: Block
	
	var body: some View {
		VStack{
			GeometryReader { geometry in
                    VStack {
                        // Start of header section
                        MainHeaderView()
                            .frame(height: geometry.size.height * (0.14))
                        // End of header section
                        
                        //Spacer()
                        
                        MainBodyView()
                            .frame(height: geometry.size.height * (0.86))
                            .padding(.top, -10)
                        
                        // End of center area
                        //Spacer()
                    }
                    .frame(width: geometry.size.width)
                    .zIndex(1)
                
			}
		}
		.background(Color.black).edgesIgnoringSafeArea(.vertical)
		.zIndex(0)
	}
}



struct ContentView_Previews: PreviewProvider { //doesn't execute in app
	static var previews: some View {
		ContentView(block: blockData[0])
		//ContentView()
	}
}
