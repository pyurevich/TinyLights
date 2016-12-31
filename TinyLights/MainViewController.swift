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
    
    @IBAction func leftSwipe(_ sender: UISwipeGestureRecognizer) {
        
        previous(UIButton())
        print(sender.direction)
        print("Swiped!")
    }
    
    @IBAction func RightSwipe(_ sender: UISwipeGestureRecognizer) {
        
        next(UIButton())
        print(sender.direction)
        print("Swiped!")
    }
    
    let stories = StoryManager.sharedInstance
    
    var storySession: AVAudioSession!
    var storyAudio: AVAudioPlayer! = nil
    //var path: String
    let dimLevel: CGFloat = 0.5
    var dimmed = false
    let dimSpeed: Double = 0.5
    let ffrwTime: TimeInterval = 10
    let playPos = 3
    var currentStory = Int()
    
    @IBOutlet weak var storyImage: UIImageView!
    @IBOutlet weak var toolbar: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var scrubber: UISlider!
    @IBOutlet weak var timer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //path = String(describing: stories.getNext(0)?.getMP3())
        
        toolbar.layer.shadowColor = UIColor.black.cgColor
        toolbar.layer.shadowOpacity = 0.4
        toolbar.layer.shadowRadius = 5
        toolbar.layer.shadowOffset = CGSize(width: 0, height: 0)
        toolbar.layer.masksToBounds = false
        
        scrubber.setThumbImage(UIImage(named: "Scrubber"), for: UIControlState())
        scrubber.setThumbImage(UIImage(named: "scrubber.png"), for: UIControlState.highlighted)
        scrubber.layer.shadowColor = UIColor.black.cgColor
        scrubber.layer.shadowOpacity = 0.4
        scrubber.layer.shadowRadius = 2
        scrubber.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        
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

    
    func didFinishSelecting(storyInList: Int) {
        
        do {
            storySession = AVAudioSession.sharedInstance()
            try storySession.setCategory(AVAudioSessionCategoryPlayback)
            try storySession.setActive(true)
            storyAudio = try AVAudioPlayer(contentsOf: (stories.getNext(storyInList)?.getMP3())!)
            storyAudio.delegate = self
            //storyImage.image = stories.getNext(storyInList)?.bgImage
        
    
            UIView.transition(with: self.storyImage,
                              duration: 0.3,
                              options: .transitionCrossDissolve,
                              animations: {
                                self.storyImage.image = self.stories.getNext(storyInList)?.bgImage
            },
                              completion: nil)
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
            updateScrubber()
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
            updateScrubber()
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
        //performSegue(withIdentifier: "next", sender: self)
        storyAudio.currentTime = 0
        updateScrubber()
        shake(self.view)
    }
    
    @IBAction func next(_ sender: UIButton) {
        
        if let next = stories.getNext(currentStory+1) {
            if next.ready() {
                didFinishSelecting(storyInList: currentStory+1)
                return
            }
        }
        storyAudio.stop()
        playBtn.isSelected = false
        print(currentStory)
        if currentStory < 4 {
            performSegue(withIdentifier: "next", sender: self)
        } else {
            shake(self.view)
        }
        
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
            if let navVC = segue.destination as? PopoverViewController {
                navVC.nextStory = currentStory+2
            }
        } else if segue.identifier == "list" {
            if let navVC = segue.destination as? UINavigationController {
                if let destVC = navVC.topViewController as? ListOfStories {
                    destVC.delegate = self
                }
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

