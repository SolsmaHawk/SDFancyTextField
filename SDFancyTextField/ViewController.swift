//
//  ViewController.swift
//  SDFancyTextField
//
//  Created by John Solsma on 7/31/18.
//  Copyright © 2018 Solsma Dev Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var userNameFancyTextField: SDFancyTextField!
    @IBOutlet var passwordFancyTextField: SDFancyTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        userNameFancyTextField.validationGroups = [SDFancyTextField.ValidationGroup.init(name:"email")]
        passwordFancyTextField.validationGroups = [SDFancyTextField.ValidationGroup.init(name:"passwordCheckForCapitalLetter"),SDFancyTextField.ValidationGroup.init(name:"passwordCheckForNumber"),SDFancyTextField.ValidationGroup.init(name:"passwordCheckForSymbol"),SDFancyTextField.ValidationGroup.init(name:"passwordLengthCheck")]
        
        SDFancyTextField.addValidationFor(group: SDFancyTextField.ValidationGroup.init(name:"email"), with: {textFieldText in
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if emailTest.evaluate(with: textFieldText) {
                return (true,nil)
            }
            return (false,"Not a valid email")
        })
        
        SDFancyTextField.addValidationFor(group: SDFancyTextField.ValidationGroup.init(name:"passwordCheckForCapitalLetter"), with: {textFieldText in
            let capitalLetterRegEx  = ".*[A-Z]+.*"
            let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
            guard texttest.evaluate(with: textFieldText) else { return (false, "Must contain a capital letter") }
            return (true, nil)
        })
        
        SDFancyTextField.addValidationFor(group: SDFancyTextField.ValidationGroup.init(name:"passwordCheckForNumber"), with: {textFieldText in
            let numberRegEx  = ".*[0-9]+.*"
            let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
            guard texttest1.evaluate(with: textFieldText) else { return (false, "Must contain a number")}
            return (true, nil)
        })
        
        SDFancyTextField.addValidationFor(group: SDFancyTextField.ValidationGroup.init(name:"passwordCheckForSymbol"), with: {textFieldText in
            let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
            let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
            guard texttest2.evaluate(with: textFieldText) else { return (false, "Must contain a special character") }
            return (true,nil)
        })
        
        SDFancyTextField.addValidationFor(group: SDFancyTextField.ValidationGroup.init(name:"passwordLengthCheck"), with: {textFieldText in
            if textFieldText.count >= 7 {
                return (true,nil)
            }
            return (false, "Must be at least 7 characters")
        })
        
    }
    
    @IBAction func validateTextFieldsButtonPressed(_ sender: Any) {
        let validationGroupTuple = SDFancyTextField.validate(group: SDFancyTextField.ValidationGroup.init(name: "test"))
        let validationGroupTuple2 = SDFancyTextField.validate(group:SDFancyTextField.ValidationGroup.init(name: "new"))
        if self.userNameFancyTextField.fieldIsValid {
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

