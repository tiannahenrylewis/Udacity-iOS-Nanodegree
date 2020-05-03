//
//  ViewController.swift
//  OnTheMap
//
//  Created by Tianna Henry-Lewis on 2020-04-23.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - API STUFF TO BE MOVED
    
    //MARK: - Variables
    var userEmail : String = ""
    var userPassword : String = ""
    
    
    var udacitySignUpPage = "https://auth.udacity.com/sign-up"
    
    
    //MARK: - Storyboard Connections
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Set the textfield Delegate
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
    }
    
    //MARK: - UI Functions
    @IBAction func loginButtonTapped(_ sender: Any) {
        handleSessionResponse()
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        if let url = URL(string: udacitySignUpPage) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    
    //MARK: - Functions
    func handleSessionResponse () {
        UdacityAPIClient.login(username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        DispatchQueue.main.async {
            if success {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
            } else {
                self.performSegue(withIdentifier: "loginSegue", sender: self)
//                let ac = UIAlertController(title: "Login Unsuccessful", message: error?.localizedDescription ?? "", preferredStyle: .alert)
//                ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//                self.present(ac, animated: true)
            }
        }
    }
    
    func presentAlert(title: String, message: String, actionTitle: String) {
        
    }
    

}

