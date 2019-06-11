//
//  ContentEditVC.swift
//  bm
//
//  Created by ives on 2019/6/9.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

protocol ContentEditDelegate: class {
    func setContent(key: String, content: String)
}

class ContentEditVC: BaseViewController {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var scrollView: SuperScrollView!
    @IBOutlet weak var clearBtn: ClearButton!
    
    var key: String? = nil
    var content: String? = nil
    var delegate: ContentEditDelegate? = nil
    var type: TEXT_INPUT_TYPE = TEXT_INPUT_TYPE.content
    var textViewHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        if title != nil {
            titleLbl.text = title
        }
        if content != nil {
            contentTextView.text = content
            textViewHeight = contentTextView.sizeThatFits(contentTextView.bounds.size).height
            //height.constant = a.height
            //scrollView.contentSize.height = a.height + 500
        }
        addDoneButtonOnKeyboard()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillLayoutSubviews() {
        height.constant = textViewHeight
        scrollView.contentSize = CGSize(width: view.frame.width, height: textViewHeight + 100)
    }
    
    @IBAction func submit(_ sender: Any) {
        if delegate != nil && key != nil {
            delegate!.setContent(key: key!, content: contentTextView.text)
        }
        prev()
    }
    
    @IBAction func clear(_ sender: Any) {
        contentTextView.text = ""
    }
    
    @IBAction func cancel(_ sender: Any) {
        prev()
    }
    
    @IBAction func prevBtnPressed(_ sender: Any) {
        prev()
    }
    
    func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        contentTextView.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        contentTextView.resignFirstResponder()
    }
}
