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
    var father: UIViewController?
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10);

    
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
        self.backgroundColor = UIColor.black
        self.textColor = UIColor.white
        self.font = UIFont(name: fontName, size: fontSize)
        self.createToolbar()
        self.borderWidth(1.0)
        self.borderColor(UIColor(TEXTBORDER))
        self.borderStyle = UITextBorderStyle.line
        self.align(.right)
        
        //self.font = UIFont(name: fontName, size: fontSize)
    }
    
    func placeholder(_ text: String) {
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView()
    }
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, padding)
    }
    func createToolbar() {
        let toolbar = UIToolbar()
        toolbar.barStyle = UIBarStyle.default
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.done, target: father, action: #selector(father?.dismissKeyboard))
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
