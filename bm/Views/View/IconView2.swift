//
//  IconView2.swift
//  bm
//
//  Created by ives on 2023/2/17.
//  Copyright © 2023 bm. All rights reserved.
//

import UIKit

class IconView2: UIView {

//    private var shapeLayer: CAShapeLayer = {
//
//        let _shapeLayer = CAShapeLayer()
//        _shapeLayer.fillColor = UIColor(MY_RED).cgColor
//        self.layer.insertSublayer(_shapeLayer, at: 0)
//
//        return shapeLayer
//    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        
//        let center = CGPoint(x: bounds.midX, y: bounds.midY)
//        let radius = min(bounds.size.width, bounds.size.height) / 2
//        shapeLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true).cgPath
    }

}















