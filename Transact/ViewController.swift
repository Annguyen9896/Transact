//
//  ViewController.swift
//  Transact
//
//  Created by An Nguyen on 4/1/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.performSegue(withIdentifier: "loginView", sender: self);
    }
}
    
//    @IBAction func sendMessage(sender: Any) {
//        let alertControl = UIAlertController(title: "New User", message: "Enter user info", preferredStyle: .alert)
//        alertControl.addTextField{ textField in textField.placeholder = "your message ..."
//        }
//        alertControl.addAction(UIAlertAction(title: "send", style: .default, handler: {action in guard let text = alertControl.textFields?.first?.text else {print("Not text available");return}
//
//            let message = Message(message: text)
//
//            let postRequest = APIRequest(endpoint: "message")
//
//            postRequest.save(messageToSave: message, completion: { result in
//                switch result{
//                    case .success(let message):
//                        print("The following message has been sent: \(message.message)")
//                case .failure(let error):
//                    print("An error has occured \(error)")
//                }
//
//            })
//
//        }))
//        self.present(alertControl,animated: true)
//    }





