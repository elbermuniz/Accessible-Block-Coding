//
//  Header.swift
//  Blocks_X
//
//  Created by elber on 3/25/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI

struct MainHeaderView: View {
	var body: some View {
		GeometryReader { geometry in
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
						.padding()
						.foregroundColor(.white)
						.background(Color.blue)
						.cornerRadius(90)
					}
					.padding(.trailing)
				}
			}
//			.frame(minWidth: 0, maxWidth: geometry.size.width, minHeight:0, maxHeight: geometry.size.height)
				.frame(minWidth: 0, maxWidth: geometry.size.width, minHeight:0, maxHeight: 110).background(Color.gray)
		}
	}
}

struct Header_Previews: PreviewProvider {
    static var previews: some View {
        MainHeaderView()
    }
}
