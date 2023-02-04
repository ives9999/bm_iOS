//
//  UIImageView.swift
//  bm
//
//  Created by ives on 2022/12/18.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

extension UIImageView {
    
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = UIView.ContentMode.scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
            let data = data, error == nil,
            let image = UIImage(data: data)
                else {return}
            DispatchQueue.main.async {
                self.image = image
                //print(image.size.height)
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = UIView.ContentMode.scaleAspectFit) {
        //print(link)
        guard let url = URL(string: link) else {return}
        downloaded(from: url, contentMode: mode)
    }
    
    func makeRounded() {
        
        self.layer.cornerRadius = (self.frame.width / 2) //instead of let radius = CGRectGetWidth(self.frame) / 2
        self.layer.masksToBounds = true
    }
    
    func sizeOfImageAt(_ link: String) -> CGSize? {
        guard let url = URL(string: link) else {return CGSize(width: 0, height: 0)}
        // with CGImageSource we avoid loading the whole image into memory
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            return nil
        }

        let propertiesOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, propertiesOptions) as? [CFString: Any] else {
            return nil
        }

        if let width = properties[kCGImagePropertyPixelWidth] as? CGFloat,
            let height = properties[kCGImagePropertyPixelHeight] as? CGFloat {
            return CGSize(width: width, height: height)
        } else {
            return nil
        }
    }
    
    func heightForUrl(url: String, width: CGFloat)-> CGFloat {
        
        var featured_h: CGFloat = 0
        let featured_size: CGSize? = (self.sizeOfImageAt(url))
        //print("featured height: \(featunred_h)")
        if featured_size != nil && featured_size!.height > 0 {
            if featured_size!.width > 0 && featured_size!.height > 0 {
                let w = featured_size!.width
                let h = featured_size!.height
                let scale: CGFloat
                if w > h {
                    scale = width / w
                } else {
                    scale = width / h
                }
                featured_h = h * scale
            }
        } else {
            featured_h = 300
        }
        
        return featured_h
    }
}
