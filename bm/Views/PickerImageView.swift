//
//  PickerImageView.swift
//  bm
//
//  Created by ives on 2017/11/9.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit
import QuartzCore
import UIColor_Hex_Swift

@IBDesignable
class PickerImageView: UIView {
    
    var noPhotoImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
    var noPhotoLbl: MyLabel = MyLabel(frame: CGRect(x:0, y: 0, width: 100, height: 30), fontName: FONT_NAME, fontSize: 14)
    var delegate: UIViewController?
    
    func setupView() {
        self.backgroundColor = UIColor.black
        _dashedborder()
        let padding: CGFloat = 10
        var x: CGFloat = (self.frame.width - noPhotoImageView.frame.width) / 2
        var y: CGFloat = (self.frame.height - (noPhotoImageView.frame.height + padding + noPhotoLbl.frame.height)) / 2
        noPhotoImageView.frame = CGRect(x: x, y: y, width: noPhotoImageView.frame.width, height: noPhotoImageView.frame.height)
        noPhotoImageView.image = UIImage(named: "nophoto")
        self.addSubview(noPhotoImageView)
        
        noPhotoLbl.text = "請選擇代表圖"
        noPhotoLbl.sizeToFit()
        x = (self.frame.width - noPhotoLbl.frame.width) / 2
        y = noPhotoImageView.frame.origin.y + noPhotoImageView.frame.height + padding
        noPhotoLbl.frame = CGRect(x: x, y: y, width: noPhotoLbl.frame.width, height: noPhotoLbl.frame.height)
        self.addSubview(noPhotoLbl)
        
        //self.layer.borderWidth = 1
        //self.layer.borderColor = UIColor.red.cgColor
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch begin")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch end")
        let alert = UIAlertController(title: "My Alert", message: "This is an alert", preferredStyle: .alert)
        delegate!.present(alert, animated: true, completion: nil)
    }
    
    private func _dashedborder() {
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = UIColor("#6c6c6e").cgColor
        yourViewBorder.lineDashPattern = [2, 2]
        yourViewBorder.frame = self.bounds
        yourViewBorder.fillColor = nil
        yourViewBorder.path = UIBezierPath(rect: self.bounds).cgPath
        self.layer.addSublayer(yourViewBorder)
    }

}
