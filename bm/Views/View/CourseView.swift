//
//  CourseView.swift
//  bm
//
//  Created by ives on 2019/11/20.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

class CourseView: UIView {

    @IBOutlet weak var startTimeTxt: UILabel!
    @IBOutlet weak var endTimeTxt: UILabel!
    @IBOutlet weak var priceTxt: UILabel!
    @IBOutlet weak var cityTxt: UILabel!
    @IBOutlet weak var titleTxt: UILabel!
    @IBOutlet weak var peopleLimitTxt: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("CourseView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        //containerView.backgroundColor = UIColor.red
    }
    
    public func update(_ date: String, _ superCourse: SuperCourse, _ background_color: UIColor) {
        containerView.backgroundColor = background_color
        
        startTimeTxt.text = superCourse.start_time_text
        endTimeTxt.text = superCourse.end_time_text
        priceTxt.text = superCourse.price_text_short
        let citys = superCourse.coach.citys
        
        if (citys.count > 0) {
            let city = citys[0]
            let name: String? = city.name as String
            if name != nil {
                cityTxt.text = name!
            }
        }
        
        titleTxt.text = superCourse.title
        peopleLimitTxt.text = superCourse.people_limit_text
                
        let now = Global.instance.now()
        let deadline = String(format: "%@ %@", date, superCourse.deadline)
        //print("\(now)=>\(deadline)")
        if deadline.toDate(format: "yyyy-MM-dd HH:mm:ss") > now.toDate(format: "yyyy-MM-dd HH:mm:ss") { //還沒超過報名的期限，可以報名
            signupButton.tag = superCourse.id
        } else {
            //print(superCourse.id)
            signupButton.setTitle("無法報名", for: .normal)
            signupButton.backgroundColor = UIColor.gray
            signupButton.isEnabled = false
        }
    }
    
    @IBAction func signupPressed(_ sender: UIButton) {
        print(sender.tag)
    }
}
