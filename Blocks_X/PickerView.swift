//
//  SliderView.swift
//  Blocks_X
//
//  Created by elber on 3/25/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI

struct PickerView: View {
	@EnvironmentObject var pickerMovement: UserSettings
	
	var pickerImageVar: String
	init(pickerImageVar: String) {
		self.pickerImageVar = pickerImageVar
		UITableView.appearance().separatorColor = .clear
	}
	let inputArray = ["01","02","03","04","05","06","07","08","09","10"]
	@State var slectedObj = 0
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
								ForEach(0 ..< self.inputArray.count) {
									Text(self.inputArray[$0]).tag($0)
								}
							}
							.foregroundColor(.black)
							.labelsHidden()
//							.onReceive([self.slectedObj].publisher.first()) { (value) in
//								print(value)}
						}.background(RoundedRectangle(cornerRadius: 10)
							.foregroundColor(Color.white).shadow(radius: 1))
						VStack {
							Button(action: {
								debugPrint("Done Selected")
								self.enableSheet = false
								self.pickerMovement.value = self.slectedObj + 1
								print(self.pickerMovement.value)
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
