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

class PlayerState: ObservableObject {

    public var currentPlayer: AVPlayer?
    private var videoUrl : URL?

    public func player(for url: URL) -> AVPlayer {
        if let player = currentPlayer, url == videoUrl {
            return player
        }
        currentPlayer = AVPlayer(url: url)
        videoUrl = url
        return currentPlayer!
    }
}

struct TutorialView: View {
	@EnvironmentObject var playerState : PlayerState
    @State private var vURL = URL(string: "https://www.radiantmediaplayer.com/media/bbb-360p.mp4")

	@State private var showVideoPlayer = false
	
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
				
				Button(action: { self.showVideoPlayer = true }) {
					Text("Start video").font(.title)
				}
				.sheet(isPresented: self.$showVideoPlayer, onDismiss: { self.playerState.currentPlayer?.pause() }) {
					AVPlayerView(videoURL: self.$vURL)
						.edgesIgnoringSafeArea(.all)
						.environmentObject(self.playerState)
				}
				Spacer()
			}
			.frame(minWidth: 0, maxWidth: geometry.size.width, minHeight:0, maxHeight: geometry.size.height).background(Color.gray)
		}
	}
}


struct AVPlayerView: UIViewControllerRepresentable {

    @EnvironmentObject var playerState : PlayerState
    @Binding var videoURL: URL?

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerController = AVPlayerViewController()
        playerController.modalPresentationStyle = .fullScreen
        playerController.player = playerState.player(for: videoURL!)
        playerController.player?.play()
        return playerController
    }
}

struct Tutorial_Previews: PreviewProvider {
    static var previews: some View {
		TutorialView().environmentObject(PlayerState())
    }
}
