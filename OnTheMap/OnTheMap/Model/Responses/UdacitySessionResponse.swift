//
//  UdacitySessionResponse.swift
//  OnTheMap
//
//  Created by Tianna Henry-Lewis on 2020-04-28.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import Foundation


// SAMPLE - SESSION RESPONSE
/*
{
    "account":{
        "registered":true,
        "key":"3903878747"
    },
    "session":{
        "id":"1457628510Sc18f2ad4cd3fb317fb8e028488694088",
        "expiration":"2015-05-10T16:48:30.760460Z"
    }
}
*/


struct Account: Codable {
    let registered: Bool
    let key : String
    
    enum CodingKeys: String, CodingKey {
        case registered = "registered"
        case key = "key"
    }
}

struct Session: Codable {
    let id: String
    let expiration: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case expiration = "expiration"
    }
}


struct SessionResponse: Codable {
    let account : Account
    let session : Session
    
    enum CodingKeys: String, CodingKey {
        case account = "account"
        case session = "session"
    }
}







