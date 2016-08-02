//
//  ListOfStories.swift
//  Jill the Jelly
//
//  Created by Pavel Yurevich on 7/3/16.
//  Copyright © 2016 Pavel Yurevich. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

protocol PlaySongDelegate {
    func didFinishSelecting(songInList: Int)
}

class ListOfStories: UITableViewController, AVAudioPlayerDelegate {
    
    var delegate: PlaySongDelegate?
    
    @IBAction func rrr(sender: UIButton) {
        if sender.titleLabel?.text == "Play" {
            print("Label for play!")
            
            print("Tag is \(sender.tag)")
            delegate!.didFinishSelecting(sender.tag)
           
            self.dismissViewControllerAnimated(true, completion: {})
            
        } else if sender.titleLabel?.text == "Download" {
            print("Label for download")
        } else {
            print("Label is different!")
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rrr((tableView.cellForRowAtIndexPath(indexPath) as! ListCell).listButton)
        tableView.cellForRowAtIndexPath(indexPath)!.selected = false
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("StoryEntry")!
        
        (cell as! ListCell).listButton.tag = indexPath.row
        
        if StoryManager.sharedInstance.getNext(indexPath.row)!.ready() {
            (cell as! ListCell).listButton.setTitle("Play", forState: UIControlState.Normal)
        
        } else {
            (cell as! ListCell).listButton.setTitle("Download", forState: UIControlState.Normal)
            
        }
        
        
        (cell as! ListCell).ListTitle.text = StoryManager.sharedInstance.getNext(indexPath.row)?.getName()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StoryManager.sharedInstance.getNum()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("segued")
    }
    
}
