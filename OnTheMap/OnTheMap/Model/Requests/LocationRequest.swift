//
//  LocationRequest.swift
//  OnTheMap
//
//  Created by Tianna Henry-Lewis on 2020-05-03.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import Foundation

struct LocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
