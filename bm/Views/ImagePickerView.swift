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

protocol ImagePickerViewDelegate {
    func isImageSet(_ b: Bool)
    func myPresent(_ viewController: UIViewController)
}

@IBDesignable
class ImagePickerView: UIView {
    
    var noPhotoImageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
    var noPhotoLbl: MyLabel = MyLabel(frame: CGRect(x:0, y: 0, width: 100, height: 30), fontName: FONT_NAME, fontSize: 14)
    var imageView: UIImageView = UIImageView(frame: CGRect.zero)
    var delegate: ImagePickerViewDelegate?
    var gallery: UIImagePickerController?
    
    func setupView() {
        self.backgroundColor = UIColor.black
        _dashedborder()
        
        imageView.frame = self.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        self.addSubview(imageView)
        
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
        
        //gallery.delegate = self.delegate as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
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
        //print("touch begin")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //print("touch end")
        let slide: UIAlertController = UIAlertController(title: "", message: "新增圖片從", preferredStyle: .alert)
        let pictureAction: UIAlertAction = UIAlertAction(title: "照片", style: .default) { (action) in
            //print(action)
            self.openGallery()
        }
        slide.addAction(pictureAction)
        let cameraAction: UIAlertAction = UIAlertAction(title: "相機", style: .default) { (action) in
            self.openCamera()
        }
        slide.addAction(cameraAction)
        let cancelAction: UIAlertAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        slide.addAction(cancelAction)
        delegate!.myPresent(slide)
    }
    
    func openGallery() {
        //print("aaa")
        gallery!.sourceType = UIImagePickerController.SourceType.photoLibrary
        gallery!.allowsEditing = true
        delegate!.myPresent(gallery!)
    }
    func openCamera() {
        gallery!.sourceType = UIImagePickerController.SourceType.camera
        gallery!.allowsEditing = true
        gallery!.cameraCaptureMode = .photo
        gallery!.modalPresentationStyle = .fullScreen
        delegate!.myPresent(gallery!)
    }
    
    func setPickedImage(image: UIImage) {
        noPhotoImageView.isHidden = true
        noPhotoLbl.isHidden = true
        imageView.isHidden = false
        imageView.image = image
        self.addSubview(imageView)
        delegate!.isImageSet(true)
    }
    
    func setPickedImage(url: String) {
        noPhotoImageView.isHidden = true
        noPhotoLbl.isHidden = true
        imageView.isHidden = false
        imageView.downloaded(from: url)
        self.addSubview(imageView)
        delegate!.isImageSet(true)
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
