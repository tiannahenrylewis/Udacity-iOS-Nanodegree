//
//  UdacityRequest.swift
//  OnTheMap
//
//  Created by Tianna Henry-Lewis on 2020-04-28.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import Foundation

struct UdacityRequest: Codable {
    let username: String
    let password: String
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case password = "password"
    }
}

struct LoginRequest: Codable {
    let udacity: UdacityRequest
}
