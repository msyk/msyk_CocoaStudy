//
//  ViewController.swift
//  DemoAVF
//
//  Created by 新居雅行 on 2015/01/17.
//  Copyright (c) 2015年 msyk.net. All rights reserved.
//

import Cocoa
import AVKit
import AVFoundation

class ViewController: NSViewController {
    
    @IBOutlet weak var playerView: AVPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // playerView.player.
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func pushButton1(sender: NSButton) {
        
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = false
        openPanel.canChooseFiles = true
        openPanel.beginSheetModalForWindow(self.view.window!,
            completionHandler: {(result :Int)-> (Void) in
                if (result != 0)    {
                    self.playerView.player = AVPlayer.playerWithURL(openPanel.URL) as AVPlayer;
                    
                    let videoItem = self.playerView.player.currentItem
                    let duration = videoItem.duration
                    print("-----Movie Duration: ")
                    CMTimeShow(duration)
                    let movieSize = videoItem.presentationSize;
                    print("-----Movie Size: \(NSStringFromSize(movieSize))")
                    
                }
            }
        );
    }
    
    @IBAction func pushButton2(sender: NSButton) {
        if let player = playerView.player {
            let status = player.status
            println("-----AVPlyer Item Status: \(status.rawValue)")
            
            let curTime = player.currentTime()
            print("-----Current Time: ")
            CMTimeShow(curTime)
            
            let curDate = player.currentItem.currentDate()
            println("-----Current Time: \(curDate)")
            
        }
    }
    
    @IBAction func pushButton3(sender: NSButton) {
        if let player = playerView.player {
            
            let jumpTime = CMTimeMakeWithSeconds(10.0, 30000);
            player.currentItem.seekToTime(jumpTime,
                completionHandler: {(result: Bool) -> Void in
                    println("Seeked")
            })
            
//            player.currentItem.stepByCount(1)
//            
//            player.currentItem.stepByCount(30 * 60)
            
        }
    }
}

