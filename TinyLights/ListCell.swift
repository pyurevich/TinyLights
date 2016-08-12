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
    
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var listImage: UIImageView!
    @IBOutlet weak var ListTitle: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    private var state = status.None
    
    enum status {
        case Ready, Download, Downloading, Waiting, Playing, None
    }
    
    func getState() -> status {
        return state
    }
    
    func setState(st: status) {
        switch st {
        case .Ready:
            state = .Ready
            self.listButton.setTitle(" ", forState: UIControlState.Normal)
            self.listImage.alpha = 1
            self.ListTitle.alpha = 1
            self.backgroundColor = UIColor(white: 1, alpha: 1.0)
            self.selectionStyle = .Default
            self.progress.hidden = true
        case .Download:
            self.listButton.setTitle("Download", forState: UIControlState.Normal)
            self.listImage.alpha = 0.5
            self.ListTitle.alpha = 0.5
            self.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
            self.selectionStyle = .None
            self.progress.hidden = true
        case .Downloading:
            self.listButton.setTitle("Downloading", forState: UIControlState.Normal)
            self.listImage.alpha = 0.5
            self.ListTitle.alpha = 0.5
            self.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
            self.selectionStyle = .None
            self.progress.hidden = false
        case .Playing:
            self.listButton.setTitle("Now Playing", forState: UIControlState.Normal)
            self.listButton.userInteractionEnabled = false
            self.listImage.alpha = 1
            self.ListTitle.alpha = 1
            self.backgroundColor = UIColor(white: 1, alpha: 1.0)
            self.selectionStyle = .Default
            self.progress.hidden = true
        default:
            state = .None
        }
    }
    
}
