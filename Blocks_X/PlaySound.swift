//
//  PlaySound.swift
//  Blocks_X
//
//  Created by elber on 4/8/20.
//  Copyright © 2020 COMP523. All rights reserved.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?

func playSound(sound: String, type: String) {
	if let path = Bundle.main.path(forResource: sound, ofType: type) {
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
			audioPlayer?.play()
		} catch {
			print("Could not find and play the sound file.")
		}
	}
}
