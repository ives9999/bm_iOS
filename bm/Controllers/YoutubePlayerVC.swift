//
//  YoutubePlayerVC.swift
//  bm
//
//  Created by ives sun on 2021/9/14.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit
import YouTubePlayer

class YoutubePlayerVC: UIViewController {
    
    @IBOutlet weak var youtubePlayerView: YouTubePlayerView!
    
    var token: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        youtubePlayerView.delegate = self
        youtubePlayerView.playerVars = [
            "controls": "1" as AnyObject,
            "playsinline": "1" as AnyObject
        ] as YouTubePlayerView.YouTubePlayerParameters
        
        if (token != nil) {
            youtubePlayerView.loadVideoID(token!)
        }
    }
    
    @IBAction func prev(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}

extension YoutubePlayerVC: YouTubePlayerDelegate {
    
    func playerReady(_ videoPlayer: YouTubePlayerView) {
        //print("Player Ready!")
        //videoPlayer.loadVideoID("uTYodversoM")
        videoPlayer.play()
    }

    func playerStateChanged(_ videoPlayer: YouTubePlayerView, playerState: YouTubePlayerState) {
        //print("Player state changed!")
    }
}
