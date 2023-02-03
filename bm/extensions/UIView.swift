//
//  UIView.swift
//  bm
//
//  Created by ives on 2022/12/24.
//  Copyright © 2022 bm. All rights reserved.
//

import Foundation

extension UIView {
    
    enum Visibility {
        case visible
        case invisible
        case gone
    }
    
    func mask()-> UIView {
        
        let maskView: UIView = UIView()
        maskView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        maskView.backgroundColor = UIColor(hex: "#888888", alpha: 0.9)
        self.addSubview(maskView)
        
        return maskView
    }
    
    func unmask() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        self.removeFromSuperview()

    }
    
    func blackView(left: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat)-> UIView {
        let view: UIView = UIView()
        
//        let parent_width: CGFloat = self.frame.width
//        let parent_height: CGFloat = self.frame.height
//
//        let width: CGFloat =
        view.frame = CGRect(x: left, y: top, width: width, height: height)
        view.backgroundColor = UIColor(hex: "#000000", alpha: 0.9)
        self.addSubview(view)
        
        return view
    }
    
    func addBottomView(height: CGFloat = 50)-> UIView {
        let bottomView: UIView = UIView()
        bottomView.backgroundColor = UIColor.clear
        self.addSubview(bottomView)
        bottomView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        bottomView.backgroundColor = UIColor(SEARCH_BACKGROUND)
        
        return bottomView
    }
    
    func addStackView(height: CGFloat = 50)-> UIStackView {
        
        let bottomView: UIView = UIView()
        bottomView.backgroundColor = UIColor.clear
        self.addSubview(bottomView)
        
        let c1: NSLayoutConstraint = NSLayoutConstraint(item: bottomView, attribute: .leading, relatedBy: .equal, toItem: bottomView.superview, attribute: .leading, multiplier: 1, constant: 0)
        let c2: NSLayoutConstraint = NSLayoutConstraint(item: bottomView, attribute: .trailing, relatedBy: .equal, toItem: bottomView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        let c3: NSLayoutConstraint = NSLayoutConstraint(item: bottomView, attribute: .bottom, relatedBy: .equal, toItem: bottomView.superview, attribute: .bottom, multiplier: 1, constant: 0)
        let c4: NSLayoutConstraint = NSLayoutConstraint(item: bottomView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
        let c5: NSLayoutConstraint = NSLayoutConstraint(item: bottomView, attribute: .centerX, relatedBy: .equal, toItem: bottomView.superview, attribute: .centerX, multiplier: 1, constant: 0)
//        let c6: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: view.superview, attribute: .centerY, multiplier: 1, constant: 0)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = UIColor(SEARCH_BACKGROUND)
        self.addConstraints([c1, c2, c3, c4, c5])
        
        let view: UIStackView = UIStackView()
        bottomView.addSubview(view)
        //view.backgroundColor = UIColor.green
//        let c6: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: view.superview, attribute: .centerX, multiplier: 1, constant: 0)
//        let c7: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: .centerY, relatedBy: .equal, toItem: view.superview, attribute: .centerY, multiplier: 1, constant: 0)
//        let c8: NSLayoutConstraint = NSLayoutConstraint(item: view1, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
//        let c9: NSLayoutConstraint = NSLayoutConstraint(item: view1, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 59)
//
        view.translatesAutoresizingMaskIntoConstraints = false
        //bottomView.addConstraints([c6])
        
        view.centerXAnchor.constraint(equalTo: view.superview!.centerXAnchor).isActive = true
        view.topAnchor.constraint(equalTo: view.superview!.topAnchor, constant: 16).isActive = true
        
        view.axis = .vertical
        view.alignment = .center
        view.distribution = .equalCentering
        view.spacing = 20
        
        return view
    }
    
    func addCancelBtn()-> CancelButton {
        
        let view: CancelButton = CancelButton()
        self.addSubview(view)
        
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        //view.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        //self.addArrangedSubview(view)
        
        //let c1: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 110)
        //let c2: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: .centerX, relatedBy: .equal, toItem: view.superview, attribute: .centerX, multiplier: 1, constant: 110)
        //view.translatesAutoresizingMaskIntoConstraints = false
        //self.addConstraints([c1])
        
        return view
    }
    
    func addSubmitBtn()-> SubmitButton {
        
        //let view: SubmitButton = SubmitButton()
        let view: SubmitButton = SubmitButton()
        self.addSubview(view)
        
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
        //view.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        view.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        view.translatesAutoresizingMaskIntoConstraints = false
        //self.addArrangedSubview(view)
        
        //let c1: NSLayoutConstraint = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 110)
        //view.translatesAutoresizingMaskIntoConstraints = false
        //self.addConstraints([c1])
        
        return view
    }
    
    func tempPlayShowTableConstraint(_ items:[[String: UILabel]]) -> [NSLayoutConstraint] {
        var constraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
        var views: [String: UILabel] = [String: UILabel]()
        for item in items {
            for (key, value) in item {
                views[key] = value
            }
        }
        if  items.count > 0 {
            let item: [String: UILabel] = items[0]
            var pattern: String = ""
            for (key, value) in item {
                pattern = "H:|-30-[\(key)]"
                let c2: NSLayoutConstraint = NSLayoutConstraint(item: value, attribute: .centerY, relatedBy: .equal, toItem: value.superview, attribute: .centerY, multiplier:
                    1, constant: 0)
                constraints.append(c2)
                value.translatesAutoresizingMaskIntoConstraints = false
            }
            if pattern.count > 0 {
                let c1: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: pattern, options: .alignAllCenterY, metrics: nil, views: views)
                constraints += c1
            }
        }
        if items.count > 1 {
            let item: [String: UILabel] = items[1]
            var pattern: String = ""
            for (key, value) in item {
                pattern = "H:|[\(key)]-30-|"
                let c2: NSLayoutConstraint = NSLayoutConstraint(item: value, attribute: .centerY, relatedBy: .equal, toItem: value.superview, attribute: .centerY, multiplier:
                    1, constant: 0)
                constraints.append(c2)
                value.translatesAutoresizingMaskIntoConstraints = false
            }
            if pattern.count > 0 {
                let c1: [NSLayoutConstraint] = NSLayoutConstraint.constraints(withVisualFormat: pattern, options: .alignAllCenterY, metrics: nil, views: views)
                constraints += c1
            }
        }
        
        return constraints
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    var visibility: Visibility {
        get {
            let constraint = (self.constraints.filter{$0.firstAttribute == .height && $0.constant == 0}.first)
            if let constraint = constraint, constraint.isActive {
                return .gone
            } else {
                return self.isHidden ? .invisible : .visible
            }
        }
        set {
            if self.visibility != newValue {
                self.setVisibility(newValue)
            }
        }
    }
    
    private func setVisibility(_ visibility: Visibility) {
        let constraint = (self.constraints.filter{$0.firstAttribute == .height && $0.constant == 0}.first)
        
        switch visibility {
        case .visible:
            constraint?.isActive = false
            self.isHidden = false
            break
        case .invisible:
            constraint?.isActive = false
            self.isHidden = true
            break
        case .gone:
            if let constraint = constraint {
                constraint.isActive = true
            } else {
                let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
                self.addConstraint(constraint)
                constraint.isActive = true
            }
            self.layoutIfNeeded()
        }
    }
    
    var heightConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .height && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }

    var widthConstraint: NSLayoutConstraint? {
        get {
            return constraints.first(where: {
                $0.firstAttribute == .width && $0.relation == .equal
            })
        }
        set { setNeedsLayout() }
    }
    
    func constraintsPinTo(leading: NSLayoutXAxisAnchor, trailing: NSLayoutXAxisAnchor, top: NSLayoutYAxisAnchor, bottom: NSLayoutYAxisAnchor) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([self.leadingAnchor.constraint(equalTo: leading),
                                     self.trailingAnchor.constraint(equalTo: trailing),
                                     self.topAnchor.constraint(equalTo: top),
                                     self.bottomAnchor.constraint(equalTo: bottom)])
    }
    
    func showImages(images: [String])-> CGFloat {
        
        var totalHeight: CGFloat = 0
        var upView: UIView = self
        for (idx, image_url) in images.enumerated() {
            let imageView: UIImageView = UIImageView()
            imageView.downloaded(from: image_url)
            self.addSubview(imageView)
            
            let image_h: CGFloat = imageView.heightForUrl(url: image_url, width: self.frame.width)
            var upViewAttribute: NSLayoutConstraint.Attribute = .top
            var upConstant: CGFloat = 8
            if idx > 0 {
                upViewAttribute = .bottom
            } else {
                upConstant = 0
            }
            _setImageConstraint(imageView: imageView, image_h: image_h, upView: upView, upViewAttribute: upViewAttribute, upConstant: upConstant)
            totalHeight = totalHeight + image_h + 8
            upView = imageView
        }
        
        return totalHeight
    }
    
    private func _setImageConstraint(
        imageView: UIImageView,
        image_h: CGFloat,
        upView: UIView,
        upViewAttribute: NSLayoutConstraint.Attribute,
        upConstant: CGFloat) {
        
        var left: NSLayoutConstraint, right: NSLayoutConstraint, top: NSLayoutConstraint, h: NSLayoutConstraint
        
        //左邊
        left = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: imageView.superview, attribute: .leading, multiplier: 1, constant: 0)
        //右邊
        right = NSLayoutConstraint(item: imageView, attribute: .trailing, relatedBy: .equal, toItem: imageView.superview, attribute: .trailing, multiplier: 1, constant: 0)
        
        //上面
        top = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: upView, attribute: upViewAttribute, multiplier: 1, constant: upConstant)
        
        //高度
        h = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: image_h)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraints([left, right, top, h])
    }
    
    func setInfo(info: String, topAnchor: UIView)-> SuperLabel {
        
        let label: SuperLabel = SuperLabel()
        label.text = info
        label.setTextGeneral()
        label.textAlignment = .center
        //label.backgroundColor = UIColor.red
        self.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.topAnchor.constraint(equalTo: topAnchor.bottomAnchor, constant: 100).isActive = true
        label.centerXAnchor.constraint(equalTo: label.superview!.centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: 200).isActive = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return label
    }
    
    //https://medium.com/thefloatingpoint/how-to-make-any-uiview-into-a-circle-a3aad48eac4a
    func circle() {
        self.layer.cornerRadius = self.layer.bounds.width / 2
        self.clipsToBounds = true
    }
}
