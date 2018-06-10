//
//  TempPlayTableHeaderView.swift
//  bm
//
//  Created by ives on 2017/12/14.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

class TempPlayTableHeaderView: UIView {

    var label1: SuperLabel!
    var label2: SuperLabel!
    var line: UIView!
    
    convenience init(){
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        line.frame = CGRect(x: 0, y: self.frame.height - 1, width: self.frame.width, height: 1.0)
    }
    
    func setup() {
        label1 = SuperLabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        label2 = SuperLabel(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        //label1.adjustsFontSizeToFitWidth = true
        //label2.adjustsFontSizeToFitWidth = true
        //label1.textAlignment = left
        //label2.textAlignment = left
        //label1.backgroundColor = UIColor.black
        //label2.backgroundColor = UIColor.black
        label1.text = "臨打球友"
        label2.text = "加入日期"
        label1.sizeToFit()
        label2.sizeToFit()
        self.addSubview(label1)
        self.addSubview(label2)
        
        line = UIView()
        line.layer.borderWidth = 1.0
        line.layer.borderColor = UIColor.gray.cgColor
        self.addSubview(line)
        
        let views: [[String: UILabel]] = [["label1":label1], ["label2":label2]]
        let constraints: [NSLayoutConstraint] = tempPlayShowTableConstraint(views)
        
        
        /*
         var constraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
        let views:[String:Any] = ["label1":label1, "label2":label2]
        let horiCs1: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[label1]", options: .alignAllCenterY, metrics: nil, views: views)
        constraints += horiCs1
        let horiCs2: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:[label2]-30-|", options: .alignAllCenterY, metrics: nil, views: views)
        constraints += horiCs2
        //let horiCs: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: "H:|-\(constant.name_left_padding)-[label1]-[label2]-\(constant.name_left_padding)-|", options: .alignAllCenterY, metrics: nil, views: ["label1":label1,"label2":label2])
        let vertiC1 = NSLayoutConstraint(item: label1, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier:
            1, constant: 0)
        let vertiC2 = NSLayoutConstraint(item: label2, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier:
            1, constant: 0)
        constraints.append(vertiC1)
        constraints.append(vertiC2)*/
        self.addConstraints(constraints)
    }
}
