//
//  ViewController.swift
//  SDFancyTextField
//
//  Created by ZuluAlpha on 7/31/18.
//  Copyright © 2018 Solsma Dev Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var test: SDFancyTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let fancyTextView = SDFancyTextField.init(with: CGRect.init(x: 50, y: 50, width: 300, height: 40), iconImage: UIImage.init(named: "solsma_Dev_even"), cornerRadius: 20, borderColor: UIColor.blue)
        fancyTextView.borderColor = UIColor.green
        let fancyTextView2 = SDFancyTextField.init(with: CGRect.init(x: 50, y: 50, width: 300, height: 40), iconImage: UIImage.init(named: "solsma_Dev_even"), cornerRadius: 20, borderColor: UIColor.blue)
        fancyTextView2.borderColor = UIColor.green
        fancyTextView.fieldValidationClosure = {textfieldText in
            if textfieldText.contains("test") {
                return (true, nil)
            }
            return (false, "String does not contain test")
        }
        if fancyTextView.fieldIsValid {
            
        }
        fancyTextView.validationGroup = "test"
        fancyTextView2.validationGroup = "test"
        let validationGroupTuple = SDFancyTextField.validate(group: "test")
        let validationGroupTuple2 = SDFancyTextField.validate(group: "new")
        self.view.addSubview(fancyTextView)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

