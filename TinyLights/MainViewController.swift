//
//  ViewController.swift
//  TinyLights
//
//  Created by Pavel Yurevich on 3/4/16.
//  Copyright © 2016 Pavel Yurevich. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class MainViewController: UIViewController, AVAudioPlayerDelegate, Dimmable, PlaySongDelegate {
    
    var storySession: AVAudioSession!
    var storyAudio: AVAudioPlayer! = nil
    let path = NSBundle.mainBundle().pathForResource("las", ofType: "mp3")!
    let dimLevel: CGFloat = 0.5
    let dimSpeed: Double = 0.5
    let ffrwTime: NSTimeInterval = 10
    let playPos = 3
    var currentStory = Int()
    
    let stories = StoryManager.sharedInstance
    
    @IBOutlet weak var toolbar: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var scrubber: UISlider!
    @IBOutlet weak var timer: UILabel!
    
    func didFinishSelecting(songInList: Int) {
        
        var currentlyPlaying = false
        
        if storyAudio.playing {
            currentlyPlaying = true
        }
        
        do {
            storySession = AVAudioSession.sharedInstance()
            try storySession.setCategory(AVAudioSessionCategoryPlayback)
            try storySession.setActive(true)
            storyAudio = try AVAudioPlayer(contentsOfURL: (stories.getNext(songInList)?.getMP3())!)
            storyAudio.delegate = self
            storyAudio.prepareToPlay()
            currentStory = songInList
        } catch {
            // couldn't load file :( - nothing for now
        }
        
        print("Tag is \(songInList) + \((stories.getNext(songInList)?.getMP3())!)")
        
        if playBtn.selected {
            play("")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar.layer.shadowColor = UIColor.blackColor().CGColor
        toolbar.layer.shadowOpacity = 0.6
        toolbar.layer.shadowRadius = 5
        toolbar.layer.shadowOffset = CGSize(width: 0, height: 5)
        toolbar.layer.masksToBounds = false
        
        scrubber.setThumbImage(UIImage(named: "Scrubber"), forState: UIControlState.Normal)
        scrubber.setThumbImage(UIImage(named: "scrubber.png"), forState: UIControlState.Highlighted)
        
        
        let url = NSURL(fileURLWithPath: path)
        do {
            storySession = AVAudioSession.sharedInstance()
            try storySession.setCategory(AVAudioSessionCategoryPlayback)
            try storySession.setActive(true)
            storyAudio = try AVAudioPlayer(contentsOfURL: url)
            storyAudio.delegate = self
            storyAudio.prepareToPlay()
        } catch {
            // couldn't load file :( - nothing for now
        }
        
        let prefs = NSUserDefaults.standardUserDefaults()
        var appDefaults = Dictionary<String, AnyObject>()
        appDefaults["remember"] = true
        NSUserDefaults.standardUserDefaults().registerDefaults(appDefaults)
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let rem = prefs.boolForKey("remember")
        if rem {
            if let before = prefs.stringForKey("lastPos") {
                storyAudio.currentTime = NSTimeInterval(before)!
            }
        }
        
        updateScrubber()

    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        //playBtn.selected = !playBtn.selected
        //performSegueWithIdentifier("next", sender: self)
        next(UIButton())
    }
    
    func updateScrubber() {
        let currentState = Float(storyAudio.currentTime/storyAudio.duration)
        scrubber.setValue(currentState, animated: true)
        checkTime()
    }
    

    func checkTime() {
        let timeLeft = storyAudio.duration - storyAudio.currentTime;
        let min = Int(timeLeft/60);
        let sec = lround(timeLeft) % 60;
        timer.text = "-"+String(format: "%02d", min)+":"+String(format: "%02d", sec)
    }
    
    @IBAction func play(sender: AnyObject) {
        
        print("is playing \(storyAudio.playing)")
        
        if storyAudio.playing {
            storyAudio.pause()
            playBtn.selected = false

        } else {
            storyAudio.play()
            let displayLink = CADisplayLink(target: self, selector: (#selector(MainViewController.updateScrubber)))
            displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
            playBtn.selected = true
        }
    }
    
    @IBAction func scrubControl(sender: UISlider) {
        storyAudio.currentTime = NSTimeInterval(sender.value)*storyAudio.duration
        checkTime()
    }

    
// Enable once the share button and the parental gate are available
//    @IBAction func share(sender: AnyObject) {
//        if storyAudio.playing {
//            storyAudio.pause()
//            playBtn.selected = !playBtn.selected
//        }
//        
//        let textToShare = "Check out this cool bedtime story!"
//        
//        if let myWebsite = NSURL(string: "http://www.fablemore.com/") {
//            let objectsToShare = [textToShare, myWebsite]
//            let activityViewController = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//            
//            // This lines is for the popover you need to show in iPad
//            activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
//            
//            // This line remove the arrow of the popover to show in iPad
//            activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
//            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: view.frame.size.width/2, y: view.frame.size.height/2, width: 0, height: 0)
//        
//            presentViewController(activityViewController, animated: true, completion: nil)
//
//        }
//    }
    

    @IBAction func ff(sender: AnyObject) {
        if storyAudio.currentTime + ffrwTime < storyAudio.duration {
            let newTime = storyAudio.currentTime + ffrwTime
            storyAudio.currentTime = newTime
        } else {
            storyAudio.currentTime = 0
            storyAudio.stop()
            playBtn.selected = !playBtn.selected
        }
        
    }

    @IBAction func rw(sender: AnyObject) {
        if storyAudio.currentTime - ffrwTime > 0 {
            let newTime = storyAudio.currentTime - ffrwTime
            storyAudio.currentTime = newTime
        } else {
            storyAudio.currentTime = 0
        }
    }
    
    @IBAction func previous(sender: UIButton) {
        if let next = stories.getNext(currentStory-1) {
            if next.ready() {
                didFinishSelecting(currentStory-1)
                return
            }
        }
        performSegueWithIdentifier("next", sender: self)
    }
    
    @IBAction func next(sender: UIButton) {
        
        if let next = stories.getNext(currentStory+1) {
            if next.ready() {
                didFinishSelecting(currentStory+1)
                return
            }
        }
        performSegueWithIdentifier("next", sender: self)
        playBtn.selected = false
    }
    
    @IBAction func clear(segue: UIStoryboardSegue) {
        dim(.Out, speed: dimSpeed)
    }
    
    @IBAction func backToMain(segue: UIStoryboardSegue) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        print("Yay")
        
        
        if segue.identifier == "next" {
            dim(.In, alpha: dimLevel, speed: dimSpeed)
        } else if segue.identifier == "list" {
            if let navVC = segue.destinationViewController as? UINavigationController {
                if let destVC = navVC.topViewController as? ListOfStories {
                    destVC.delegate = self
                }
            }
        }
    }
}

