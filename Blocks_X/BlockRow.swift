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
		VStack{
			Text(block.name)
			Image(systemName: block.systemName)
				.resizable()
				.frame(width: 30, height: 30)
            }.padding(.all, 10)
            .overlay(Rectangle().opacity(0.4)
                .frame(width: 130, height: 90)
                .foregroundColor(Color.blue))
    }
}

struct BlockRow_Previews: PreviewProvider {
    static var previews: some View {
		BlockRow(block: blockData[0])
    }
}
