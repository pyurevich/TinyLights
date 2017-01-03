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
    func didFinishSelecting(storyInList: Int)
}


class ListOfStories: UITableViewController, AVAudioPlayerDelegate, DownloadManagerDelegate {
    
    // MARK: Variables
    
    var delegate: PlaySongDelegate?
    let downloads = DownloadManager.sharedInstance
    let stories = StoryManager.sharedInstance
    
    @IBOutlet var storyTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloads.delegate = self
        if delegate == nil {
            print("Delegate is nil!")
            print("Assigning delegate to: \(String(describing: (parent as! UINavigationController).parent))")
            delegate = (parent as! UINavigationController).parent as! PlaySongDelegate?
        }
    }
    
    // MARK: Download Manager Delegates
    
    func didUpdate(storyID: Int, progress: Double) {
        print(storyID, progress)
        DispatchQueue.main.async {
            let storyIndex = storyID
            let cell = self.tableView.cellForRow(at: NSIndexPath(row: storyIndex, section: 0) as IndexPath) as! ListCell
            let progressView = cell.progress
            print("LoS \(cell.ListTitle.text) \(progress)")
            progressView?.setProgress(Float(progress), animated: false)
        }
    }
    
    func didFinishDownload(storyID: Int) {
        DispatchQueue.main.async {
            let finishedDownload = self.stories.getNext(storyID)!
            finishedDownload.setStatus(.ready)
            let downloadIndexPath = IndexPath(row: storyID, section: 0)
            self.storyTable.reloadRows(at: [downloadIndexPath], with: UITableViewRowAnimation.fade)
        }
    }

    func startDownload(_ currentDownloadingStory: Story) {

        _ = downloads.addDownload(currentDownloadingStory)

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = (tableView.dequeueReusableCell(withIdentifier: "StoryEntry")! as! ListCell)
        
        cell.listButton.tag = indexPath.row
        cell.cellIndex = indexPath.row
        
        if let storyExists = cell.associatedStory() {
            cell.ListTitle.text = storyExists.getName()
            cell.listImage.image = storyExists.getIcon()
            cell.listImage.layer.cornerRadius = 10
            switch storyExists.getStatus() {
            case .ready:
                cell.setStatus(.ready)
            case .download:
                cell.setStatus(.download)
            case .downloading:
                cell.setStatus(.downloading)
            case .playing:
                cell.setStatus(.playing)
            case .upcoming:
                print("Upcoming!")
                cell.setStatus(.upcoming)
            }
        } else {
            print("Story has not been assigned!")
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.getNum()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("segued")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ListCell
        
        if let storyExists = cell.associatedStory() {
            switch storyExists.getStatus() {
            case .ready:
                if delegate == nil {
                    self.dismiss(animated: true, completion: {})
                }
                delegate!.didFinishSelecting(storyInList: indexPath.row)
                //self.dismiss(animated: true, completion: {})
                performSegue(withIdentifier: "back", sender: self)
            case .download:
                cell.setStatus(.downloading)
                storyExists.setStatus(.downloading)
                startDownload(storyExists)
            case .downloading: break
            case .upcoming: break
            case .playing:
                //self.dismiss(animated: true, completion: {})
                performSegue(withIdentifier: "back", sender: self)
            }
        } else {
            print("Story has not been assigned!")
        }
    }


    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let storyToEditStatus = stories.getNext((indexPath as NSIndexPath).row)!.getStatus()
        if storyToEditStatus == .ready || storyToEditStatus == .playing {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let storyToDelete = StoryManager.sharedInstance.getNext((indexPath as NSIndexPath).row)!
        let cellToDelete = (tableView.cellForRow(at: indexPath) as! ListCell)
        
        if (editingStyle == UITableViewCellEditingStyle.delete) {
            print("Made it to deletion")
            
            if storyToDelete.getLocation() == .device || storyToDelete.getLocation() == .somewhere {
                    let fileManager = FileManager()
                    let destinationURLForFile = storyToDelete.mp3Path
                
                do {
                    try fileManager.removeItem(at: destinationURLForFile!)
                } catch {
                    //handle errors
                }
                if storyToDelete.getStatus() == .playing {
                    (tableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! ListCell).setStatus(.playing)
                    (tableView.cellForRow(at: NSIndexPath(row: 0, section: 0) as IndexPath) as! ListCell).associatedStory()?.setStatus(.playing)
                    delegate!.didFinishSelecting(storyInList: 0)
                }
                
                storyToDelete.mp3DataAvailable = false
                cellToDelete.setStatus(.download)
                storyToDelete.deleteData()
                storyToDelete.setStatus(.download)
                
                
                tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                
                
            } else if storyToDelete.getLocation() == .bundle {
                tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                shake(self.view)
            } else {
                tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            }
        }
    }
    
    
    func shake(_ view: UIView) {
        let anim = CAKeyframeAnimation( keyPath:"transform" )
        anim.values = [
            NSValue( caTransform3D:CATransform3DMakeTranslation(-5, 0, 0 ) ),
            NSValue( caTransform3D:CATransform3DMakeTranslation( 5, 0, 0 ) )
        ]
        anim.autoreverses = true
        anim.repeatCount = 2
        anim.duration = 6/100
        
        view.layer.add( anim, forKey:nil )
    }

}
