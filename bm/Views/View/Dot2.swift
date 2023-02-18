//
//  Dot2.swift
//  bm
//
//  Created by ives on 2023/2/18.
//  Copyright © 2023 bm. All rights reserved.
//

import UIKit

class Dot2: UIView {

    init() {
        super.init(frame: .zero)
       
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        anchor()
        self.backgroundColor = UIColor(MY_GREEN)
    }
    
    func anchor() {
        self.snp.makeConstraints { make in
            make.width.height.equalTo(5)
        }
    }
    
//    override func draw(_ rect: CGRect) {
//        let size = self.bounds.size
//        
//        let p1 = self.bounds.origin
//        let p2 = CGPoint(x: p1.x + size.width, y: p1.y)
//        let p3 = CGPoint(x: p2.x, y: p2.y + size.height)
//        let p4 = CGPoint(x: p1.x, y: size.height)
//        
//        let path = UIBezierPath()
//        path.move(to: p1)
//        path.addLine(to: p2)
//        path.addLine(to: p3)
//        path.addLine(to: p4)
//        path.addLine(to: p1)
//        path.close()
//        
//        UIColor.red.set()
//        path.fill()
//    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
