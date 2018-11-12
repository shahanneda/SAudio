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
    
    @IBOutlet weak var TestView: UIView!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let sound = Bundle.main.path(forResource: "music", ofType: "mp3")
        print("View did load just ran")

        audioPlayer =  AVPlayer(url: URL(fileURLWithPath: sound!))
        playerViewController.player = audioPlayer
        playerViewController.contentOverlayView?.addSubview(TestView)

        self.addChild(playerViewController)
        self.view.addSubview(playerViewController.view)
        

        playerViewController.view.frame = self.view.frame
        TestView.addConstraint(
            NSLayoutConstraint(item: TestView,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: TestView,
                               attribute: .centerX,
                               multiplier: 1, constant: 0)
        )
//                playerViewController.player!.play()
        

        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode(rawValue: convertFromAVAudioSessionMode(AVAudioSession.Mode.default)), options: [.mixWithOthers, .allowAirPlay])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
        
//        Slider.maximumValue = Float(CMTimeGetSeconds((audioPlayer.currentItem?.asset.duration)!));
//        Slider.value = 0;
//        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.UpdateSlider), userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //should be called when the slider is dragged
    @IBAction func SliderSlide(_ sender: UISlider) {
//        audioPlayer.seek(to: CMTime() = ;
    }
    
    @objc func UpdateSlider(_ timer: Timer){
//        Slider.setValue(Float(audioPlayer.currentTime), animated: false)
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

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionMode(_ input: AVAudioSession.Mode) -> String {
	return input.rawValue
}
