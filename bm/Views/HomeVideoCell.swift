//
//  HomeVideoCell.swift
//  bm
//
//  Created by ives on 2017/10/12.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import WebKit
import TRVideoView

class HomeVideoCell: UICollectionViewCell {
    
    var webView: WKWebView?
    var webView_frame: CGRect?
    var bUpdate: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
    func updateViews(home: Home) {
        if bUpdate {
            //print("update web view")
            
            //print(frame)
            //let embedHTML="<iframe src='https://player.vimeo.com/video/\(home.vimeo)' width='640' height='360' frameborder='0' webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>"
            var link: String?
            if home.vimeo.count > 0 {
                link = "https://player.vimeo.com/video/\(home.vimeo)"
            } else {
                link = "https://www.youtube.com/embed/\(home.youtube)?rel=0"
            }
            //print(link)
            
            caculateFrame()
            //print(self.bounds)
            //print(webView_frame!)
            let video = TRVideoView(frame: webView_frame!, text: link!)
            self.addSubview(video)
            bUpdate = false
        }
    }
    
    func caculateFrame() {
        let bounds_width = self.bounds.width
        let bounds_height = self.bounds.height
        let ratio: CGFloat = bounds_height / bounds_width
        let width: CGFloat, height: CGFloat, x: CGFloat, y:CGFloat
        if ratio < 0.75 {
            height = bounds_height - 10
            width = height * 1.33
            y = 5.0
            x = (bounds_width - width) / 2
        } else {
            width = bounds_width - 10
            height = width * 0.75
            x = 5.0
            y = (bounds_height - height) / 2
        }
        self.webView_frame = CGRect(x: x, y: y, width: width, height: height)
    }
}
