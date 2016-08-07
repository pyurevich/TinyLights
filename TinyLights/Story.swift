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
    var mp3Path: NSURL? = nil
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
        
        //print("Mp3Path is \(String(mp3Path))")
        if let mp3Available = NSBundle.mainBundle().pathForResource(mp3Name, ofType: "mp3") {
            mp3Path = NSURL(fileURLWithPath: mp3Available)
            mp3DataAvailable = true
            readiness = .Ready
            print("For story \(storyName), mp3 data is stored in the bundle")
            return true
        } else {
            print("For story \(storyName), mp3 data is NOT stored in the bundle")
        }
        
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentDirectoryPath:String = path[0]
        let fileManager = NSFileManager()
        let destinationURLForFile = NSURL(fileURLWithPath: documentDirectoryPath.stringByAppendingString("/\(mp3Name).mp3"))
        
        if fileManager.fileExistsAtPath(destinationURLForFile.path!){
            mp3Path = NSURL(fileURLWithPath: destinationURLForFile.path!)
            mp3DataAvailable = true
            readiness = .Ready
            print("For story \(storyName), mp3 data is stored on device")
            return true
        } else {
            print("For story \(storyName), mp3 data is NOT stored on device")
        }
        
        if mp3Path != nil {
            mp3DataAvailable = true
            readiness = .Ready
            print("For story \(storyName), mp3 data is available somewhere")
            return true
        } else {
            print("For story \(storyName), mp3 data is NOT available anywhere")
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
        return mp3Path!
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