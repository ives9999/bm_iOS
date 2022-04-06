//
//  Show_Top.swift
//  bm
//
//  Created by ives on 2022/4/4.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

class ShowTop: UIView {
    
    @IBOutlet weak var titleLbl: SuperLabel!
    @IBOutlet weak var prevImageView: UIImageView!
    
    let nibName = "ShowTop"
    var delegate: BaseViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
    }
    
    func loadViewFromNib() -> UIView? {
        
        let nib: UINib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        //print("prev")
        if (delegate != nil) {
            delegate!.prev()
        }
    }
}
