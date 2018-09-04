//
//  SDFancyTextFieldDemoTableViewController.swift
//  SDFancyTextField
//
//  Created by ZuluAlpha on 8/26/18.
//  Copyright © 2018 Solsma Dev Inc. All rights reserved.
//

import UIKit

class SDFancyTextFieldDemoTableViewController: UITableViewController {

    @IBOutlet var everythingField: SDFancyTextField!
    @IBOutlet var validEmailField: SDFancyTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.validEmailField.allowAutoValidation = true
        self.validEmailField.quickValidationTypes = [.ValidEmail]
        self.everythingField.allowAutoValidation = true
        self.everythingField.quickValidationTypes = [.ContainsNumber,.SpecialCharacter,.UppercaseLetter]
        
        self.everythingField.fieldValidationClosure = {textFieldText in
            if (textFieldText.lowercased().contains("test") && textFieldText.count >= 7) {
                return (true, nil)
            }
            if !textFieldText.lowercased().contains("test") {
                return (false, "Must contain the word 'test'")
            }
            return (false, "Length must be 7 or greater")
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
