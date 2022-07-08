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
        
        //let configuration: WKWebViewConfiguration = WKWebViewConfiguration()
        //configuration.userContentController.add(self, name: "doStuffMessageHandler")
        let contentController = webView.configuration.userContentController
        contentController.add(self, name: "toggleMessageHandler")
        
//        let js = """
//            var _selector = document.querySelector('input[name=myCheckbox]');
//            _selector.addEventListener('change', function(event) {
//                var message = (_selector.checked) ? "Toggle Switch is on" : "Toggle Switch is off";
//                if (window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.toggleMessageHandler) {
//                    window.webkit.messageHandlers.toggleMessageHandler.postMessage({
//                        "key": message
//                    });
//                }
//            });
//        """
//
//        let script: WKUserScript = WKUserScript(source: js, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
//        contentController.addUserScript(script)
        
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
        
        let path1: String = "http://bm.sportpassword.localhost/c2c.html"
        var path: String = "http://bm.sportpassword.localhost/app/order/ecpay2_c2c_map?"
        path += "LogisticsType=CVS"
        if orderTable.gateway != nil {
            let gatewayEnum: GATEWAY = GATEWAY.stringToEnum(orderTable.gateway!.method)
            path += "&LogisticsSubType=" + gatewayEnum.enumToECPay()
            path += "&IsCollection=Y&Device=1"
            path += "&order_token=" + token!
            path += "&phone=iOS"
        }
        
        print(path)
        
        if let url: URL = URL(string: path) {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            webView.load(request)
        }
    }
}

extension WebViewVC: WKScriptMessageHandler {
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard let dict = message.body as? [String : AnyObject] else {
            return
        }

        print(dict)
        prev()
        
//        guard let message = dict["key"] else {
//            return
//        }
//
//        let script = "document.getElementById('value').innerText = \"\(message)\""
//
//        webView.evaluateJavaScript(script) { (result, error) in
//            if let result = result {
//                print("Label is updated with message: \(result)")
//            } else if let error = error {
//                print("An error occurred: \(error)")
//            }
//        }
    }
}
