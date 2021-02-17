//
//  PaymentVC.swift
//  bm
//
//  Created by ives on 2021/2/5.
//  Copyright © 2021 bm. All rights reserved.
//

import Foundation
import ECPayPaymentGatewayKit

class PaymentVC: BaseViewController {
    
    @IBOutlet weak var titleLbl: SuperLabel!
    
    var ecpay_token: String = ""
    var order_token: String = ""
    var tokenExpireDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLbl.textColor = UIColor.black
        
        let name: String = (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String)!
        
        if ecpay_token.count > 0 {
            //
            ECPayPaymentGatewayManager.sharedInstance().createPayment(
                token: ecpay_token,
                useResultPage: 1,
                appStoreName: name,
                language: "zh-TW") { (state) in
                if let creditPayment: CreatePaymentCallbackState = state as? CreatePaymentCallbackState {
                    if let order = creditPayment.OrderInfo {
                        print(order)
                    }
                    if let card = creditPayment.CardInfo {
                        print(card)
                    }
                }

                switch state.callbackStateStatus {
                case .Success:
                    print("Success")

                case .Fail:
                    print("Faile")

                case .Cancel:
                    print("Cancel")

                case .Unknown:
                    print("Unknown")
                }
            }
        }
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        //print("purchase")
        
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        prev()
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        //goHome()
        prev()
    }
}
