//
//  BlockRow.swift
//  Blocks_X
//
//  Created by elber on 2/27/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI

struct BlockRow: View {
	
	var block: Block
	
    var body: some View {
		HStack{
			Text(block.name)
				.font(.body)
			Image(systemName: block.systemName)
				.resizable()
				.frame(width: 30, height: 30)
			Spacer()
		}.padding(.all, 10)
    }
}

struct BlockRow_Previews: PreviewProvider {
    static var previews: some View {
		BlockRow(block: blockData[0])
    }
}
