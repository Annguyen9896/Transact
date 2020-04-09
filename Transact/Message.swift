//
//  Message.swift
//  Transact
//
//  Created by An Nguyen on 4/1/20.
//  Copyright © 2020 An Nguyen. All rights reserved.
//

import Foundation

final class Message: Codable {
    var id:Int?
    var message: String
    
    init(message: String) {
        self.message = message
    }
}
