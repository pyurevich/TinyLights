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
    var sotry1 = Story(name: "Jill1", icon: UIImage(named: "Jill1")!)
    var storyList = []
    
    init() {
        let docsPath = NSBundle.mainBundle().resourcePath!
        let fileManager = NSFileManager.defaultManager()
        var mp3Files = [String]()
        
        do {
            let docsArray = try fileManager.contentsOfDirectoryAtPath(docsPath)
            for doc in docsArray {
                if doc.containsString(".mp3") {
                    mp3Files.append(doc)
                }
            }
            print(mp3Files[0].stringByReplacingOccurrencesOfString(<#T##target: String##String#>, withString: <#T##String#>))
        } catch {
            print(error)
        }
        
        
        
    }
    
    func addStory(name: String, mp3: String, topImage: UIImage, midImage: UIImage, botImage: UIImage) {
        let storyToAdd = Story(name: name, icon: topImage)
        stories.append(storyToAdd)
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
