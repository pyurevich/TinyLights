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
    let path = Bundle.main.path(forResource: "jill0", ofType: "mp3")!
    let dimLevel: CGFloat = 0.5
    var dimmed = false
    let dimSpeed: Double = 0.5
    let ffrwTime: TimeInterval = 10
    let playPos = 3
    var currentStory = Int()
    
    let stories = StoryManager.sharedInstance
    
    @IBOutlet weak var toolbar: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var scrubber: UISlider!
    @IBOutlet weak var timer: UILabel!
    
    func didFinishSelecting(storyInList: Int) {
        
        do {
            storySession = AVAudioSession.sharedInstance()
            try storySession.setCategory(AVAudioSessionCategoryPlayback)
            try storySession.setActive(true)
            storyAudio = try AVAudioPlayer(contentsOf: (stories.getNext(storyInList)?.getMP3())!)
            storyAudio.delegate = self
            storyAudio.prepareToPlay()
            
        } catch {
            // couldn't load file :( - nothing for now
        }
        
        
        stories.getNext(currentStory)!.setStatus(.ready)
        
        currentStory = storyInList
        stories.currentStory = storyInList
        stories.getNext(currentStory)!.setStatus(.playing)
        
        
        print("Tag is \(storyInList) + \((stories.getNext(storyInList)?.getMP3())!)")
        
        if playBtn.isSelected {
            play("" as AnyObject)
        }
        checkTime()
        updateScrubber()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolbar.layer.shadowColor = UIColor.black.cgColor
        toolbar.layer.shadowOpacity = 0.6
        toolbar.layer.shadowRadius = 5
        toolbar.layer.shadowOffset = CGSize(width: 0, height: 5)
        toolbar.layer.masksToBounds = false
        
        scrubber.setThumbImage(UIImage(named: "Scrubber"), for: UIControlState())
        scrubber.setThumbImage(UIImage(named: "scrubber.png"), for: UIControlState.highlighted)
        
        
        if let url = stories.getNext(0)!.mp3Path {
            do {
                storySession = AVAudioSession.sharedInstance()
                try storySession.setCategory(AVAudioSessionCategoryPlayback)
                try storySession.setActive(true)
                storyAudio = try AVAudioPlayer(contentsOf: url)
                storyAudio.delegate = self
                storyAudio.prepareToPlay()
                stories.getNext(0)!.setStatus(.playing)
            } catch {
                // couldn't load file :( - nothing for now
            }
        } else {
            print("URL does not exist")
        }
        
        let prefs = UserDefaults.standard
        var appDefaults = Dictionary<String, AnyObject>()
        appDefaults["remember"] = true as AnyObject?
        UserDefaults.standard.register(defaults: appDefaults)
        UserDefaults.standard.synchronize()
        
        let rem = prefs.bool(forKey: "remember")
        if rem {
            if let before = prefs.string(forKey: "lastPos") {
                storyAudio.currentTime = TimeInterval(before)!
            }
        }
        
        updateScrubber()

    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
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
    
    @IBAction func play(_ sender: AnyObject) {
        
        print("is playing \(storyAudio.isPlaying)")
        
        if storyAudio.isPlaying {
            storyAudio.pause()
            playBtn.isSelected = false

        } else {
            storyAudio.play()
            let displayLink = CADisplayLink(target: self, selector: (#selector(MainViewController.updateScrubber)))
            displayLink.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            playBtn.isSelected = true
        }
    }
    
    @IBAction func scrubControl(_ sender: UISlider) {
        storyAudio.currentTime = TimeInterval(sender.value)*storyAudio.duration
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
    

    @IBAction func ff(_ sender: AnyObject) {
        if storyAudio.currentTime + ffrwTime < storyAudio.duration {
            let newTime = storyAudio.currentTime + ffrwTime
            storyAudio.currentTime = newTime
        } else {
            storyAudio.currentTime = 0
            storyAudio.stop()
            playBtn.isSelected = !playBtn.isSelected
        }
        
    }

    @IBAction func rw(_ sender: AnyObject) {
        if storyAudio.currentTime - ffrwTime > 0 {
            let newTime = storyAudio.currentTime - ffrwTime
            storyAudio.currentTime = newTime
        } else {
            storyAudio.currentTime = 0
        }
    }
    
    @IBAction func previous(_ sender: UIButton) {
        if let next = stories.getNext(currentStory-1) {
            if next.ready() {
                didFinishSelecting(storyInList: currentStory-1)
                return
            }
        }
        performSegue(withIdentifier: "next", sender: self)
    }
    
    @IBAction func next(_ sender: UIButton) {
        
        if let next = stories.getNext(currentStory+1) {
            if next.ready() {
                didFinishSelecting(storyInList: currentStory+1)
                return
            }
        }
        performSegue(withIdentifier: "next", sender: self)
        storyAudio.stop()
        playBtn.isSelected = false
    }
    
    @IBAction func clear(_ segue: UIStoryboardSegue) {
        dim(.out, speed: dimSpeed)
        dimmed = false
    }
    
    @IBAction func backToMain(_ segue: UIStoryboardSegue) {
        if dimmed {
            dim(.out, speed: dimSpeed)
            dimmed = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("Yay")
        
        
        if segue.identifier == "next" {
            dim(.in, alpha: dimLevel, speed: dimSpeed)
            dimmed = true
        } else if segue.identifier == "list" {
            if let navVC = segue.destination as? UINavigationController {
                if let destVC = navVC.topViewController as? ListOfStories {
                    destVC.delegate = self
                }
            }
        }
    }
}

