//
//  SearchPhotosResponse.swift
//  VirtualTourist
//
//  Created by Tianna Henry-Lewis on 2020-05-12.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import Foundation

struct SearchPhotosResponse: Codable {
   let photos: PhotosResponse
   let status: String
   
   enum CodingKeys: String, CodingKey {
      case photos
      case status = "stat"
   }
}
