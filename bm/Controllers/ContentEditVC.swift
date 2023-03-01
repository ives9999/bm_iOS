//
//  ContentEditVC.swift
//  bm
//
//  Created by ives on 2019/6/9.
//  Copyright © 2019 bm. All rights reserved.
//

import UIKit

//protocol ContentEditDelegate: class {
//    func setContent(key: String, content: String)
//}

class ContentEditVC: BaseViewController {
    
    //@IBOutlet weak var titleLbl: UILabel!
    //@IBOutlet weak var contentTextView: UITextView!
    //@IBOutlet weak var height: NSLayoutConstraint!
    //@IBOutlet weak var scrollView: SuperScrollView!
    //@IBOutlet weak var clearBtn: ClearButton!
    
    var key: String? = nil
    var content: String? = nil
    var delegate: BaseViewController? = nil
    var type: TEXT_INPUT_TYPE = TEXT_INPUT_TYPE.content
    var textViewHeight: CGFloat = 0
    
    var showTop2: ShowTop2?
    var showBottom2: ShowBottom2?
    
    let contentTextView: SuperTextView = {
        let view = SuperTextView()
//        view.layer.borderColor = UIColor.lightGray.cgColor
//        view.layer.borderWidth = 1.0
//        
//        view.contentInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        
        return view
    }()
    
    let clearBtn: ClearButton = ClearButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        showTop2 = ShowTop2(delegate: self)
        showTop2!.setTitle(title: title ?? "內容編輯")
        
        showBottom2 = ShowBottom2(delegate: self)
        
//        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
//        contentTextView.layer.borderWidth = 1.0
//
//        contentTextView.contentInset = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        
        if content != nil {
            contentTextView.text = content
        }
        
        addDoneButtonOnKeyboard()
        hideKeyboardWhenTappedAround()
        
        anchor()
        
        clearBtn.addTarget(self, action: #selector(clear1), for: .touchUpInside)
    }
    
    func anchor() {
        showTop2!.anchor(parent: self.view)
        
        self.view.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(showTop2!.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(500)
        }
        
        self.view.addSubview(clearBtn)
        clearBtn.snp.makeConstraints { make in
            make.top.equalTo(contentTextView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        self.view.addSubview(showBottom2!)
        showBottom2!.showButton(parent: self.view, isShowSubmit: true, isShowLike: false, isShowCancel: true)
    }
    
    override func submit() {
        if delegate != nil && key != nil {
            delegate!.setContent(key: key!, content: contentTextView.text)
        }
        prev()
    }
    
    @objc func clear1(btn: SuperButton) {
        contentTextView.text = ""
    }
    
    override func cancel() {
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
