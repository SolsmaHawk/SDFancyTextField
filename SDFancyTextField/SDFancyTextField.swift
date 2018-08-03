//
//  SDFancyTextField.swift
//  SDFancyTextField
//
//  Created by ZuluAlpha on 7/31/18.
//  Copyright © 2018 Solsma Dev Inc. All rights reserved.
//

import UIKit

@IBDesignable
class SDFancyTextField: UIView {
    
    private var imageHolderView: UIView = UIView()
    private var dividerView: UIView? = UIView()
    private var textFieldHolderView: UIView = UIView()
    var textField: UITextField = UITextField()
    
    private var borderColorDefaultValue: UIColor = UIColor.lightGray
    @IBInspectable var borderColor: UIColor {
        set {   self.borderColorDefaultValue = newValue
                self.dividerView?.backgroundColor = newValue
                self.backgroundColor = newValue
        } get { return self.backgroundColor ?? UIColor.lightGray
        }
    }
    
    private var iconImageColorMatchesBorderColorValue: Bool = false
    @IBInspectable var iconImageColorMatchesBorderColor: Bool {
        set {   self.iconImageColorMatchesBorderColorValue = newValue
            if newValue {
                self.iconImage = self.iconImage?.withRenderingMode(.alwaysTemplate)
                self.iconImageView.tintColor = self.borderColor
            }
        } get { return iconImageColorMatchesBorderColorValue
        }
    }
    
    @IBInspectable var isSecureEntry: Bool {
        set {   self.textField.isSecureTextEntry = newValue
        } get { return self.textField.isSecureTextEntry
        }
    }
    
    @IBInspectable var placeHolderText: String? {
        set {   self.textField.placeholder = newValue
        } get { return self.textField.placeholder
        }
    }
    
    private var cornerRadiusDefaultValue: CGFloat = 10.0
    @IBInspectable var cornerRadius: CGFloat {
        set {
            let acceptableRadius = self.frame.size.height / 2
            if newValue > acceptableRadius {
                self.cornerRadiusDefaultValue = acceptableRadius
                self.layer.cornerRadius = acceptableRadius
                self.textFieldHolderView.layer.cornerRadius = acceptableRadius - 2
            } else {
                self.cornerRadiusDefaultValue = newValue
                self.layer.cornerRadius = newValue
                self.textFieldHolderView.layer.cornerRadius = newValue - 2
            }
        } get { return self.layer.cornerRadius
        }
    }
    
    private var iconImageView: UIImageView = UIImageView()
    @IBInspectable var iconImage: UIImage? {
        set {   self.iconImageView.image = newValue}
        get { return self.iconImageView.image }
    }
    
    private var shadowColorDefaultValue: UIColor = UIColor.black
    @IBInspectable var shadowColor: UIColor {
        set {
            self.shadowColorDefaultValue = newValue
            self.layer.shadowColor = newValue.cgColor
            self.layer.shadowOpacity = 0.0
            self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
            self.layer.shadowRadius = 1}
        get {return UIColor(cgColor:self.layer.shadowColor!)}}
    
    private var fieldBackgroundColorDefaultValue: UIColor = UIColor.white
    @IBInspectable var fieldBackgroundColor: UIColor {
        set {
            fieldBackgroundColorDefaultValue = newValue
            self.textFieldHolderView.backgroundColor = newValue }
        get { return self.textFieldHolderView.backgroundColor ?? UIColor.white }}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(with frame: CGRect = CGRect.init(x: 0, y: 0, width: 0, height: 0), iconImage: UIImage? = nil, cornerRadius: CGFloat = 10, borderColor: UIColor = UIColor.lightGray, shadowColor: UIColor = UIColor.black, fieldBackgroundColor: UIColor = UIColor.white) {
        self.init(frame: frame)
        self.iconImage = iconImage
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.shadowColor = shadowColor
        self.fieldBackgroundColor = fieldBackgroundColor
        self.setup()
    }
    
    func setup() {
        self.setupMainView()
        self.setupTextFieldHolderView()
        self.setupTextField()
        self.addDividerView()
        self.setupImageHolderViewAndImage()
        self.setupActions()
    }
    
    func setupMainView() {
        self.backgroundColor = self.borderColorDefaultValue
        self.layer.cornerRadius = self.cornerRadiusDefaultValue
        self.layer.shadowColor = self.shadowColorDefaultValue.cgColor
        self.layer.shadowOpacity = 0.0
        self.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        self.layer.shadowRadius = 1
    }
    
    private func addDividerView() {
        self.dividerView!.backgroundColor = self.borderColorDefaultValue
        self.dividerView!.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldHolderView.addSubview(self.dividerView!)
        NSLayoutConstraint(item: self.dividerView!, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 2).isActive = true
        NSLayoutConstraint(item: self.dividerView!, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.textFieldHolderView, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: -10.0).isActive = true
        NSLayoutConstraint(item: self.dividerView!, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.textFieldHolderView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self.dividerView!, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.textFieldHolderView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 45.0).isActive = true
    }
    
