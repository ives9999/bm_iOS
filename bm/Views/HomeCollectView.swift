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
    }
    

}
