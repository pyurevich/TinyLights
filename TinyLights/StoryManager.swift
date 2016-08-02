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
    
    var stories = [Story]()
    var allStories = [("Lost at Sea","las"), ("On a Treasure Hunt","las"), ("Fish and Chips","las1"), ("Open Water","las1"), ("Critter Fritter","las2")]
    
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
    
    func getStories() -> [Story] {
        return stories
    }
    
    func getNum() -> Int {
        return stories.count
    }
    
    func getNext(index: Int) -> Story? {
        
        if index <= stories.endIndex && index >= stories.startIndex {
            return stories[index]
        } else {
            return nil
        }
    }
    
    
    
}
