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
	@State private var vURL = URL(fileURLWithPath: Bundle.main.path(forResource: "tutorial", ofType: ".mov")!)
	@State private var showVideoPlayer = false
	
	let gradient = Gradient(colors: [.gray, .black])

	var body: some View {
		GeometryReader { geometry in
			ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
				Rectangle()
					.fill(
						RadialGradient(gradient: self.gradient, center: .center, startRadius: 1, endRadius: 1100)
				).edgesIgnoringSafeArea(.all)
				
				VStack {
					Text("Tutorial Video")
						.fontWeight(.light)
						.shadow(color: Color.blue, radius: 15)
						.shadow(color: Color.white, radius: 5)
						.multilineTextAlignment(.center)
						.padding(.top, 10.0)
						.font(.system(size: 72))
						.foregroundColor(.white)
					Spacer()
					
					Button(action: { self.showVideoPlayer = true }) {
						ZStack{
							Rectangle()
								.cornerRadius(12)
							Text("Play video")
								.font(.largeTitle)
								.fontWeight(.heavy)
								.foregroundColor(.white)
						}
					}
					.sheet(isPresented: self.$showVideoPlayer, onDismiss: { self.playerState.currentPlayer?.pause() }) {
						AVPlayerView(videoURL: self.$vURL)
							.edgesIgnoringSafeArea(.all)
							.environmentObject(self.playerState)
					}
					.shadow(color: Color.blue, radius: 10)
					.shadow(color: Color.white, radius: 10)
					.frame(width: 400, height: 120)
					
					Spacer()
					
//					Button(action: { self.showVideoPlayer = true }) {
//						ZStack{
//							Rectangle()
//								.cornerRadius(12)
//							Text("Administrator/ \nTeacher video")
//								.font(.largeTitle)
//								.fontWeight(.heavy)
//								.foregroundColor(.white)
//						}
//					}
//					.sheet(isPresented: self.$showVideoPlayer, onDismiss: { self.playerState.currentPlayer?.pause() }) {
//						AVPlayerView(videoURL: self.$vURL)
//							.edgesIgnoringSafeArea(.all)
//							.environmentObject(self.playerState)
//					}
//					.shadow(color: Color.blue, radius: 10)
//					.shadow(color: Color.white, radius: 10)
//					.frame(width: 400, height: 120)
//
					Spacer()
				}
				.frame(minWidth: 0, maxWidth: geometry.size.width, minHeight:0, maxHeight: geometry.size.height)
			}
		}
	}
}


struct AVPlayerView: UIViewControllerRepresentable {

    @EnvironmentObject var playerState : PlayerState
    @Binding var videoURL: URL

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerController = AVPlayerViewController()
        playerController.modalPresentationStyle = .fullScreen
        playerController.player = playerState.player(for: videoURL)
        playerController.player?.play()
        return playerController
    }
}

struct Tutorial_Previews: PreviewProvider {
    static var previews: some View {
		TutorialView().environmentObject(PlayerState())
    }
}
