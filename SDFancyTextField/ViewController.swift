//
//  ViewController.swift
//  SDFancyTextField
//
//  Created by ZuluAlpha on 7/31/18.
//  Copyright © 2018 Solsma Dev Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var userNameFancyTextField: SDFancyTextField!
    @IBOutlet var passwordFancyTextField: SDFancyTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        userNameFancyTextField.validationGroups = [SDFancyTextField.ValidationGroup.init(name:"test")]
        passwordFancyTextField.validationGroups = [SDFancyTextField.ValidationGroup.init(name:"new"),SDFancyTextField.ValidationGroup.init(name:"test"),SDFancyTextField.ValidationGroup.init(name:"test2")]
        
        SDFancyTextField.addValidationFor(group: SDFancyTextField.ValidationGroup.init(name:"test"), with: {textFieldText in
            if textFieldText.contains("t") {
                return (true,nil)
            }
            return(false,"The field does not contain the letter 't'")
        })
        
        SDFancyTextField.addValidationFor(group: SDFancyTextField.ValidationGroup.init(name:"test2"), with: {textFieldText in
            if textFieldText.contains("h") {
                return (true,nil)
            }
            return(false,"The field does not contain the letter 'h'")
        })
        
        SDFancyTextField.addValidationFor(group: SDFancyTextField.ValidationGroup.init(name:"new"), with: {textFieldText in
            if textFieldText.contains("new") {
                return (true,nil)
            }
            return(false,"The field does not contain the letters 'new'")
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

