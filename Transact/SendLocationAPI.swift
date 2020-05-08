//
//  SendLocationAPI.swift
//  Transact
//
//  Created by An Nguyen on 4/14/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import Foundation

enum APIError: Error {
    case responseProblem
    case decodingProblem
    case otherProblem
    case encodingProblem
}

struct SendLocationAPI{
    let resourceURL: URL
    
    init(endpoint:  String){
        let resourceString = "http://translocationserver.eastus.cloudapp.azure.com:3000/\(endpoint)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        
        self.resourceURL = resourceURL
    }
    
    
    func summit (_ messageToSave: Message, completion: @escaping(Result<String, APIError>)->Void){
        do {
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = try JSONEncoder().encode(messageToSave)
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                    if error != nil{
                        return
                    }
                    do{
                        let status = String(data: data!, encoding: String.Encoding.utf8) // the data will be converted to the string
                        if(status == "Subscriber Added! Good Job!\n"){
                            completion(.success("Message sent!"))
                            
                        }
                    }
            }
            task.resume()

        }catch{
            completion(.failure(.encodingProblem))
        }
    }
}
