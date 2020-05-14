//
//  Photo+Extensions.swift
//  VirtualTourist
//
//  Created by Tianna Henry-Lewis on 2020-05-13.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Photo {
    static var uniqueID : Int64 = 0
   
   class func fetchUniqueID() -> Int64 {
      uniqueID += 1
      return uniqueID
   }
   
   public override func awakeFromInsert() {
      self.id = Photo.fetchUniqueID()
    // put placeholder image into photo
    self.imageData = UIImage(systemName: "photo")?.jpegData(compressionQuality: 1.0)
   }
   
   // construct a UIImage from the stored imageData on get, store UIImage as imageData and track that it's no longer a placeholder image on set
   var image: UIImage {
      get {
         return UIImage(data: self.imageData!)!
      }
      set(newImage) {
         self.imageData = newImage.jpegData(compressionQuality: 1.0)
         self.placeholder = false
      }
   }
}
