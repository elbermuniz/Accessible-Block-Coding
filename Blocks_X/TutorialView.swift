//
//  Header.swift
//  Blocks_X
//
//  Created by elber on 3/25/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import SwiftUI
import AVKit
import AVFoundation

struct TutorialView: View {
	var body: some View {
		GeometryReader { geometry in
			VStack {
				Spacer()
				Text("Tutorial Video")
					.font(.title)
					.fontWeight(.heavy)
					.multilineTextAlignment(.center)
					.padding(.vertical, 10.0)
				Spacer()
				PlayerView()
			}
			.frame(minWidth: 0, maxWidth: geometry.size.width, minHeight:0, maxHeight: geometry.size.height).background(Color.gray)
		}
	}
}

struct PlayerView: UIViewRepresentable {
  func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
  }

  func makeUIView(context: Context) -> UIView {
    return PlayerUIView(frame: .zero)
  }
}

class PlayerUIView: UIView {
  private let playerLayer = AVPlayerLayer()

  override init(frame: CGRect) {
    super.init(frame: frame)
	
	guard let path = Bundle.main.path(forResource: "video", ofType:"m4v") else {
			   debugPrint("video.m4v not found")
			   return
		   }

	let url = URL(fileURLWithPath: path)
    let player = AVPlayer(url: url)
    player.play()

    playerLayer.player = player
    layer.addSublayer(playerLayer)
  }

  required init?(coder: NSCoder) {
	fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    playerLayer.frame = bounds
  }
}

struct Tutorial_Previews: PreviewProvider {
    static var previews: some View {
		TutorialView()
    }
}
