//
//  Message.swift
//  Transact
//
//  Created by An Nguyen on 4/14/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import Foundation

final class Message: Codable{
    var username: String
    var message: String
    var locationName: String
    
    init(username: String, message: String, locationName: String ) {
        self.username = username
        self.message = message
        self.locationName = locationName
    }
}
 
