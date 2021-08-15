//
//  BarcodeCell.swift
//  bm
//
//  Created by ives on 2021/8/15.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class BarcodeCell: SuperCell {
    
    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var barcodeImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        //titleLbl.setTextTitle()
    }
    
    func update(title: String, barcode: String) {
        
        //self.backgroundColor = UIColor.clear
        titleLbl.text = title
        
        let inputData = barcode.data(using: String.Encoding.utf8, allowLossyConversion: false)
        let filter = CIFilter.init(name: "CICode128BarcodeGenerator")!
        filter.setValue(inputData, forKey: "inputMessage")
        let ciImage = filter.outputImage!
        let barcodeImage = UIImage(ciImage: ciImage)
        barcodeImageView.image = barcodeImage
    }
}
