//
//  SliderView.swift
//  Blocks_X
//
//  Created by elber on 3/25/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI

struct SliderView: View {
	@State private var amount: Double = 1
    var body: some View {
		VStack {
			Text("Increase Move Amount:").offset(y:20)
			HStack {
				Slider(value: $amount, in: 1...15, step: 1)
					.frame(width: 200)
				Text("\(Int(amount))")
			}
		}
		.frame(width: 250)
    }
}

struct SliderView_Previews: PreviewProvider {
    static var previews: some View {
        SliderView()
    }
}
