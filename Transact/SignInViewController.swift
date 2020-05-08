//
//  SignInViewController.swift
//  Transact
//
//  Created by An Nguyen on 4/2/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
  
    @IBAction func loginButton(_ sender: Any) {
        print("login button selected")
        
        //read value from text fields
        let userName = userNameTextField.text
        let userPassword = passwordTextField.text
        
        //check of required field are empty
        if(userName?.isEmpty)! || (userPassword?.isEmpty)!{
             print("User name\(String(describing: userName)) or password \(String(describing: userName)) is empty ")
            displayMessage(userMessage: "All field must be filled")
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
        let myURL = "http://translocationserver.eastus.cloudapp.azure.com:3000/checkuser"
        guard let resourceURL = URL(string: myURL) else {fatalError()}
        var request = URLRequest(url:resourceURL)
        request.httpMethod = "POST" //compose a query string
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString = [
            "username": userNameTextField.text!.lowercased(),
            "password": passwordTextField.text!.lowercased(),] as [String : String]
            
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
        } catch let error {
                print(error.localizedDescription)
                displayMessage(userMessage: "Something went wrong. Try again later.")
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
                let status = String(data: data!, encoding: String.Encoding.utf8) // the data will be converted to the string
                if(status == "FAILED"){
                    self.displayMessage(userMessage: "User Name or Password is invalid, please try again!")
                }
                else{
                    StructOperation.globalVariable.userName = self.userNameTextField.text!
                    DispatchQueue.main.async {
                          let homePageViewController =
                            self.storyboard?.instantiateViewController(identifier:"HomePageViewController") as! HomePageViewController
                            self.present(homePageViewController, animated: true)
                    }
                }
                  
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

  
   
    
    @IBAction func registerButton(_ sender: Any) {
        print("register button selected")
        let registerViewController =
            self.storyboard?.instantiateViewController(identifier:"RegisterUserViewController") as! RegisterUserViewController
        self.present(registerViewController, animated: true)
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
