//
//  SDFancyTextField.swift
//  SDFancyTextField
//
//  Created by John Solsma on 7/31/18.
//  Copyright © 2018 Solsma Dev Inc. All rights reserved.
//

import UIKit

@IBDesignable
class SDFancyTextField: UIView {
    
    // MARK: Form Validation
    typealias TextFieldValidationClosure = ((_ textFieldText: String) -> (success: Bool, errorMessage: String?))
    
    struct ValidationGroup {
        var name: String
    }
    
    struct ValidationResponse {
        var success: Bool {
            get {
                return (self.failedValidationGroups ?? []).isEmpty
            }
        }
        var fancyTextField: SDFancyTextField?
        var failedValidationGroups: [ValidationGroup]?
        var errorMessages: [String]?
    }
    
    enum QuickValidationType: String {
        case UppercaseLetter    = "QuickValidationType_uppercaseLetter"
        case SpecialCharacter   = "QuickValidationType_specialCharacter"
        case ContainsNumber     = "QuickValidationType_containsNumber"
        case CharacterLength    = "QuickValidationType_characterLength"
        case NotEmpty           = "QuickValidationType_notEmpty"
        case ValidEmail         = "QuickValidationType_validEmail"
    }
    
    static private var validationFormsHashTable = NSHashTable<SDFancyTextField>(options: .weakMemory)
    static private var validationGroupsHashTable = NSHashTable<SDFancyTextField>(options: .weakMemory)
    static private var groupValidationClosures: [String:[TextFieldValidationClosure]]?
    
    static private func validationClosuresFor(_ group:String) -> [TextFieldValidationClosure]? {
        if let possibleValidation = SDFancyTextField.groupValidationClosures?[group] {
            return possibleValidation
        }
        return nil
    }
    
    private class func addValidationFor(type: QuickValidationType) {
        switch type {
        case .UppercaseLetter:
            SDFancyTextField.addValidationFor(group:ValidationGroup.init(name: type.rawValue    ), with: {  textFieldText in
                let capitalLetterRegEx  = ".*[A-Z]+.*"
                let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
                guard texttest.evaluate(with: textFieldText) else { return (false, "Must contain a capital letter") }
                return (true,nil)
            })
        case .SpecialCharacter:
            SDFancyTextField.addValidationFor(group: ValidationGroup.init(name: type.rawValue), with: { textFieldText in
                let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
                let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
                guard texttest2.evaluate(with: textFieldText) else { return (false, "Must contain a special character") }
                return (true,nil)
            })
        case .ContainsNumber:
            SDFancyTextField.addValidationFor(group: ValidationGroup.init(name: type.rawValue), with: { textFieldText in
                let numberRegEx  = ".*[0-9]+.*"
                let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
                guard texttest1.evaluate(with: textFieldText) else { return (false, "Must contain a number")}
                return (true, nil)
            })
        case .NotEmpty:
            SDFancyTextField.addValidationFor(group: ValidationGroup.init(name: type.rawValue), with: { textFieldText in
                if textFieldText.isEmpty {
                    return (false, "Cannot be empty")
                }
                    return (true, nil)
            })
        case .ValidEmail:
            SDFancyTextField.addValidationFor(group: ValidationGroup.init(name: type.rawValue), with: { textFieldText in
                let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
                if emailTest.evaluate(with: textFieldText) {
                    return (true,nil)
                }
                return (false,"Not a valid email")
            })
        default:
            break
        }
    }
    
    class func addValidationFor(group:ValidationGroup, with validation: @escaping TextFieldValidationClosure) {
        if groupValidationClosures == nil {
            groupValidationClosures = [String:[TextFieldValidationClosure]]()
        }
        if (groupValidationClosures?[group.name] ?? []).isEmpty {
            groupValidationClosures![group.name] = [validation]
        } else {
            groupValidationClosures![group.name]?.append(validation)
        }
    }
    
