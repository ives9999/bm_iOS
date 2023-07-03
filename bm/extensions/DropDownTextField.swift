//
//  DropDownTextField.swift
//  bm
//
//  Created by ives on 2023/6/29.
//  Copyright © 2023 bm. All rights reserved.
//

import UIKit

protocol DropDownTextFieldDelegate {
    func menuDidAnimate(up: Bool)
    func optionSelected(option: String)
}


class DropDownTextField: UIView {

    //public properties
    var boldColor = UIColor.black
    var lightColor = UIColor.white
    var dropDownColor = UIColor.gray
    var font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    
    var delegate: DropDownTextFieldDelegate?
    private var isDroppedDown = false
    
    //private properties
    private var options: [String]
    private var initialHeight: CGFloat = 0
    private let rowHeight: CGFloat = 40
    
    //UI properties
    var underline = UIView()
    
    let triangleIndicator: UIImageView = {
        let image = UIImage.Theme.triangle.image
        image.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let tapView: UIView = UIView()
    
    lazy var tableView: UITableView = {
        
        let tableView = UITableView()
        tableView.bounces = false
        tableView.backgroundColor = UIColor.clear
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorColor = lightColor
        
        return tableView
    }()
    
    let animationView = UIView()
    
//    class TextField: UITextField {
//
//        let padding = UIEdgeInsets(top: 12.0, left: 8.0, bottom: 12.0, right: 0)
//
//        override func textRect(forBounds bounds: CGRect) -> CGRect {
//            return UIEdgeInsetsInsetRect(bounds, padding)
//        }
//
//        override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//            return UIEdgeInsetsInsetRect(bounds, padding)
//        }
//
//        override func editingRect(forBounds bounds: CGRect) -> CGRect {
//            return UIEdgeInsetsInsetRect(bounds, padding)
//        }
//    }
    
    lazy var textField: SuperTextField = {
        
        let textField = SuperTextField(frame: .zero)
        //let textField = TextField(frame: .zero)
        //textField.textColor = UIColor.white
        textField.autocapitalizationType = .sentences
        textField.returnKeyType = .done
        //textField.keyboardType = .alphabet
        //textField.layer.borderColor = UIColor.gray.cgColor
        //textField.layer.borderWidth = 1.0
        
        return textField
    }()
    
    init(frame: CGRect, title: String, options: [String]) {
        self.options = options
        super.init(frame: frame)
        self.textField.text = title
        calculateHeight()
        setupViews()
        //self.backgroundColor = UIColor.gray
    }
    
    private override init(frame: CGRect) {
        
        options = []
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func animateMenu() {
        menuAnimate(up: isDroppedDown)
    }
    
    public func setOptions(_ newOptions: [String]) {
        self.options = newOptions
        //tableView.heightConstraint?.constant = 300
        //print(tableView.contentSize.height)
        tableView.visibility = UIView.Visibility.visible
        //let frame = tableView.frame
        //tableView.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: 300)
        //print(tableView.frame)
        self.tableView.reloadData()
        self.menuAnimate(up: false)
    }
    
    private func calculateHeight() {
        
        self.initialHeight = self.bounds.height
        let rowCount = self.options.count
        let newHeight = self.initialHeight + (CGFloat(rowCount) * rowHeight)
        self.frame.size = CGSize(width: self.frame.width, height: newHeight)
    }
    
    private func setupViews() {
        
        removeSubviews()
        //addUnderline()
        addTriangleIndicator()
        addTextField()
        //addTapView()
        addTableView()
        addAnimationView()
    }
    
    private func removeSubviews() {
        
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
    private func addUnderline() {
        
        addSubview(underline)
        underline.backgroundColor = UIColor.green
        
        underline.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            underline.topAnchor.constraint(equalTo: topAnchor, constant: initialHeight - 2),
            underline.leadingAnchor.constraint(equalTo: leadingAnchor),
            underline.trailingAnchor.constraint(equalTo: trailingAnchor),
            underline.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func addTriangleIndicator() {
        triangleIndicator.translatesAutoresizingMaskIntoConstraints = false
        triangleIndicator.tintColor = boldColor
        addSubview(triangleIndicator)
        let triSize: CGFloat = 12.0
        NSLayoutConstraint.activate([
            triangleIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            triangleIndicator.trailingAnchor.constraint(equalTo: trailingAnchor),
            triangleIndicator.heightAnchor.constraint(equalToConstant: triSize),
            triangleIndicator.widthAnchor.constraint(equalToConstant: triSize),
            //triangleIndicator.centerYAnchor.constraint(equalTo: topAnchor, constant: initialHeight / 2)
        ])
    }
    
    private func addTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            //textField.centerYAnchor.constraint(equalTo: topAnchor, constant: initialHeight / 2),
            textField.trailingAnchor.constraint(equalTo: triangleIndicator.leadingAnchor, constant: -8),
            textField.heightAnchor.constraint(equalToConstant: 40)
        ])
        textField.font = self.font
    }
    
    private func addTapView() {
        
        tapView.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animateMenu))
        tapView.addGestureRecognizer(tapGesture)
        tapView.backgroundColor = UIColor.red
        addSubview(tapView)
        //tapView.constraintsPinTo(leading: leadingAnchor, trailing: trailingAnchor, top: topAnchor, bottom: underline.bottomAnchor)
        tapView.constraintsPinTo(leading: leadingAnchor, trailing: trailingAnchor, top: underline.bottomAnchor, bottom: bottomAnchor)
    }
    
    private func addTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.green
        
        self.addSubview(tableView)
        //tableView.constraintsPinTo(leading: leadingAnchor, trailing: trailingAnchor, top: textField.bottomAnchor, bottom: bottomAnchor)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        tableView.isHidden = true
    }
    
    private func addAnimationView() {
        
        self.addSubview(animationView)
        animationView.frame = CGRect(x: 0.0, y: initialHeight, width: bounds.width, height: bounds.height - initialHeight)
        //animationView.frame = CGRect(x: 0.0, y: initialHeight, width: bounds.width, height: 0)
        self.sendSubviewToBack(animationView)
        //animationView.backgroundColor = dropDownColor
        animationView.backgroundColor = UIColor.red
        animationView.isHidden = true
    }
    
    private func menuAnimate(up: Bool) {
        
        let downFrame = animationView.frame
        let upFrame = CGRect(x: 0, y: self.initialHeight, width: self.bounds.width, height: 0)
        animationView.frame = up ? downFrame : upFrame
        animationView.isHidden = false
        tableView.isHidden = true
        
        UIView.animate(withDuration: 5, delay: 0.0, options: .curveEaseInOut, animations: {
            self.animationView.frame = up ? upFrame : downFrame
        }, completion: { (Bool) in
            self.isDroppedDown = !self.isDroppedDown
            self.animationView.isHidden = up
            self.animationView.frame = downFrame
            self.tableView.isHidden = up
            self.delegate?.menuDidAnimate(up: up)
        })
    }
}

extension DropDownTextField: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(options.count)
        return options.count
        //return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "option") as? DropDownCell ?? DropDownCell()
        cell.lightColor = self.lightColor
        cell.cellFont = font
        let title = indexPath.row < options.count ? options[indexPath.row] : "Other"
        cell.configreCell(with: title)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return tableView.frame.height / CGFloat(options.count)
        return 40
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == options.count {
            //otherChosen()
        } else {
            let chosen = options[indexPath.row]
            textField.text = chosen
            self.delegate?.optionSelected(option: chosen)
            animateMenu()
        }
    }
}

class DropDownCell: UITableViewCell {
    var lightColor = UIColor.lightGray
    var cellFont: UIFont = UIFont.systemFont(ofSize: 18, weight: .semibold)
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configreCell(with title: String) {
        
        self.selectionStyle = .none
        self.textLabel?.font = cellFont
        self.textLabel?.textColor = self.lightColor
        self.backgroundColor = UIColor.clear
        self.textLabel?.text = title
    }
}
