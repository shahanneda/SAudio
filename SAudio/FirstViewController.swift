//
//  FirstViewController.swift
//  SAudio
//
//  Created by Shahan Nedadahandeh on 2018-11-11.
//  Copyright © 2018 Shahan Nedadahandeh. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let fileManager = FileManager.default
        
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print(documentsURL)
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            
            
            for url in fileURLs{
//               / let fileName = url.lastPathComponent
                print(url);
            }
            
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func GoToModal(_ sender: UIButton) {
//        performSegue(withIdentifier: "TestModal", sender: self)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "AudioViewController") as! AudioViewController
        newViewController.NameOfMedia = "music"
        self.present(newViewController, animated: true, completion : nil)
    }
}
    


