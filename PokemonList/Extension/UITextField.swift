//
//  UITextField.swift
//  PokemonList
//
//  Created by user on 07/10/22.
//

import Foundation
import UIKit
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboardIntern))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboardIntern() {
        view.endEditing(true)
    }
    
    class PastelessTextField: UITextField {
      override func canPerformAction(
          _ action: Selector, withSender sender: Any?) -> Bool {
            return super.canPerformAction(action, withSender: sender)
            && (action == #selector(UIResponderStandardEditActions.cut)
            || action == #selector(UIResponderStandardEditActions.copy))
        }
    }
}
