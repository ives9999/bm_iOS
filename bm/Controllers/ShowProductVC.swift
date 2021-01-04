//
//  ShowProductVC.swift
//  bm
//
//  Created by ives on 2021/1/3.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation

class ShowProductVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContainerView: UIView!
    
    @IBOutlet weak var featured: UIImageView!
    
    @IBOutlet weak var productDataLbl: SuperLabel!
    @IBOutlet weak var contentLbl: SuperLabel!
    
    @IBOutlet weak var tableView: SuperTableView!
    var contentView: UIView!
    
    @IBOutlet weak var tableViewConstraintHeight: NSLayoutConstraint!
    @IBOutlet weak var ContainerViewConstraintHeight: NSLayoutConstraint!
    
    var contentViewConstraintHeight: NSLayoutConstraint?
    
    var superProduct: SuperProduct?
    var product_token: String?
    
    var tableRowKeys:[String] = ["tel_text","mobile_text","address","fb","line","website","email","business_time","pv","created_at_text"]
    var tableRows: [String: [String:String]] = [
        "tel_text":["icon":"tel","title":"市內電話","content":""],
        "mobile_text":["icon":"mobile","title":"行動電話","content":""],
        "address":["icon":"marker","title":"住址","content":""],
        "fb":["icon":"fb","title":"FB","content":""],
        "line":["icon":"line","title":"line","content":""],
        "website":["icon":"website","title":"網站","content":""],
        "email":["icon":"email1","title":"email","content":""],
        "business_time":["icon":"clock","title":"營業時間","content":""],
        "pv":["icon":"pv","title":"瀏覽數","content":""],
        "created_at_text":["icon":"calendar","title":"建立日期","content":""]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //print(superStore)
        scrollView.backgroundColor = UIColor.clear
        
        let cellNib = UINib(nibName: "OneLineCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        
        initTableView()
        //initContentView()
        
        beginRefresh()
        scrollView.addSubview(refreshControl)
        refresh()
    }
    
    override func viewWillLayoutSubviews() {
        productDataLbl.text = "商品資料"
        contentLbl.text = "詳細介紹"
        
        productDataLbl.textColor = UIColor(MY_RED)
        productDataLbl.textAlignment = .left
        contentLbl.textColor = UIColor(MY_RED)
        contentLbl.textAlignment = .left
    }
    
    func initTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        //tableView.estimatedRowHeight = 600
        tableViewConstraintHeight.constant = 600
    }
    
    func initContentView() {
        
        scrollContainerView.addSubview(contentView!)
        var c1: NSLayoutConstraint, c2: NSLayoutConstraint, c3: NSLayoutConstraint
        
        c1 = NSLayoutConstraint(item: contentView!, attribute: .leading, relatedBy: .equal, toItem: contentView!.superview, attribute: .leading, multiplier: 1, constant: 8)
        c2 = NSLayoutConstraint(item: contentView!, attribute: .top, relatedBy: .equal, toItem: contentLbl, attribute: .bottom, multiplier: 1, constant: 8)
        c3 = NSLayoutConstraint(item: contentView!, attribute: .trailing, relatedBy: .equal, toItem: contentView!.superview, attribute: .trailing, multiplier: 1, constant: 8)
        contentViewConstraintHeight = NSLayoutConstraint(item: contentView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
        contentView!.translatesAutoresizingMaskIntoConstraints = false
        scrollContainerView.addConstraints([c1,c2,c3,contentViewConstraintHeight!])
        //contentView!.uiDelegate = self
        //contentView!.navigationDelegate = self
    }
    
    override func refresh() {
        if product_token != nil {
            Global.instance.addSpinner(superView: view)
            //print(Member.instance.token)
            let params: [String: String] = ["token": product_token!, "member_token": Member.instance.token]
            ProductService.instance.getOne(t: SuperProduct.self, params: params) { (success) in
                if (success) {
                    let superModel: SuperModel = ProductService.instance.superModel
                    self.superProduct = (superModel as! SuperProduct)
                    
                    if self.superProduct != nil {
                        self.setMainData()
                        self.setFeatured()
                        
                        self.tableView.reloadData()
                    }
                }
                Global.instance.removeSpinner(superView: self.view)
                self.endRefresh()
            }
        }
    }
    
    func setFeatured() {
        
        if superProduct != nil {
            if superProduct!.featured_path.count > 0 {
                let featured_path = superProduct!.featured_path
                if featured_path.count > 0 {
                    //print(featured_path)
                    featured.downloaded(from: featured_path)
                }
            }
            //featured.image = superCourse!.featured
        }
    }
    
    func setMainData() {
        if superProduct != nil {
            for key in tableRowKeys {
                if (superProduct!.responds(to: Selector(key))) {
                    let content: String = String(describing:(superProduct!.value(forKey: key))!)
                    tableRows[key]!["content"] = content
                }
            }
            
//            if !superProduct!.open_time.isEmpty {
//                let business_time = superProduct!.open_time_text + " ~ " + superProduct!.close_time_text
//                tableRows["business_time"]!["content"] = business_time
//            } else {
//                tableRows.removeValue(forKey: "business_time");
//                tableRowKeys = tableRowKeys.filter{$0 != "business_time"}
//            }
            
//            let content: String = "<html><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\">"+self.body_css+"</HEAD><body>"+self.superStore!.content+"</body></html>"
//
//            contentView!.loadHTMLString(content, baseURL: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableRowKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableView {
            let cell: OneLineCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OneLineCell
            
            let key = tableRowKeys[indexPath.row]
            if tableRows[key] != nil {
                let row = tableRows[key]!
                let icon = row["icon"] ?? ""
                let title = row["title"] ?? ""
                var content = row["content"] ?? ""
                if key == "fb" && !content.isEmpty {
                    content = "連結請按此"
                }
                if key == "website" && !content.isEmpty {
                    content = "連結請按此"
                }
                cell.update(icon: icon, title: title, content: content)
                    //print("\(key):\(cell.frame.height)")
            }
            
            if indexPath.row == tableRowKeys.count - 1 {
                UIView.animate(withDuration: 0, animations: {self.tableView.layoutIfNeeded()}) { (complete) in
                    var heightOfTableView: CGFloat = 0.0
                    let cells = self.tableView.visibleCells
                    for cell in cells {
                        heightOfTableView += cell.frame.height
                    }
                    //print(heightOfTableView)
                    self.tableViewConstraintHeight.constant = heightOfTableView
                    self.changeScrollViewContentSize()
                }
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    func changeScrollViewContentSize() {
        
        let h1 = featured.bounds.size.height
        let h2 = productDataLbl.bounds.size.height
        let h3 = tableViewConstraintHeight.constant
        let h6 = contentLbl.bounds.size.height
        //let h7 = contentViewConstraintHeight!.constant

        //print(contentViewConstraintHeight)
        
        let h: CGFloat = h1 + h2 + h3 + h6 + 300
        scrollView.contentSize = CGSize(width: view.frame.width, height: h)
        ContainerViewConstraintHeight.constant = h
        //print(h1)
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
//        if delegate != nil {
//            delegate!.isReload(false)
//        }
        prev()
    }
}
