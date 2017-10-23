//
//  VideoCell.swift
//  bm
//
//  Created by ives on 2017/10/23.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import WebKit
import TRVideoView

class VideoCell: UICollectionViewCell {
    
    var webView: WKWebView?
    var webView_frame: CGRect?
    var bUpdate: Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateViews(list: List) {
        if bUpdate {
            var link: String?
            if list.vimeo.count > 0 {
                link = "https://player.vimeo.com/video/\(list.vimeo)"
            } else {
                link = "https://www.youtube.com/embed/\(list.youtube)?rel=0"
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
        //let bounds_height = self.bounds.height
        //print("bounds_width: \(bounds_width), bounds_height: \(bounds_height)")
        //let ratio: CGFloat = bounds_height / bounds_width
        let width: CGFloat, height: CGFloat, x: CGFloat, y:CGFloat
        //print(ratio)
        
        width = bounds_width - CELL_EDGE_MARGIN * 2
        height = width * 0.75
        x = CELL_EDGE_MARGIN
        y = CELL_EDGE_MARGIN
        
        webView_frame = CGRect(x: x, y: y, width: width, height: height)
    }
}
