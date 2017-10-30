//
//  TeamVC.swift
//  bm
//
//  Created by ives on 2017/10/3.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import Device_swift

class TeamVC: ListVC {
//class TeamVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let _type:String = "team"
    
    @IBOutlet weak var menuBtn: UIButton!
    
    override func viewDidLoad() {
        //print("self: \(self)")
        //print("super: \(super)")
        setIden(item:_type, titleField: "name")
        super.viewDidLoad()
        
        //let l: UILabel = UILabel(frame: CGRect(x: 0, y:100, width: 100, height: 100))
        //l.text = "label"
        //l.textColor = UIColor.white
        //self.view.addSubview(l)
        
        Global.instance.menuPressedAction(menuBtn, self)
        
        getData()
    
    }
    
}
