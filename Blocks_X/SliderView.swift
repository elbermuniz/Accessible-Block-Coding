//
//  SliderView.swift
//  Blocks_X
//
//  Created by elber on 3/25/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI

struct SliderView: View {
	var colors = ["Red", "Green", "Blue", "Tartan"]
	@State private var selectedColor = 0
	
    var body: some View {
		VStack {
		   Picker(selection: $selectedColor, label: Text("Please choose a color")) {
			  ForEach(0 ..< colors.count) {
				 Text((self.colors[$0]))
			  }
		   }
			.pickerStyle(WheelPickerStyle())
		   Text("You selected: \(colors[selectedColor])")
		}
	}
}

struct SliderView_Previews: PreviewProvider {
    static var previews: some View {
        SliderView()
    }
}
