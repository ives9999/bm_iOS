//
//  HomeCell.swift
//  bm
//
//  Created by ives on 2017/10/4.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import TRVideoView

class HomeCell: UICollectionViewCell {
    
    @IBOutlet weak var featured: UIImageView!
    @IBOutlet weak var title: UILabel!
    var webView: UIWebView?
    
    func updateViews(home: Home) {
        if (home.path.count > 0){
            featured.image = home.featured
            title.text = home.title
        } else {
            if (home.vimeo.count > 0) {
                let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                webView = UIWebView(frame: frame)
                //let embedHTML="<iframe src='https://player.vimeo.com/video/\(home.vimeo)' width='640' height='360' frameborder='0' webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>"
                //let url: URL = URL(string: "https://")!
                //v.loadHTMLString(embedHTML, baseURL: nil)
                self.addSubview(webView!)
                //print(home.vimeo)
                //let video = TRVideoView(text: "https://vimeo.com/\(home.vimeo)")
                //video.frame(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
                //video.containsURLs()
                //self.addSubview(video)
            }
        }
    }
    
}
