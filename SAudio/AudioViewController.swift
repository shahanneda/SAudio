//
//  AudioViewController.swift
//  SAudio
//
//  Created by Shahan Nedadahandeh on 2018-11-11.
//  Copyright © 2018 Shahan Nedadahandeh. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class AudioViewController: UIViewController {
    var audioPlayer = AVPlayer()
    let playerViewController = AVPlayerViewController()
    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?
    
    @IBOutlet weak var TestView: UIView!

    public var NameOfMedia : String?;
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.view.addGestureRecognizer(gestureRecognizer)
        if(NameOfMedia != nil){
            let sound = Bundle.main.path(forResource: "music", ofType: "mp3")
            print("View did load just ran")
            audioPlayer =  AVPlayer(url: URL(fileURLWithPath: sound!))
            playerViewController.player = audioPlayer
            playerViewController.contentOverlayView?.addSubview(TestView)
            self.addChild(playerViewController)
            self.view.addSubview(playerViewController.view)
            //To Center
            self.TestView.frame.size.height = self.playerViewController.view.bounds.height
            self.TestView.frame.size.width = self.playerViewController.view.bounds.width
            self.TestView.center = CGPoint(x: self.playerViewController.view.bounds.midX,
                                           y: self.playerViewController.view.bounds.midY);
    //                playerViewController.player!.play()
        
            //To play in background :
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode(rawValue: convertFromAVAudioSessionMode(AVAudioSession.Mode.default)), options: [.mixWithOthers, .allowAirPlay])
                print("Playback OK")
                try AVAudioSession.sharedInstance().setActive(true)
                print("Session is Active")
            } catch {
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func PauseButtonClicked(_ sender: UIButton) {
        audioPlayer.pause()
    }
    @IBAction func PlayButtonClicked(_ sender: UIButton) {
        audioPlayer.play()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func handlePan(_ panGesture: UIPanGestureRecognizer){
        let translation = panGesture.translation(in: view)
        
        if panGesture.state == .began {
            originalPosition = view.center
            currentPositionTouched = panGesture.location(in: view)
        } else if panGesture.state == .changed {
            view.frame.origin = CGPoint(
                x: 0,
                y: translation.y
            )
        } else if panGesture.state == .ended {
            let velocity = panGesture.velocity(in: view)
            
            if velocity.y >= 1500 {
                UIView.animate(withDuration: 0.2
                    , animations: {
                        self.view.frame.origin = CGPoint(
                            x: self.view.frame.origin.x,
                            y: self.view.frame.size.height
                        )
                }, completion: { (isCompleted) in
                    if isCompleted {
                        self.dismiss(animated: false, completion: nil)
                    }
                })
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.center = self.originalPosition!
                })
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionMode(_ input: AVAudioSession.Mode) -> String {
	return input.rawValue
}
