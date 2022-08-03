//
//  SearchVC_next.swift
//  bm
//
//  Created by ives on 2018/9/28.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class SearchVC_next: BaseViewController {

    var type: String!
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    let padding: CGFloat = 20
    let headerHeight: CGFloat = 84
    var layerHeight: CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layerHeight = view.frame.height-200
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cityBtnPressed(_ sender: Any) {
        mask()
        addLayer()
        animation()
    }
    
    func addLayer() {
        view.addSubview(collectionView)
        collectionView.frame = CGRect(x:padding, y:view.frame.height, width:view.frame.width-(2*padding), height:layerHeight)
    }
    
    func animation() {
        let y = view.frame.height - layerHeight
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.maskView.alpha = 1
            self.collectionView.frame = CGRect(x: self.padding, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
        }, completion: nil)
    }
    
    func mask() {
        maskView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        maskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(unmask)))
        view.addSubview(maskView)
        maskView.frame = CGRect(x: 0, y: headerHeight, width: view.frame.width, height: view.frame.height-headerHeight)
        maskView.alpha = 0
    }
    
    @objc override func unmask() {
        UIView.animate(withDuration: 0.5) {
            self.maskView.alpha = 0
            self.collectionView.frame = CGRect(x:self.padding, y:self.view.frame.height, width:self.collectionView.frame.width, height:self.collectionView.frame.height)
        }
    }

}
