//
//  SuperTextField.swift
//  bm
//
//  Created by ives on 2017/11/12.
//  Copyright © 2017年 bm. All rights reserved.
//

import UIKit

@IBDesignable
class SuperTextField: UITextField {
    var fontName: String = FONT_NAME
    var fontSize: CGFloat = FONT_SIZE_TITLE
    //var fontSize: CGFloat = 12
    var father: UIViewController?
    let padding = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8);

    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    convenience init(_ viewController: UIViewController) {
        self.init()
        father = viewController
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        self.backgroundColor = UIColor(MY_BLACK)
        self.textColor = UIColor(MY_GREEN)
        self.font = UIFont(name: fontName, size: fontSize)
//        self.createToolbar()
        self.borderWidth(0)
        //self.borderColor(UIColor.white)
        //self.borderStyle = UITextField.BorderStyle.line
        self.layer.cornerRadius = 4
        self.align(.left)
        
        //self.font = UIFont(name: fontName, size: fontSize)
    }
    
    func placeholder(_ text: String) {
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor(PLACEHOLDER)])
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItem.Style.done, target: father, action: #selector(father?.dismissKeyboard))
        flexibleSpace.width = toolbar.frame.width - done.width
        toolbar.items = [flexibleSpace, done]
        self.inputAccessoryView = toolbar
    }
    
    func align(_ align: NSTextAlignment) {
        self.textAlignment = align
    }
    func borderWidth(_ width: CGFloat) {
        self.layer.borderWidth = width
    }
    func borderColor(_ color: UIColor) {
        self.layer.borderColor = color.cgColor
    }
    func borderCornerRadius(_ cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
    }
}
