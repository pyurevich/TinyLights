//
//  AudioPlayer.swift
//  Jill the Jelly
//
//  Created by Pavel Yurevich on 7/17/16.
//  Copyright © 2016 Pavel Yurevich. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class AudioPlayer {

    static let sharedInstance = AudioPlayer()
    
    var storySession = AVAudioSession.sharedInstance()
    var storyAudio: AVAudioPlayer! = nil

    
    func prepareSession() {
        do {
            
            try storySession.setCategory(AVAudioSessionCategoryPlayback)
            try storySession.setActive(true)
        } catch {
          // handle errors
        }
    }
    
    func loadAudioOriginal(_ delegate: AVAudioPlayerDelegate, url: URL) {
        do {
            storyAudio = try AVAudioPlayer(contentsOf: url)
            storyAudio.delegate = delegate
            //storyAudio = try AVAudioPlayer(contentsOfURL: (stories.getNext(4)?.getMP3())!)
            storyAudio.prepareToPlay()
        } catch {
            // handle errors
        }
    }
    
    func loadAudio(_ url: URL) {
        do {
            storyAudio = try AVAudioPlayer(contentsOf: (StoryManager.sharedInstance.getNext(4)?.getMP3())!)
        } catch {
            // handle errors
        }
    }
    
    func getPlayer() -> AVAudioPlayer {
        return storyAudio
    }
    
    
    
}

