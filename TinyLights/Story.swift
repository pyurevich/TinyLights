//
//  Story.swift
//  Jill the Jelly
//
//  Created by Pavel Yurevich on 6/28/16.
//  Copyright © 2016 Pavel Yurevich. All rights reserved.
//

import Foundation
import UIKit

class Story {
    
    enum status {
        case Ready
        case DownloadNeeded
        case NotAvailable
    }
    
    var readiness = status.NotAvailable
    let storyName: String
    var mp3Name: String
    var mp3Path: NSURL = NSURL()
    var mp3DataAvailable = false
    var storyIcon: UIImage = UIImage()
    var mainImage: UIImage = UIImage()
    var title: UIImage = UIImage()
    var starringTitle: UIImage = UIImage()
    
    init(name: String, mp3: String) {
        storyName = name
        mp3Name = mp3
    }
    
    func addImageAssets(topImage: UIImage, midImage: UIImage, botImage: UIImage ) {
        //storyName = name
        //storyIcon = icon
        mainImage = topImage
        title = topImage
        starringTitle = botImage
    }
    
    func tryMP3() -> Bool {
        if let mp3Available = NSBundle.mainBundle().pathForResource(mp3Name, ofType: "mp3") {
            mp3Path = NSURL(fileURLWithPath: mp3Available)
            mp3DataAvailable = true
            readiness = .Ready
            print("For story \(storyName), mp3 data is available")
            return true
        } else {
            print("For story \(storyName), mp3 data is NOT available")
            return false
            
        }
    }
    
    func getStatus() -> Story.status {
        return readiness 
    }
    
    func ready() -> Bool {
        return mp3DataAvailable
    }
    
    func getMP3() -> NSURL {
        return mp3Path
    }
    
    func getImages() -> (UIImage, UIImage, UIImage) {
        return (title, mainImage, starringTitle)
    }
    
    func setIcon(icon: UIImage) {
        storyIcon = icon
    }
    
    func getIcon() -> UIImage {
        return storyIcon
    }
    
    func getName() -> String {
        return storyName
    }
    
}