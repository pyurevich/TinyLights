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
    
    var stories = [Story]()
    var allStories = [("Lost at Sea","las")]
    
    init() {
        for story in allStories {
            let newStory = Story(name: story.0, mp3: story.1)
            newStory.tryMP3()
            stories.append(newStory)
        }
    }
    
    func getStories() -> [Story] {
        return stories
    }
    
    func getNum() -> Int {
        return stories.count
    }
    
    func getNext(index: Int) -> Story? {
        
        if stories.endIndex >= index {
            return stories[index]
        } else {
            return nil
        }
    }
    
    
    
}
