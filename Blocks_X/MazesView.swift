//
//  MazesView.swift
//  Blocks_X
//
//  Created by elber on 4/8/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI

struct MazesView: View {
    var body: some View {
        GridStack(rows: 4, columns: 4) { row, col in
			Image(systemName: "\(row * 4 + col).circle")
			Text("R\(row) C\(col)")
		}.frame(width:800, height: 1000)
    }
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content

    var body: some View {
        VStack {
            ForEach(0 ..< rows, id: \.self) { row in
                HStack {
                    ForEach(0 ..< self.columns, id: \.self) { column in
                        self.content(row, column)
                    }
                }
            }
        }
    }

    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
}

struct MazesView_Previews: PreviewProvider {
    static var previews: some View {
        MazesView()
    }
}
