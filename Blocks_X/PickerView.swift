//
//  SliderView.swift
//  Blocks_X
//
//  Created by elber on 3/25/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI

struct PickerView: View {
	var pickerImageVar: String
	init(pickerImageVar: String) {
		self.pickerImageVar = pickerImageVar
		UITableView.appearance().separatorColor = .clear
	}
	var inputArray = ["01","02","03","04","05","06","07","08","09","10"]
	@State var slectedSegmant = "ActionSheet"
	@State var slectedObj = "04"
	@State var enableSheet = false
	var test = false
	var body: some View {
		ZStack {
			VStack(spacing: 10) {
				GeometryReader { geo in
					ZStack {
						HStack(spacing: 10) {
							Spacer()
							Button(action: {
								self.enableSheet = true
							}) {
								self.pickerImage(image: self.pickerImageVar)
								.font(.title)
							}
							Spacer()
						}.padding(.vertical)
							.frame(maxWidth: geo.size.width)
							.foregroundColor(Color.black)
//							.background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color.white).shadow(radius: 1.5)
//							)
					}
				}
//				}.padding()
			}.blur(radius: $enableSheet.wrappedValue ? 1 : 0)
				.overlay(
					$enableSheet.wrappedValue ? Color.black.opacity(0.6) : nil
			)
		   if $enableSheet.wrappedValue {
				GeometryReader { gr in
					VStack {
						VStack {
							Text("PickerView")
								.font(.headline)
								.foregroundColor(.gray)
								.padding(.top, 10)
							Text("Choose Value")
								.padding(.top, 5)
								.foregroundColor(.black)
							Picker("test", selection: self.$slectedObj) {
											Text("1").id("01")
											Text("2").id("02")
											Text("3").id("03")
											Text("4").id("04")
											Text("5").id("05")
											Text("6").id("06")
											Text("7").id("07")
											Text("8").id("08")
											Text("9").id("09")
											Text("10").id("10")

							}
							.foregroundColor(.black)
							.labelsHidden()
						}.background(RoundedRectangle(cornerRadius: 10)
							.foregroundColor(Color.white).shadow(radius: 1))
						VStack {
							Button(action: {
								debugPrint("Done Selected")
								self.enableSheet = false
							}) {
								Text("Done").fontWeight(Font.Weight.bold).foregroundColor(.black)
							}.padding()
								.frame(maxWidth: 600)
								.background(RoundedRectangle(cornerRadius: 10)
								.foregroundColor(Color.white).shadow(radius: 1))

						}
					}
					.frame(width: gr.size.width, height: gr.size.height)
					.offset(y: 200)
					.zIndex(100)
				}
			}
		}.edgesIgnoringSafeArea(.all)
	  }
}

extension View {
	func pickerImage(image: String) -> some View {
		return Image(systemName: image)
	}
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
		PickerView(pickerImageVar: blockData[0].systemName).background(Color.white)
    }
}
