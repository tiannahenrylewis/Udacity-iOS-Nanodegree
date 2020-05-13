//
//  PhotosResponse.swift
//  VirtualTourist
//
//  Created by Tianna Henry-Lewis on 2020-05-12.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import Foundation

struct PhotoResponse: Codable {
   let id: String
   let owner: String
   let secret: String
   let server: String
   let farm: Int
   let title: String
   let isPublic: Int
   let isFriend: Int
   let isFamily: Int
   
   enum CodingKeys: String, CodingKey {
      case id, owner, secret, server, farm, title
      case isPublic = "ispublic"
      case isFriend = "isfriend"
      case isFamily = "isfamily"
   }
}

struct PhotosResponse: Codable {
   let page: Int
   let pages: Int
   let perPage: Int
   let total: String
   let photo: [PhotoResponse]
   
   enum CodingKeys: String, CodingKey {
      case page, pages, total, photo
      case perPage = "perpage"
   }
}
