//
//  DateSelectVC.swift
//  bm
//
//  Created by ives on 2019/1/17.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

protocol DateSelectDelegate: class {
    //func setDateData(res: String, type: SELECT_DATE_TYPE, indexPath: IndexPath?)
    func dateSelected(key: String, selected: String)
}

class DateSelectVC: BaseViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var datePicker: SuperDatePicker!
    @IBOutlet weak var submitBtn: SubmitButton!
    
    var delegate: DateSelectDelegate?
    
    //input["type":START,"date":date]
    //var type: SELECT_DATE_TYPE = SELECT_DATE_TYPE.start
    var selected: String = "2000-01-01"
    var key: String? = nil
    
    //var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !selected.isDate {
            selected = Global.instance.today()
        }
        //datePicker.backgroundColor = UIColor.white
        //datePicker.setValue(UIColor.red, forKey: "textColor")
        datePicker.date = selected.toDateTime(format: "yyyy-MM-dd")
    }
    
    @IBAction func submit(_ sender: Any) {
        selected = datePicker.date.toString(format: "yyyy-MM-dd")
        //print(selected)
        //self.delegate?.setDateData(res: selected, type: type, indexPath: indexPath)
        if key != nil {
            self.delegate?.dateSelected(key: key!, selected: selected)
        }
        back()
    }
    
    @objc func back() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }

}
