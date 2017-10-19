//
//  Global.swift
//  bm
//
//  Created by ives on 2017/10/7.
//  Copyright © 2017年 bm. All rights reserved.
//

import Foundation
import UIKit
import Device_swift

var gSimulate:Bool = false
let gRequestHeader = [
    "Content-Type": "application/json; charset=utf-8"
    ]

class Global {
    
    var spinner: UIActivityIndicatorView?
    var progressLbl: UILabel?
    
    static let instance = Global()
    
    func deviceType(frameWidth: CGFloat) -> DeviceType {
        var deviceType: DeviceType = UIDevice.current.deviceType
        if (deviceType == .simulator) {
            deviceType = (frameWidth >= 500) ? .iPad : .iPhone7
        } else {
            let tmp: String = UIDevice.current.deviceType.displayName
            //print(tmp)
            if tmp.hasPrefix("iPad") {
                deviceType = .iPad
            } else {
                deviceType = .iPhone7
            }
        }
        
        return deviceType
    }
    
    func addSpinner(center: CGPoint, superView: UIView) {
        spinner = UIActivityIndicatorView()
        //spinner?.center = CGPoint(x: (homeCV.bounds.width / 2) - ((spinner?.bounds.width)! / 2), y: homeCV.bounds.height / 2)
        spinner?.center = center
        spinner?.activityIndicatorViewStyle = .whiteLarge
        spinner?.color = #colorLiteral(red: 0.6862745098, green: 0.9882352941, blue: 0.4823529412, alpha: 1)
        spinner?.startAnimating()
        superView.addSubview(spinner!)
    }
    
    func removeSpinner() {
        if spinner != nil {
            spinner?.removeFromSuperview()
        }
    }
    
    func addProgressLbl(center: CGPoint, superView: UIView) {
        progressLbl = UILabel()
        progressLbl?.frame = CGRect(x: Int(center.x) - LOADING_WIDTH / 2, y: Int(center.y) + LOADING_HEIGHT / 2, width: LOADING_WIDTH, height: LOADING_HEIGHT)
        progressLbl?.font = UIFont(name: "Avenir Next", size: 18)
        progressLbl?.textColor = #colorLiteral(red: 0.6862745098, green: 0.9882352941, blue: 0.4823529412, alpha: 1)
        progressLbl?.textAlignment = .center
        progressLbl?.text = LOADING
        superView.addSubview(progressLbl!)
    }
    
    func removeProgressLbl() {
        if progressLbl != nil {
            progressLbl?.removeFromSuperview()
        }
    }
}
extension UIFont {
    func withTraits(traits:UIFontDescriptorSymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep size as it is
    }
    func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }
    
    func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}
