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
			Text("Welcome!")
			
			Spacer()
			
			HStack {
				BlockList().frame(width: 300, height: 650).background(Color.gray)
				Spacer()
				VStack(alignment: .leading) {
					Section {
						Text("Drag Code Here")
					}
					.frame(width: 800, height: 500).background(Color.gray)
				}
				.padding()

				Spacer()
			}
			Spacer()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(block: blockData[0])
    }
}
