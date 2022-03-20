//
//  tab_search.swift
//  bm
//
//  Created by ives on 2022/3/18.
//  Copyright © 2022 bm. All rights reserved.
//

import UIKit

class tab_search: UIView {
    
    var view: _tab_search?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addXibView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        //commonInit()
    }
    
    func addXibView() {
        
        view = UINib(nibName: "_tab_search", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! _tab_search
        //Bundle.main.loadNibNamed("tab_search", owner: self, options: nil)
        view!.frame = bounds
        view!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view!)
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
