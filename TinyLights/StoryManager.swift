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
    var allStories = [("Lost at Sea", 1), ("On a Treasure Hunt", 2), ("X Marks the Spot", 3), ("The Brave Rescue", 4), ("Beyond the Sea", 5)]
    
    init() {
        for story in allStories {
            let newStory = Story(name: story.0, ind: story.1)
            _ = newStory.tryMP3()
            newStory.index = stories.count
            stories.append(newStory)
        }
    }
    
    func refresh() {
        for story in stories {
            _ = story.tryMP3()
        }
    }
    
    func getStoryByDownloadID(ID: Int) -> Story? {
        for story in stories {
            if story.downloadIndex == ID {
                return story
            }
        }
        return nil
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
    
    func setFile(_ index: Int, storyURL: URL) {
        if let updatedStory = getNext(index) {
            updatedStory.mp3Path = storyURL
            _ = updatedStory.tryMP3()
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
    
    func getStoryIndex(story: Story) -> Int {
        var index = 0
        for st in stories {
            if st.getName() == story.getName() {
                return index
            } else {
                index += 1
            }
        }
        return -1
    }
    
    func getNext(_ index: Int) -> Story? {
        
        if index < stories.endIndex && index >= stories.startIndex {
            return stories[index]
        } else {
            return nil
        }
    }
    
    
    
}
