//
//  LoginController.swift
//  InnovationAdvocates
//
//  Created by Neil on 15/06/2018.
//  Copyright © 2018 Neil. All rights reserved.
//Git comment

import UIKit

class LoginController: UIViewController {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTexField: UITextField!
    @IBOutlet weak var goBtn: UIButton!
    
    let bar = UIToolbar()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Network.shared.isUserLoggedIn(view: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        runStyles()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    
    
    @IBAction func loginButton(_ sender: UIButton) {
        if let email = emailTextField.text, let password = passwordTexField.text, let name = nameTextField.text{
            if Network.currentUser == nil {
                Network.shared.createUser(email: email, password: password, username: name, lastLogin: Date())
            }else{
                Network.shared.loginUser(email: email, password: password)
            }
        }
    }
    
    func runStyles(){
        
        goBtn.layer.cornerRadius = goBtn.frame.height / 2
        let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneBtn))
        bar.items = [done]
        bar.sizeToFit()
        passwordTexField.inputAccessoryView = bar
        passwordTexField.setBottomLine(borderColor: UIColor.white)
        emailTextField.inputAccessoryView = bar
        emailTextField.setBottomLine(borderColor: UIColor.white)
        nameTextField.inputAccessoryView = bar
        nameTextField.setBottomLine(borderColor: UIColor.white)
        
        if let username = defaults.string(forKey: "username"), let email = defaults.string(forKey: "email") {
            nameTextField.text = username
            nameTextField.isUserInteractionEnabled = false
            emailTextField.text = email
            emailTextField.isUserInteractionEnabled = false
        }
    }
    
    @objc func doneBtn(){
        passwordTexField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
    }
    
}

extension UITextField {
    
    func setBottomLine(borderColor: UIColor) {
        
        self.borderStyle = UITextBorderStyle.none
        self.backgroundColor = UIColor.clear
        
        let borderLine = UIView()
        let height = 1.0
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height, width: Double(self.frame.width), height: height)
        
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
}

