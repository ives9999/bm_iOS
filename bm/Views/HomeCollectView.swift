//
//  HomeCollectView.swift
//  bm
//
//  Created by ives on 2017/10/11.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class HomeCollectView: UICollectionView {
    
    override func reloadItems(at indexPaths: [IndexPath]) {
        let indexPath = indexPaths[0]
        let section = indexPaths[0].section
        let row = indexPaths[0].row
        print("reload => section: \(section), row: \(row)")
        let cell = self.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        //let cell = self.cellForItem(at: indexPath) as! HomeCell
        let embedHTML="<iframe src='https://player.vimeo.com/video/235344541' width='640' height='360' frameborder='0' webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>"
        //let url: URL = URL(string: "https://")!
        print(cell.webView)
        cell.webView!.loadHTMLString(embedHTML, baseURL: nil)
    }
    

}