    class func validate(form: String, withAnimation: Bool) -> Bool {
        var formIsValid = true
        for fancyTextField in SDFancyTextField.validationGroupsHashTable.allObjects {
            if fancyTextField.form == form {
                if !fancyTextField.fieldIsValid {
                    formIsValid = false
                    if withAnimation {
                        // animate textField with invalid animation
                        fancyTextField.animateFieldIsNotValidMessage(valid: false, textIsEmpty: false)
                        fancyTextField.isUserInteractionEnabled = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            fancyTextField.animateFieldIsNotValidMessage(valid: false, textIsEmpty: true)
                            fancyTextField.isUserInteractionEnabled = true
                        }
                    }
                }
            }
        }
        return formIsValid
    }
    
    class func validate(group: ValidationGroup) -> [ValidationResponse]? {
        var validationResponses: [ValidationResponse]?
        for fancyTextField in SDFancyTextField.validationGroupsHashTable.allObjects {
            var validationResponse = ValidationResponse()
            validationResponse.fancyTextField = fancyTextField
            for validationGroup in fancyTextField.validationGroupValues ?? [] {
                if validationGroup.name == group.name {
                    if let possibleValidationClosuresForGroup = SDFancyTextField.validationClosuresFor(validationGroup.name) {
                        for closure in possibleValidationClosuresForGroup {
                            let closureInfo = closure(fancyTextField.textField.text ?? "")
                            if !closureInfo.success {
                                if validationResponses == nil {
                                    validationResponses = [ValidationResponse]()
                                }
                                if validationResponse.failedValidationGroups == nil {
                                    validationResponse.failedValidationGroups = [ValidationGroup]()
                                }
                                if validationResponse.errorMessages == nil {
                                    validationResponse.errorMessages = [String]()
                                }
                                if let possibleErrorMessage = closureInfo.errorMessage {
                                    validationResponse.errorMessages!.append(possibleErrorMessage)
                                }
                                validationResponse.failedValidationGroups!.append(validationGroup)
                            }
                        }
                    }
                }
            }
            if validationResponses != nil {
                validationResponses!.append(validationResponse)
            }
        }
        return validationResponses
    }
    
    private var validationGroupValues: [ValidationGroup]?
    var validationGroups: [ValidationGroup]? {
        set {
            if let possibleValue = newValue {
                validationGroupValues = possibleValue
                if !SDFancyTextField.validationGroupsHashTable.contains(self) {
                    SDFancyTextField.validationGroupsHashTable.add(self)
                }
            }
        } get { return validationGroupValues }
    }
    
    private var messageTopConstraint: NSLayoutConstraint?
    private var textFieldBottomConstraint: NSLayoutConstraint?
    private var imageHolderView: UIView = UIView()
    private var dividerView: UIView? = UIView()
    private var textFieldHolderView: UIView = UIView()
    var textField: UITextField = UITextField()
    private var messageLabel = UILabel()
    private var originalBorderColor: UIColor?
    private var borderColorDefaultValue: UIColor = UIColor.lightGray
    @IBInspectable var allowAutoValidation: Bool = false
    @IBInspectable var borderColor: UIColor {
        set {   self.borderColorDefaultValue = newValue
                self.dividerView?.backgroundColor = newValue
                self.backgroundColor = newValue
        } get { return self.backgroundColor ?? UIColor.lightGray
        }
    }
    
    private var quickValidationTypeValues: [QuickValidationType]?
    var quickValidationTypes: [QuickValidationType]? {
        set {   if let possibleValidationTypes = newValue {
            self.quickValidationTypeValues = possibleValidationTypes
            for validationType in possibleValidationTypes {
                if self.validationGroupValues == nil {
                    self.validationGroupValues = [ValidationGroup]()
                    self.validationGroupValues?.append(ValidationGroup.init(name: validationType.rawValue))
                } else {
                    self.validationGroupValues?.append(ValidationGroup.init(name: validationType.rawValue))
                }
                SDFancyTextField.addValidationFor(type: validationType)
            }
            if !SDFancyTextField.validationGroupsHashTable.contains(self) {
                SDFancyTextField.validationGroupsHashTable.add(self)
            }
            }
        } get { return self.quickValidationTypeValues
        }
    }
    
    private var formValue: String?
    @IBInspectable var form: String? {
        set {   self.formValue = newValue
            SDFancyTextField.validationFormsHashTable.add(self)
        } get { return self.formValue
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
    
    @IBInspectable var selectedColor: UIColor?
    
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
    
    var fieldValidationClosure: TextFieldValidationClosure?
    
    var fieldIsValid: Bool {
        func groupValidationsAreCorrect() -> Bool {
            for group in self.validationGroupValues ?? [] {
                let validationResponses = SDFancyTextField.validate(group: group)
                for validationResponse in validationResponses ?? [] {
                    if !validationResponse.success && self === validationResponse.fancyTextField {
                        self.fieldValidationErrors = validationResponse.errorMessages
                        return false
                    }
                }
            }
            return true
        }
        if let possibleFieldValidationClosure = self.fieldValidationClosure {
            if !possibleFieldValidationClosure(self.textField.text ?? "").success {
                return false
            }
            return groupValidationsAreCorrect()
        }
        return groupValidationsAreCorrect()
    }
    
    var fieldValidationErrors: [String]?
    

    
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
    
    
    // MARK: Fancy Text Field Setup
    func setup() {
        self.setupMainView()
        self.setupTextFieldHolderView()
        self.setupTextField()
        self.addDividerView()
        self.setupImageHolderViewAndImage()
        self.setupMessageLabel()
        self.setupActions()
    }
    
    private func setupMainView() {
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
    
    // MARK: Text Field Actions
    
    @objc private func textFieldEditingDidBegin(_ textField: UITextField) {
        self.imageHolderView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = self.layer.shadowOpacity
        animation.toValue = 0.5
        animation.duration = 0.2
        self.layer.add(animation, forKey: animation.keyPath)
        self.layer.shadowOpacity = 0.5
        
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.30),
                       initialSpringVelocity: CGFloat(3.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        /*
                        if let possibleSelectedColor = self.selectedColor {
                            self.originalBorderColor = self.borderColor
                            self.borderColor = possibleSelectedColor
                        }
 */
                        self.imageHolderView.transform = CGAffineTransform.identity},
                       completion: nil)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.0),
                       initialSpringVelocity: CGFloat(0.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        if !self.fieldIsValid && !(self.textField.text ?? "").isEmpty && self.allowAutoValidation {
                            self.borderColor = UIColor.red
                        } else {
                            if let possibleSelectedColor = self.selectedColor {
                                self.originalBorderColor = self.borderColor
                                self.borderColor = possibleSelectedColor
                            }
                        }},
                       completion: nil)
    }
    
    private func allFieldValidationErrorMessages() -> [String]? {
        var fieldValidationErrors: [String]?
        if let possibleGroupValidationErrors = self.fieldValidationErrors {
            fieldValidationErrors = [String]()
            fieldValidationErrors?.append(contentsOf: possibleGroupValidationErrors)
        }
        if let possibleFieldValidationClosure = self.fieldValidationClosure {
            if let possibleSingularValidationError = possibleFieldValidationClosure(self.textField.text ?? "").errorMessage {
                if fieldValidationErrors == nil {
                    fieldValidationErrors = [String]()
                }
                fieldValidationErrors?.append(possibleSingularValidationError)
            }
        }
        return fieldValidationErrors
    }
    
    private func queuedValidationErrorMessage() -> String? {
        if let possibleErrorMessage = self.allFieldValidationErrorMessages()?[0] {
            return possibleErrorMessage
        }
        return nil
    }
    
    private func animateFieldIsNotValidMessage(valid: Bool, textIsEmpty: Bool) {
        if textIsEmpty {
            self.showMessage(false)
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.0),
                           initialSpringVelocity: CGFloat(0.0),
                           options: UIViewAnimationOptions.allowUserInteraction,
                           animations: {
                            if let originalBorderColor = self.originalBorderColor {
                               self.borderColor = originalBorderColor
                            }
                            },
                           completion: nil)
        } else {
            self.showMessage(!valid)
            if !valid {
                self.messageLabel.text = self.queuedValidationErrorMessage() ?? "Input invalid"
                /*
                if let possibleGroupValidationError = self.fieldValidationErrors?[0] {
                    self.messageLabel.text = possibleGroupValidationError
                } else {
                    if let possibleFieldValidationClosure = self.fieldValidationClosure {
                        self.messageLabel.text = possibleFieldValidationClosure(self.textField.text ?? "").errorMessage ?? "Invalid input"
                    }
                }
                 */
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: CGFloat(0.0),
                               initialSpringVelocity: CGFloat(0.0),
                               options: UIViewAnimationOptions.allowUserInteraction,
                               animations: {
                                self.borderColor = UIColor.red },
                               completion: nil)
            } else {
                UIView.animate(withDuration: 0.5,
                               delay: 0,
                               usingSpringWithDamping: CGFloat(0.0),
                               initialSpringVelocity: CGFloat(0.0),
                               options: UIViewAnimationOptions.allowUserInteraction,
                               animations: {
                                self.borderColor = self.originalBorderColor!},
                               completion: nil)
            }
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if allowAutoValidation {
            animateFieldIsNotValidMessage(valid: self.fieldIsValid, textIsEmpty: (textField.text ?? "").isEmpty)
        }
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
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.30),
                       initialSpringVelocity: CGFloat(2.0),
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        /*
                        if let possibleOriginalColor = self.originalBorderColor {
                            self.borderColor = possibleOriginalColor
                        }
                        */
                        self.textField.transform = CGAffineTransform.identity},
                       completion: nil)

            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: CGFloat(0.00),
                           initialSpringVelocity: CGFloat(0.0),
                           options: UIViewAnimationOptions.allowUserInteraction,
                           animations: {
                            if !self.fieldIsValid && !(self.textField.text ?? "").isEmpty && self.allowAutoValidation {
                                self.borderColor = UIColor.red
                            } else {
                                if let possibleOriginalColor = self.originalBorderColor {
                                    self.borderColor = possibleOriginalColor
                                }
                            }},completion: nil)
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
    
    private func setupMessageLabel() {
        self.messageLabel.backgroundColor = UIColor.clear
        self.messageLabel.text = "Must contain one number, capital letter and symbol"
        self.messageLabel.font = self.messageLabel.font.withSize(14)
        self.messageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.messageLabel.textColor = self.borderColor
        self.messageLabel.alpha = 0.0
        self.textFieldHolderView.addSubview(self.messageLabel)
        
        NSLayoutConstraint(item: self.messageLabel, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: textFieldHolderView, attribute: NSLayoutAttribute.leadingMargin, multiplier: 1.0, constant: 45).isActive = true
        NSLayoutConstraint(item: self.messageLabel, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: textFieldHolderView, attribute: NSLayoutAttribute.trailingMargin, multiplier: 1.0, constant: -5).isActive = true
       self.messageTopConstraint = NSLayoutConstraint(item: self.messageLabel, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: textFieldHolderView, attribute: NSLayoutAttribute.topMargin, multiplier: 1.0, constant: -30.0)
        self.messageTopConstraint!.isActive = true
        NSLayoutConstraint(item: self.messageLabel, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: textFieldHolderView, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1.0, constant: 6.0).isActive = true
    }
    
    private func setupTextField() {
        self.textField.backgroundColor = UIColor.clear
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textFieldHolderView.addSubview(self.textField)
        
        NSLayoutConstraint(item: self.textField, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: textFieldHolderView, attribute: NSLayoutAttribute.leadingMargin, multiplier: 1.0, constant: 45).isActive = true
        NSLayoutConstraint(item: self.textField, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: textFieldHolderView, attribute: NSLayoutAttribute.trailingMargin, multiplier: 1.0, constant: -5).isActive = true
        self.textFieldBottomConstraint = NSLayoutConstraint(item: self.textField, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: textFieldHolderView, attribute: NSLayoutAttribute.topMargin, multiplier: 1.0, constant: -6.0)
        self.textFieldBottomConstraint!.isActive = true
        NSLayoutConstraint(item: self.textField, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: textFieldHolderView, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1.0, constant: 6.0).isActive = true
    }
    
    func showMessage(_ show: Bool) {
        if show {
            self.textFieldBottomConstraint?.constant = 7.0
            self.messageTopConstraint?.constant = -21.0
        } else {
            self.textFieldBottomConstraint?.constant = -6.0
            self.messageTopConstraint?.constant = -30.0
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.layoutIfNeeded()
            if show {
                self.messageLabel.alpha = 1.0
            } else {
                self.messageLabel.alpha = 0.0
            }
        })
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
