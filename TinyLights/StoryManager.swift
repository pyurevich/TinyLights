//
//  StoryManager.swift
//  Jill the Jelly
//
//  Created by Pavel Yurevich on 6/28/16.
//  Copyright © 2016 Pavel Yurevich. All rights reserved.
//

import Foundation
import UIKit

class StoryManager {
    
    static let sharedInstance = StoryManager()
    
    var currentStory = 0
    
    var stories = [Story]()
    var allStories = [("Lost at Sea","jill1"), ("On a Treasure Hunt","jill2"), ("Fish and Chips","jill_v2"), ("Open Water","jill_v2"), ("Critter Fritter","jill_v2")]
    
    init() {
        for story in allStories {
            let newStory = Story(name: story.0, mp3: story.1)
            newStory.tryMP3()
            stories.append(newStory)
        }
    }
    
    func getPlayableStories() -> [Story] {
        var temp = [Story]()
        for story in stories {
            if story.mp3DataAvailable {
                temp.append(story)
            }
        }
        return temp
    }
    
    func setFile(index: Int, storyURL: NSURL) {
        if let updatedStory = getNext(index) {
            updatedStory.mp3Path = storyURL
            updatedStory.tryMP3()
        } else {
            print("Story with index \(index) does not exist!")
        }
    }
    
    func getStories() -> [Story] {
        return stories
    }
    
    func getNum() -> Int {
        return stories.count
    }
    
    func getNext(index: Int) -> Story? {
        
        if index < stories.endIndex && index >= stories.startIndex {
            return stories[index]
        } else {
            return nil
        }
    }
    
    
    
}
