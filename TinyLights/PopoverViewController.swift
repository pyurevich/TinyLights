//
//  PopoverView.swift
//  TinyLights
//
//  Created by Pavel Yurevich on 3/9/16.
//  Copyright © 2016 Pavel Yurevich. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {
    
    
    @IBOutlet weak var messageLabel: UIButton!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    var nextStory: Int = 2
    
    @IBAction func proceedToDownload(_ sender: Any) {
        print("Pressed!")
        
        //self.dismiss(animated: true, completion: {})
        performSegue(withIdentifier: "listagain", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = UIImage(named: "bigChapter\(nextStory)")
        if nextStory > 3 {
            print("Changing for more!")
            messageLabel.isUserInteractionEnabled = false
            messageLabel.setTitle("Coming soon!", for: .normal)
        } else {
            print("Changing for less!")
            messageLabel.isUserInteractionEnabled = true
            messageLabel.setTitle("Download next chapter here!", for: .normal)
        }
        imageView.layer.cornerRadius = 10
        popupView.layer.cornerRadius = 10
        popupView.layer.borderColor = UIColor.black.cgColor
        popupView.layer.borderWidth = 0.25
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOpacity = 0.6
        popupView.layer.shadowRadius = 15
        popupView.layer.shadowOffset = CGSize(width: 5, height: 5)
        popupView.layer.masksToBounds = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "listagain" {
            print("About to segue to listagain!")
            let listUICont = ((segue.destination as! UINavigationController).topViewController as? ListOfStories)
            print(String(describing: listUICont))
            print(String(describing: self.presentingViewController))
            listUICont?.delegate = self.presentingViewController as? PlaySongDelegate
            print(String(describing: listUICont?.delegate))
            
        }
    }
}
