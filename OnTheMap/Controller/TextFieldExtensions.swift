//
//  TextFieldExtensions.swift
//  OnTheMap
//
//  Created by Mohammed Khakidaljahdali on 10/11/2019.
//  Copyright © 2019 Mohammed. All rights reserved.
//

import Foundation
import UIKit

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddPinViewController: UITextFieldDelegate {
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
