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
    
    let storyName: String
    var mp3Path: String
    var storyIcon: UIImage = UIImage()
    var mainImage: UIImage
    var title: UIImage
    var starringTitle: UIImage
    
    init(name: String, icon: UIImage) {
        storyName = name
        storyIcon = icon
    }
    
    func complete(mp3Name: String, topImage: UIImage, midImage: UIImage, botImage: UIImage ) {
        //storyName = name
        //storyIcon = icon
        mp3Path = NSBundle.mainBundle().pathForResource(mp3Name, ofType: "mp3")!
        mainImage = topImage
        title = topImage
        starringTitle = botImage
    }
    
    func getMP3() -> String {
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