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

class ListOfStories: UITableViewController, AVAudioPlayerDelegate, NSURLSessionDownloadDelegate, UIDocumentInteractionControllerDelegate {
    
    var delegate: PlaySongDelegate?
        
    @IBOutlet var storyTable: UITableView!
    
    var downloadTask: NSURLSessionDownloadTask!
    var backgroundSession: NSURLSession!
    var progressView = UIProgressView()
    var currentlyDownloading: Int? = nil
    
    
    @IBAction func rrr(sender: UIButton) {
        if sender.titleLabel?.text == " " {
            delegate!.didFinishSelecting(sender.tag)
            self.dismissViewControllerAnimated(true, completion: {})
            
        } else if sender.titleLabel?.text == "Download" {
            print("Label for download - sender tag \(sender.tag)")
            downloadTask = nil
            currentlyDownloading = sender.tag
            let index = NSIndexPath(forRow: sender.tag, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(index)
            progressView = (cell as! ListCell).progress
            progressView.setProgress(0.0, animated: false)
            progressView.hidden = false
            (cell as! ListCell).listButton.setTitle("Downloading", forState: UIControlState.Normal)
            
            
            let backgroundSessionConfiguration = NSURLSessionConfiguration.backgroundSessionConfigurationWithIdentifier("backgroundSession\(sender.tag)")
            backgroundSession = NSURLSession(configuration: backgroundSessionConfiguration, delegate: self, delegateQueue: NSOperationQueue.mainQueue())
            
            startDownload(sender.tag)
            
            
            
            
            
        } else if sender.titleLabel?.text == "Now Playing" {
            self.dismissViewControllerAnimated(true, completion: {})
        } else {
            print("Label is different!")
        }
    }
    
    func startDownload(index: Int) {
        
        let currentDownload = StoryManager.sharedInstance.getNext(index)!.mp3Name
        
        let url = NSURL(string: "http://www.fablemore.com/assets/\(currentDownload).mp3")!
        
        print(url)
        downloadTask = backgroundSession.downloadTaskWithURL(url)
        downloadTask.resume()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("View reloaded")


    }
        
        // 1
        func URLSession(session: NSURLSession, downloadTask: NSURLSessionDownloadTask, didFinishDownloadingToURL location: NSURL){
            
            //print("Location: \(location)")
            
            let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
            let documentDirectoryPath:String = path[0]
            let fileManager = NSFileManager()
            let destinationURLForFile = NSURL(fileURLWithPath: documentDirectoryPath.stringByAppendingString("/jill_v\(currentlyDownloading!).mp3"))
            
            print(currentlyDownloading)
            
            if fileManager.fileExistsAtPath(destinationURLForFile.path!){
                //showFileWithPath(destinationURLForFile.path!)
                StoryManager.sharedInstance.setFile(currentlyDownloading!, storyURL: destinationURLForFile)
                let cell = (storyTable.cellForRowAtIndexPath(NSIndexPath(forRow: currentlyDownloading!, inSection: 0)) as! ListCell)
//                cell.listButton.titleLabel?.text = " "
//                cell.listImage.alpha = 1
//                cell.ListTitle.alpha = 1
//                cell.backgroundColor = UIColor(white: 1, alpha: 1.0)
                cell.setState(.Ready)
            }
            else{
                do {
                    try fileManager.moveItemAtURL(location, toURL: destinationURLForFile)
                    StoryManager.sharedInstance.setFile(currentlyDownloading!, storyURL: destinationURLForFile)
                    let cell = (storyTable.cellForRowAtIndexPath(NSIndexPath(forRow: currentlyDownloading!, inSection: 0)) as! ListCell)
//                    cell.listButton.titleLabel?.text = " "
//                    cell.listImage.alpha = 1
//                    cell.ListTitle.alpha = 1
//                    cell.backgroundColor = UIColor(white: 1, alpha: 1.0)
                    cell.setState(.Ready)
                    // show file
                    //showFileWithPath(destinationURLForFile.path!)
                }catch{
                    print("An error occurred while moving file to destination url")
                }
            }
            downloadTask.cancel()
            backgroundSession.finishTasksAndInvalidate()
            //backgroundSession.finalize()
        }
        // 2
        func URLSession(session: NSURLSession,
                        downloadTask: NSURLSessionDownloadTask,
                        didWriteData bytesWritten: Int64,
                                     totalBytesWritten: Int64,
                                     totalBytesExpectedToWrite: Int64){
            progressView.setProgress(Float(totalBytesWritten)/Float(totalBytesExpectedToWrite), animated: true)
        }
        
        
        func URLSession(session: NSURLSession,
                        task: NSURLSessionTask,
                        didCompleteWithError error: NSError?){
            
            downloadTask = nil
            progressView.hidden = true
            //progressView.setProgress(0.0, animated: true)
            if (error != nil) {
                print(error?.description)
            }else{
                print("The task finished transferring data successfully")
            }
        }

    

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rrr((tableView.cellForRowAtIndexPath(indexPath) as! ListCell).listButton)
        //tableView.cellForRowAtIndexPath(indexPath)!.selected = false
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = (tableView.dequeueReusableCellWithIdentifier("StoryEntry")! as! ListCell)
        
        cell.listButton.tag = indexPath.row
        cell.progress.hidden = true
        
        
        if StoryManager.sharedInstance.getNext(indexPath.row)!.ready() {
            //(cell as! ListCell).listButton.setTitle(" ", forState: UIControlState.Normal)
            cell.setState(.Ready)
            
        
        } else {
//            (cell as! ListCell).listButton.setTitle("Download", forState: UIControlState.Normal)
//            (cell as! ListCell).listImage.alpha = 0.5
//            (cell as! ListCell).ListTitle.alpha = 0.5
//            (cell as! ListCell).backgroundColor = UIColor(white: 0.9, alpha: 1.0)
//            cell.selectionStyle = .None
            cell.setState(.Download)
            
        }
        
        if StoryManager.sharedInstance.currentStory == indexPath.row {
            //cell.listButton.setTitle("Now Playing", forState: UIControlState.Normal)
            //cell.listButton.userInteractionEnabled = false
            //(cell as! ListCell).userInteractionEnabled = false
            
            cell.setState(.Playing)
        }
        
        
        cell.ListTitle.text = StoryManager.sharedInstance.getNext(indexPath.row)?.getName()
        
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
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if StoryManager.sharedInstance.getNext(indexPath.row)!.ready() {
            return true
        } else {
            return false
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            print("Made it to deletion)")
            // handle delete (by removing the data from your array and updating the tableview)
            let fileManager = NSFileManager()
            let destinationURLForFile = StoryManager.sharedInstance.getNext(indexPath.row)?.mp3Path!
            do {
                try fileManager.removeItemAtURL(destinationURLForFile!)
            } catch {
                //handle errors
            }
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            StoryManager.sharedInstance.getNext(indexPath.row)!.mp3DataAvailable = false
            
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            
            (cell as! ListCell).listButton.setTitle("Download", forState: UIControlState.Normal)
            (cell as! ListCell).listImage.alpha = 0.5
            (cell as! ListCell).ListTitle.alpha = 0.5
            (cell as! ListCell).backgroundColor = UIColor(white: 0.9, alpha: 1.0)
            
            cell!.selectionStyle = .None
            //tableView.cellForRowAtIndexPath(indexPath)?.setEditing(false, animated: true)
            //cell.setEditing(false, animated:true)
        }
    }
}
