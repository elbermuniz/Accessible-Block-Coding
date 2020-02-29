//
//  BlockList.swift
//  Blocks_X
//
//  Created by elber on 2/28/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI

struct BlockList: View {
    var body: some View {
		List(blockData) { (block) -> BlockRow in
			
			BlockRow(block: block)
		}.padding()
		
    }
}

struct BlockList_Previews: PreviewProvider {
    static var previews: some View {
        BlockList()
    }
}
