//
//  SDFancyTextFieldDemoTableViewController.swift
//  SDFancyTextField
//
//  Created by ZuluAlpha on 8/26/18.
//  Copyright © 2018 Solsma Dev Inc. All rights reserved.
//

import UIKit

class SDFancyTextFieldDemoTableViewController: UITableViewController {

    @IBOutlet var form3Field1: SDFancyTextField!
    @IBOutlet var form3Field2: SDFancyTextField!
    @IBOutlet var cityField: SDFancyTextField!
    @IBOutlet var apartmentField: SDFancyTextField!
    @IBOutlet var addressField: SDFancyTextField!
    @IBOutlet var phoneNumberField: SDFancyTextField!
    @IBOutlet var retypePasswordField: SDFancyTextField!
    @IBOutlet var everythingField: SDFancyTextField!
    @IBOutlet var validEmailField: SDFancyTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Most properties can be set during initialization or in Interface Builder
        
        // Set email field to allow auto validation *can also be set in IB*
        self.validEmailField.allowAutoValidation = true
        // Set quick validation type(s) for email field
        self.validEmailField.quickValidationTypes = [.ValidEmail, .NotEmpty]
        
        // Do the same for the first password field
        self.everythingField.allowAutoValidation = true
        // You can set multiple quick validation types to a field
        self.everythingField.quickValidationTypes = [.ContainsNumber, .SpecialCharacter, .UppercaseLetter, .NotEmpty]
        self.retypePasswordField.allowAutoValidation = true
        
        /* Using a field validation closure you can set a completely custom validation type. This field validation closure checks the field to see if contains the character sequence 'test' and also that it has a length of 7 or greater. Field validation closures return a tuple of (Bool, String). The Bool indicates the success of the validation closure and the String is the message displayed within the text field */
        self.everythingField.fieldValidationClosure = {textFieldText in
            if (textFieldText.lowercased().contains("test") && textFieldText.count >= 7) {
                return (true, nil)
            }
            if !textFieldText.lowercased().contains("test") {
                return (false, "Must contain the word 'test'")
            }
            return (false, "Length must be 7 or greater")
        }
        
        /* A common text form scenario is retyping a password and making sure it matches a previous password field. In the field validation closure below you can see how a second field can be made to match another text field's text. If either text field is changed this text field will be automatically validated to make sure both fields contain the exact same text. */
        self.retypePasswordField.quickValidationTypes = [.NotEmpty]
        self.retypePasswordField.fieldValidationClosure = {textFieldText in
            if textFieldText == self.everythingField.textField.text {
                return (true,nil)
            }
            return (false, "Passwords must match")
        }
        
        /* FORM TWO */
        addressField.quickValidationTypes = [.NotEmpty]
        cityField.quickValidationTypes = [.NotEmpty]
        apartmentField.quickValidationTypes = [.CanBeEmpty] // set a field to 'CanBeEmpty' if its an optional field and you want it to be animated with the form validation
        phoneNumberField.quickValidationTypes = [.NotEmpty]
        
        /* FORM THREE */
        form3Field1.quickValidationTypes = [.NotEmpty]
        form3Field1.allowAutoValidation = true
        form3Field2.quickValidationTypes = [.NotEmpty]
        form3Field2.allowAutoValidation = true
        form3Field1.fieldValidationClosure = {textFieldText in
            if CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: textFieldText)) {
                return (true,nil)
            }
            return (false, "Must only contain numbers")
        }
        form3Field2.fieldValidationClosure = {textFieldText in
            let numbersRange = textFieldText.rangeOfCharacter(from: .decimalDigits)
            let hasNumbers = (numbersRange != nil)
            if !hasNumbers {
                return (true,nil)
            }
            return (false, "Cannot contain any numbers")
        }
        
    }

    @IBAction func validateFormOneButtonPressed(_ sender: Any) {
        let _ = SDFancyTextField.validate(form: "form1", withAnimation: true)
    }
    
    @IBAction func validateFormTwoButtonPressed(_ sender: Any) {
        let _ = SDFancyTextField.validate(form: "form2", withAnimation: true)
    }
    
    @IBAction func validateFormThreeButtonPressed(_ sender: Any) {
        let _ = SDFancyTextField.validate(form: "form3", withAnimation: true)
    }
    
    @IBAction func validateAllFormsButtonPressed(_ sender: Any) {
        let _ = SDFancyTextField.validate(form: "form1", withAnimation: true)
        let _ = SDFancyTextField.validate(form: "form2", withAnimation: true)
        let _ = SDFancyTextField.validate(form: "form3", withAnimation: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
