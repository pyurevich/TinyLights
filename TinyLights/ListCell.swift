//
//  ListCell.swift
//  Jill the Jelly
//
//  Created by Pavel Yurevich on 7/3/16.
//  Copyright © 2016 Pavel Yurevich. All rights reserved.
//

import Foundation
import UIKit

class ListCell : UITableViewCell {
    
    @IBOutlet weak var ActionImage: UIImageView!
    //@IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var ListTitle: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    fileprivate var state = status.ready
    var cellIndex = Int()
    
    func associatedStory() -> Story? {
        if let storyExists = StoryManager.sharedInstance.getNext(cellIndex) {
            return storyExists
        }
        return nil
    }
    
    enum status {
        case ready, download, downloading, playing, upcoming
    }
    
    func getState() -> status {
        return state
    }
    
    func setStatus(_ st: status) {
        switch st {
        case .ready:
            state = .ready
            //self.listButton.setTitle(" ", for: UIControlState())
            self.ActionImage.isHidden = true
            self.listImage.alpha = 1
            self.ListTitle.alpha = 1
            self.backgroundColor = UIColor(white: 1, alpha: 1.0)
            self.selectionStyle = .default
            self.progress.isHidden = true
        case .download:
            self.ActionImage.image = #imageLiteral(resourceName: "Download")
            self.ActionImage.isHidden = false
            //self.listButton.isUserInteractionEnabled = false
            self.listImage.alpha = 0.5
            self.ListTitle.alpha = 0.5
            self.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            self.selectionStyle = .none
            self.progress.isHidden = true
        case .downloading:
            //self.listButton.setTitle("Downloading", for: UIControlState())
            self.ActionImage.isHidden = true
            self.listImage.alpha = 0.5
            self.ListTitle.alpha = 0.5
            self.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            self.selectionStyle = .none
            self.progress.setProgress(associatedStory()!.downloadStatus, animated: false)
            self.progress.isHidden = false
        case .playing:
//            self.listButton.setTitle("Now Playing", for: UIControlState())
//            self.listButton.isUserInteractionEnabled = false
            self.ActionImage.image = #imageLiteral(resourceName: "Playing")
            self.ActionImage.isHidden = false
            self.listImage.alpha = 1
            self.ListTitle.alpha = 1
            self.backgroundColor = UIColor(white: 1, alpha: 1.0)
            self.selectionStyle = .default
            self.progress.isHidden = true
        case .upcoming:
//            self.listButton.setTitle("Coming soon!", for: UIControlState())
//            self.listButton.isUserInteractionEnabled = false
            self.ActionImage.image = #imageLiteral(resourceName: "Lock")
            self.ActionImage.isHidden = false
            self.listImage.alpha = 0.5
            self.ListTitle.alpha = 0.5
            self.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
            self.selectionStyle = .none
            self.progress.isHidden = true
        }
    }
    
}
