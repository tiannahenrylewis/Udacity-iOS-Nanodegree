//
//  StudentInformationModel.swift
//  OnTheMap
//
//  Created by Tianna Henry-Lewis on 2020-04-29.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import Foundation

struct StudentInformation : Codable {
    let objectId : String
    let uniqueKey : String
    let firstName : String
    let lastName : String
    let mapString : String
    let mediaURL : String
    let latitude : Double
    let longitude : Double
    let createdAt : String
    let updatedAt: String
}
