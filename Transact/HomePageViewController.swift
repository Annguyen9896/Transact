//
//  HomePageViewController.swift
//  Transact
//
//  Created by An Nguyen on 4/2/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    //Array to store locations
    var locations:[Location] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Send HTTP request to load locations
               let myURL = "http://transactserver.eastus.cloudapp.azure.com:3000/locations"
               guard let resourceURL = URL(string: myURL) else {fatalError()}
               var request = URLRequest(url:resourceURL)
               request.httpMethod = "GET" //compose a query string
               URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                   if(error != nil){
                       print("error=\(String(describing: error))")
                   }

                   if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] {
                       for locationDictionary in json{
                           guard let locationName = locationDictionary["locationName"] as? String, let description = locationDictionary["description"] as? String else { continue }
                        self.locations.append(Location(locationName: locationName, description: description))
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
//                        print(self.locations)
                       }
                   }


               }.resume()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
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
    

    @IBAction func signOutTabButton(_ sender: Any) {
        print("sign out button selected")
        let signInViewController =
                   self.storyboard?.instantiateViewController(identifier:"SignInViewController") as! SignInViewController
               self.present(signInViewController, animated: true)
        
    }
    @IBAction func loadLocationButton(_ sender: Any) {
        print("Load location button selected")
        //Send HTTP request to load locations
        self.locations.removeAll()
        let myURL = "http://transactserver.eastus.cloudapp.azure.com:3000/locations"
        guard let resourceURL = URL(string: myURL) else {fatalError()}
        var request = URLRequest(url:resourceURL)
        request.httpMethod = "GET" //compose a query string
        URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if(error != nil){
                print("error=\(String(describing: error))")
            }
            if let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]] {
            for locationDictionary in json{
                guard let locationName = locationDictionary["locationName"] as? String, let description = locationDictionary["description"] as? String else { continue }
                self.locations.append(Location(locationName: locationName, description: description))
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }.resume()
}
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
               DispatchQueue.main.async {
                   activityIndicator.stopAnimating()
                   activityIndicator.removeFromSuperview()
               }
           }
    
    func sendFollowRequest(userName: String, locationName: String){
        //Create Activity Indicator
               let myActivityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
           
               //Position Activity Indicator in the center of the main view
               myActivityIndicator.center = view.center
               
               //If need, prevent Activity Indocator from hiding when stopAnimating() is called
               myActivityIndicator.hidesWhenStopped = false
               
               //Start Activity Indicator
               myActivityIndicator.startAnimating()
               
               view.addSubview(myActivityIndicator)
         let myURL = "http://transactserver.eastus.cloudapp.azure.com:3000/adduser"
               guard let resourceURL = URL(string: myURL) else {fatalError()}
               var request = URLRequest(url:resourceURL)
               request.httpMethod = "POST" //compose a query string
               request.addValue("application/json", forHTTPHeaderField: "content-type")
               request.addValue("application/json", forHTTPHeaderField: "Accept")
               
               let postString = [
                   "username": userName,
                   "locationName": locationName] as [String : String]
               
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
                //print(String(data: data!, encoding: String.Encoding.utf8))
            }
        }
            
            task.resume()
        }
    }

    
    extension HomePageViewController: UITableViewDelegate, UITableViewDataSource {
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.locations.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = locations[indexPath.row].locationName
        cell.detailTextLabel?.text = locations[indexPath.row].description
       
           //switch
           let swicthView = UISwitch(frame: .zero)
           swicthView.setOn(false, animated: true)
           swicthView.tag = indexPath.row
        swicthView.addTarget(self, action: #selector(followToggle(sender:locationName:)), for: .valueChanged)
           
           cell.accessoryView = swicthView
           
           return cell
           
       }
       
        @objc func followToggle(sender: UISwitch!, locationName: String) {
            if(sender.isOn){
                sendFollowRequest(userName: "pbj1132", locationName: locationName)
            }
       }
}
