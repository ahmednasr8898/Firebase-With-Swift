//
//  ViewController.swift
//  FirebaseDemo
//
//  Created by Ahmed Nasr on 11/19/20.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.keyboardType = .emailAddress
        passwordTextField.isSecureTextEntry = true
    }
    //for sing in
    @IBAction func loginOnClick(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {return}
        //login
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil{
                print("Login Success")
                // go to home page
                self.dismiss(animated: true, completion: nil)
            }else{
                print("login faild")
            }
        }
    }
    //for sign up (craete new account)
    @IBAction func registerOnClick(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {return}
        //sing up
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error == nil{
                print("Register success")
                //go to home page
                self.dismiss(animated: true, completion: nil)
            }else{
                print("register faild")
            }
        }
    }
}

