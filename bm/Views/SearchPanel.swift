//
//  SearchPanel.swift
//  bm
//
//  Created by ives sun on 2021/6/11.
//  Copyright © 2021 bm. All rights reserved.
//

import UIKit

class SearchPanel {
    
    var searchPanelisHidden = true
    
    var tableView: UITableView!
    let maskView = UIView()
    
    func showSearchPanel() {
        searchPanelisHidden = false
        tableView.isScrollEnabled = false
        mask(y: titleBarHeight, superView: view)
        var frame: CGRect = CGRect(x:padding, y:workAreaHeight + newY, width:view.frame.width-(2*padding), height:layerHeight)
        addLayer(superView: view, frame: frame)
        let y = titleBarHeight + 50
        frame = CGRect(x: self.padding, y: y, width: self.containerView.frame.width, height: self.layerHeight)
        animation(frame: frame)
    }
 
    func mask(y: CGFloat, superView: UIView? = nil, height: CGFloat? = nil) {
        maskView.backgroundColor = UIColor(white: 1, alpha: 0.8)
        maskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(unmask)))
        var _view = view
        if superView != nil {
            _view = superView
        }
        _view?.addSubview(maskView)
        
        var _height = view.bounds.height - titleBarHeight
        if height != nil {
            _height = height!
        }
        maskView.frame = CGRect(x: 0, y: y, width: (_view?.frame.width)!, height: _height)
        maskView.alpha = 0
    }
}
