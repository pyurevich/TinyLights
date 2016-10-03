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
        case ready, download, downloading, playing
    }
    
    enum storage {
        case bundle, device, nowhere, somewhere
    }
    
    fileprivate var location = storage.nowhere
    fileprivate var readiness = status.download
    let storyName: String
    var mp3Name: String
    var mp3Path: URL? = nil
    var mp3DataAvailable = false
    var storyIcon: UIImage = UIImage()
    var mainImage: UIImage = UIImage()
    var title: UIImage = UIImage()
    var starringTitle: UIImage = UIImage()
    var downloadIndex = -1
    var downloadStatus = Float()
    var storyURL: Foundation.URL
    var index = -1
    
    init(name: String, mp3: String) {
        storyName = name
        mp3Name = mp3
        storyURL = URL(string: "http://www.fablemore.com/assets/\(mp3Name).mp3")!
    }
    
    func setDI(_ index: Int) {
        downloadIndex = index
    }
    
    func getDI() -> Int {
        return downloadIndex
    }
    
    func addImageAssets(_ topImage: UIImage, midImage: UIImage, botImage: UIImage ) {
        //storyName = name
        //storyIcon = icon
        mainImage = topImage
        title = topImage
        starringTitle = botImage
    }
    
    func tryMP3() -> Bool {
        
        let show = true
        
        //print("Mp3Path is \(String(mp3Path))")
        if let mp3Available = Bundle.main.path(forResource: mp3Name, ofType: "mp3") {
            mp3Path = URL(fileURLWithPath: mp3Available)
            mp3DataAvailable = true
            readiness = .ready
            location = .bundle
            if show { print("For story \(storyName), mp3 data is stored in the bundle") }
            //if show { print(mp3Path) }
            downloadStatus = 1
            return true
        } else {
            // if show { print("For story \(storyName), mp3 data is NOT stored in the bundle") }
        }
        
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectoryPath:String = path[0]
        let fileManager = FileManager()
        let destinationURLForFile = URL(fileURLWithPath: documentDirectoryPath + "/\(mp3Name).mp3")
        
        if fileManager.fileExists(atPath: destinationURLForFile.path){
            mp3Path = URL(fileURLWithPath: destinationURLForFile.path)
            mp3DataAvailable = true
            readiness = .ready
            location = .device
            downloadStatus = 1
            if show { print("For story \(storyName), mp3 data is stored on device") }
            return true
        } else {
            // if show { print("For story \(storyName), mp3 data is NOT stored on device") }
        }
        
        if mp3Path != nil {
            mp3DataAvailable = true
            readiness = .ready
            location = .somewhere
            if show { print("For story \(storyName), mp3 data is available somewhere") }
            downloadStatus = 1
            if show { print(mp3Path) }
            return true
        } else {
            if show { print("For story \(storyName), mp3 data is NOT available anywhere") }
        }
        
        downloadStatus = 0
        readiness = .download
        location = .nowhere
        return false
    }
    
    func deleteData() {
        mp3Path = nil
        tryMP3()
    }
    
    func getLocation() -> Story.storage {
        return location
    }
    
    func setLocation(_ loc: Story.storage) {
        location = loc
    }
    
    func getStatus() -> Story.status {
        return readiness 
    }
    
    func setStatus(_ st: Story.status) {
        readiness = st
        if readiness == .ready {
            tryMP3()
        }
    }
    
    func ready() -> Bool {
        return mp3DataAvailable
    }
    
    func getMP3() -> URL {
        return mp3Path!
    }
    
    func getImages() -> (UIImage, UIImage, UIImage) {
        return (title, mainImage, starringTitle)
    }
    
    func setIcon(_ icon: UIImage) {
        storyIcon = icon
    }
    
    func getIcon() -> UIImage {
        return storyIcon
    }
    
    func getName() -> String {
        return storyName
    }
    
}
