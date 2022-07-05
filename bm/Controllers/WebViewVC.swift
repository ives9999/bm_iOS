//
//  WebViewVC.swift
//  bm
//
//  Created by ives on 2022/7/3.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation
import WebKit

class WebViewVC: BaseViewController {
    
    @IBOutlet weak var top: Top!
    @IBOutlet weak var dataContainer: UIView!
    @IBOutlet weak var webView: WKWebView!
    
    var token: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        top.setTitle(title: "web view")
        top.delegate = self
        
        if (token != nil) {
            let params: [String: String] = ["token": token!, "member_token": Member.instance.token]
            Global.instance.addSpinner(superView: view)
            OrderService.instance.getOne(params: params, completion: { success in
                if (success) {
                    
                    let jsonData: Data = OrderService.instance.jsonData!
                    do {
                        let orderTable: OrderTable = try JSONDecoder().decode(OrderTable.self, from: jsonData)
                        self.showWebView(table: orderTable)
                    } catch {
                        self.warning(error.localizedDescription)
                    }
                }
                Global.instance.removeSpinner(superView: self.view)
            })
        }
        
    }
    
    func showWebView(table: Table) {
        
        let orderTable: OrderTable = table as! OrderTable
        var url: String = "http://bm.sportpassword.localhost/app/order/ecpay2_c2c_map?"
        url += "LogisticsType=CVS"
        if orderTable.gateway != nil {
            let gatewayEnum: GATEWAY = GATEWAY.stringToEnum(orderTable.gateway!.method)
            url += "&LogisticsSubType=" + gatewayEnum.enumToECPay()
            url += "&IsCollection=Y&Device=1"
            url += "&order_token=" + token!
        }
        
        //print(url)
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        webView.load(request)
    }
}