    private func setupImageHolderViewAndImage() {
        self.imageHolderView.backgroundColor = UIColor.clear
        self.imageHolderView.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldHolderView.addSubview(self.imageHolderView)
        
        NSLayoutConstraint(item: self.imageHolderView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1.0, constant: 35).isActive = true
        NSLayoutConstraint(item: self.imageHolderView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.textFieldHolderView, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: -5.0).isActive = true
        NSLayoutConstraint(item: self.imageHolderView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.textFieldHolderView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self.imageHolderView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.textFieldHolderView, attribute: NSLayoutAttribute.leading, multiplier: 1.0, constant: 7.0).isActive = true
        
        self.iconImageView.contentMode = .scaleAspectFit
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageHolderView.addSubview(self.iconImageView)
        
        
        if self.iconImageColorMatchesBorderColor {
            self.iconImage = self.iconImage?.withRenderingMode(.alwaysTemplate)
            self.iconImageView.tintColor = self.borderColor
        }
 
        
        NSLayoutConstraint(item: self.iconImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: self.imageHolderView, attribute: NSLayoutAttribute.width, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self.iconImageView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: self.imageHolderView, attribute: NSLayoutAttribute.height, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self.iconImageView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.imageHolderView, attribute: NSLayoutAttribute.centerY, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: self.iconImageView, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: self.imageHolderView, attribute: NSLayoutAttribute.centerX, multiplier: 1.0, constant: 0.0).isActive = true
    }
    
    private func setupActions() {
        self.textField.addTarget(self, action: #selector(SDFancyTextField.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        self.textField.addTarget(self, action: #selector(SDFancyTextField.textFieldEditingDidBegin(_:)), for: UIControlEvents.editingDidBegin)
        self.textField.addTarget(self, action: #selector(SDFancyTextField.textFieldEditingDidEnd(_:)), for: UIControlEvents.editingDidEnd)
    }
    
    @objc private func textFieldEditingDidBegin(_ textField: UITextField) {
        self.imageHolderView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = self.layer.shadowOpacity
        animation.toValue = 0.5
        animation.duration = 0.2
        self.layer.add(animation, forKey: animation.keyPath)
        self.layer.shadowOpacity = 0.5
        
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        self.imageHolderView.transform = CGAffineTransform.identity},
                       completion: nil)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        self.dividerView!.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {self.dividerView!.transform = CGAffineTransform.identity},
                       completion:nil)
    }
    
    @objc private func textFieldEditingDidEnd(_ textField: UITextField) {
        self.textField.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = self.layer.shadowOpacity
        animation.toValue = 0.0
        animation.duration = 0.2
        self.layer.add(animation, forKey: animation.keyPath)
        self.layer.shadowOpacity = 0.0
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.20),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        self.textField.transform = CGAffineTransform.identity},
                       completion: nil)
    }
    
    private func setupTextFieldHolderView() {
        self.textFieldHolderView.backgroundColor = self.fieldBackgroundColorDefaultValue
        self.textFieldHolderView.layer.cornerRadius = self.cornerRadiusDefaultValue - 2
        self.textFieldHolderView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.textFieldHolderView)
        NSLayoutConstraint(item: self.textFieldHolderView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.leadingMargin, multiplier: 1.0, constant: -6.0).isActive = true
        NSLayoutConstraint(item: self.textFieldHolderView, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.trailingMargin, multiplier: 1.0, constant: 6.0).isActive = true
        NSLayoutConstraint(item: self.textFieldHolderView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.topMargin, multiplier: 1.0, constant: -6.0).isActive = true
        NSLayoutConstraint(item: self.textFieldHolderView, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1.0, constant: 6.0).isActive = true
    }
    
    private func setupTextField() {
        self.textField.backgroundColor = UIColor.clear
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldHolderView.addSubview(self.textField)
        
        NSLayoutConstraint(item: self.textField, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: textFieldHolderView, attribute: NSLayoutAttribute.leadingMargin, multiplier: 1.0, constant: 45).isActive = true
        NSLayoutConstraint(item: self.textField, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: textFieldHolderView, attribute: NSLayoutAttribute.trailingMargin, multiplier: 1.0, constant: -5).isActive = true
        NSLayoutConstraint(item: self.textField, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: textFieldHolderView, attribute: NSLayoutAttribute.topMargin, multiplier: 1.0, constant: -6.0).isActive = true
        NSLayoutConstraint(item: self.textField, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: textFieldHolderView, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1.0, constant: 6.0).isActive = true
    }
    
    override func awakeFromNib() {
        self.setup()
    }
    override func prepareForInterfaceBuilder() {
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
