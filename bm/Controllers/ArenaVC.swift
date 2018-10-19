//
//  ArenaVC.swift
//  bm
//
//  Created by ives on 2018/7/28.
//  Copyright © 2018年 bm. All rights reserved.
//

import UIKit

class ArenaVC: ListVC {
    
    let maskView = UIView()
    let containerView = UIView(frame: .zero)
    let searchTableView: UITableView = {
        let cv = UITableView(frame: .zero, style: .plain)
        cv.backgroundColor = UIColor.black
        return cv
    }()
    
    let padding: CGFloat = 20
    let headerHeight: CGFloat = 84
    var layerHeight: CGFloat!
    
    override func viewDidLoad() {
        myTablView = tableView
        dataService = ArenaService.instance
        _type = "arena"
        _titleField = "name"
        super.viewDidLoad()
        layerHeight = view.frame.height-200
        searchTableView.dataSource = self
        searchTableView.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return lists.count
        } else {
            return 3
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "listcell", for: indexPath) as? ListCell {
                
                cell.cellDelegate = self
                let row = lists[indexPath.row]
                cell.updateViews(indexPath: indexPath, data: row, iden: _type)
                
                return cell
            } else {
                return ListCell()
            }
        }
        
        return UITableViewCell()
    }
    
    @objc func mapPrepare(sender: UITapGestureRecognizer) {
        let label = sender.view as! UILabel
        let idx = label.tag
        let row = lists[idx]
        let address = row.data[ADDRESS_KEY]!["value"] as! String
        let title = row.title
        let sender: [String: String] = [
            "title": title,
            "address": address
        ]
        performSegue(withIdentifier: "toMap", sender: sender)
    }

    @IBAction func searchBtnPressed(_ sender: Any) {
        mask()
        addLayer()
        animation()
    }
    
    func mask() {
        maskView.backgroundColor = UIColor(white: 0, alpha: 0.5)
    maskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(unmask)))
        tableView.addSubview(maskView)
        maskView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: view.frame.height)
        maskView.alpha = 0
    }
    
    func addLayer() {
        tableView.addSubview(containerView)
        containerView.frame = CGRect(x:padding, y:tableView.frame.height, width:view.frame.width-(2*padding), height:layerHeight)
        containerView.backgroundColor = UIColor.white
        
    }
    
    func animation() {
        let y = tableView.frame.height - layerHeight
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.maskView.alpha = 1
            self.containerView.frame = CGRect(x: self.padding, y: y, width: self.containerView.frame.width, height: self.containerView.frame.height)
        }, completion: { (finished) in
            if finished {
                let frame = self.containerView.frame
                self.searchTableView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
                self.searchTableView.backgroundColor = UIColor.clear
                self.containerView.addSubview(self.searchTableView)
            }
        })
    }
    
    @objc func unmask() {
        UIView.animate(withDuration: 0.5) {
            self.maskView.alpha = 0
            self.searchTableView.frame = CGRect(x:self.padding, y:self.view.frame.height, width:self.searchTableView.frame.width, height:self.searchTableView.frame.height)
        }
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
}
