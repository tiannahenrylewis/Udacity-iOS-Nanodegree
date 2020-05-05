//
//  UserResponse.swift
//  OnTheMap
//
//  Created by Tianna Henry-Lewis on 2020-05-03.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
    let firstName: String
    let lastName: String
}

struct UserResponse: Codable {
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
