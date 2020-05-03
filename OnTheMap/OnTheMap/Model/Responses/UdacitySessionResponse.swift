//
//  UdacitySessionResponse.swift
//  OnTheMap
//
//  Created by Tianna Henry-Lewis on 2020-04-28.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import Foundation

struct Account: Codable {
    let registered: Bool
    let key : String
}

struct Session: Codable {
    let id: String
    let expiration: String
}


struct SessionResponse: Codable {
    let account : Account
    let session : Session
}







