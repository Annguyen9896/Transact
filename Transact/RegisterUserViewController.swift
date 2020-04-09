//
//  RegisterUserViewController.swift
//  Transact
//
//  Created by An Nguyen on 4/2/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import UIKit

class RegisterUserViewController: UIViewController {

    @IBOutlet weak var UserNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func registerButton(_ sender: Any) {
        print("register buttons selected")
        
        //validate required field are not empty
        if(firstNameTextField.text?.isEmpty)! ||
            (lastNameTextField.text?.isEmpty)! ||
            (emailTextField.text?.isEmpty)! ||
            (passwordTextField.text?.isEmpty)! ||
            (UserNameTextField.text?.isEmpty)! ||
            (phoneNumberTextField.text?.isEmpty)!
        {
            //Display Alert messgae and return
            displayMessage(userMessage: "All field are required to fill in")
            return
        }
        
        //Create Activity Indicator
        let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    
        //Position Activity Indicator in the center of the main view
        myActivityIndicator.center = view.center
        
        //If need, prevent Activity Indocator from hiding when stopAnimating() is called
        myActivityIndicator.hidesWhenStopped = false
        
        //Start Activity Indicator
        myActivityIndicator.startAnimating()
        
        view.addSubview(myActivityIndicator)
        
        //Send HTTP Requeste to register new user
        let myURL = "http://transactserver.eastus.cloudapp.azure.com:3000/adduser"
        guard let resourceURL = URL(string: myURL) else {fatalError()}
        var request = URLRequest(url:resourceURL)
        request.httpMethod = "POST" //compose a query string
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = [
            "username": UserNameTextField.text!,
            "password": passwordTextField.text!,
            "firstname": firstNameTextField.text!,
            "lastname":lastNameTextField.text!,
            "email":emailTextField.text!,
            "phone":phoneNumberTextField.text!] as [String : String]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            displayMessage(userMessage: "Something went wrong. Try again later 78.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            self.removeActivityIndicator(activityIndicator: myActivityIndicator)
            
            if error != nil{
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later 86")
                print("error=\(String(describing: error))")
                return
            }
            else{
                self.displayMessage(userMessage: "Successfully register a new account. Please sign in to continue!")
            }
        }
            
            task.resume()
        }
        
        func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
            DispatchQueue.main.async {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    
    @IBAction func signInButton(_ sender: Any) {
        print("sign in button selected")
        let signInViewController =
            self.storyboard?.instantiateViewController(identifier:"SignInViewController") as! SignInViewController
        self.present(signInViewController, animated: true)
    }
    
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Alert", message: userMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default)
            { (action:UIAlertAction!) in
                //Code in this block will trigger when OK button is tapped.
                print("OK button is selected")
                
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
   
}
