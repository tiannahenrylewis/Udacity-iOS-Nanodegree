//
//  FlickrAPIClient.swift
//  VirtualTourist
//
//  Created by Tianna Henry-Lewis on 2020-05-12.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import Foundation


class FlickrAPIClient {
    
    struct Variables {
        static var fetchedPhotosResponses = [PhotoResponse]()
        static var fetchedPhotos = [Data]()
        static var photoData: Data!
    }
    
    struct Auth {
        static let apiKey = Constants.FlickrAPIKey
        static let apiSecret = Constants.FlickrAPISecret
    }
    
    //case .source(let photo):
    //return "https://farm\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_q.jpg"
    
    //MARK : - Endpoint Handler
    enum Endpoints {
        static let base = "https://www.flickr.com/services/rest"
        static let photos = "/?method=flickr.photos.search"
        static let photo = "https://farm"
        
        case baseURL
        case searchPhotos(apiLatitude: Double, apiLongitude: Double, apiPerPage: Int, apiPage: Int)
        case downloadPhoto(photo: PhotoResponse)
        
        var stringValue: String {
            switch self {
            case .baseURL:
                return Endpoints.base
            case .searchPhotos(let apiLatitude, let apiLongitude, let apiPerPage, let apiPage):
                return Endpoints.base + Endpoints.photos + "&api_key=\(Auth.apiKey)&lat=\(apiLatitude)&lon=\(apiLongitude)&geo_context=2&per_page=\(apiPerPage)&page=\(apiPage)&format=json&nojsoncallback=1"
            case .downloadPhoto(let photo):
                return Endpoints.photo + "\(photo.farm).staticflickr.com/\(photo.server)/\(photo.id)_\(photo.secret)_q.jpg"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    //MARK: API METHODS
    class func fetchPhotos(fromLocation: (latitude: Double, longitude: Double), completion: @escaping (Bool, Error?) -> Void) {
        let randomPage = Int.random(in: 0...100)
        
        //Build the URL to be used in the URLSession data task
        let request = URLRequest(url: Endpoints.searchPhotos(apiLatitude: fromLocation.latitude, apiLongitude: fromLocation.longitude, apiPerPage: 25, apiPage: randomPage).url)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false, error)
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode(SearchPhotosResponse.self, from: data)
                let photos = [PhotoResponse](responseObject.photos.photo)
                //TODO: Remove if this is no longer needed
                Variables.fetchedPhotosResponses = photos
                completion(true, nil)
            } catch  {
                completion(false, error)
            }

        }.resume()
    }
    
    class func downloadPhoto(photo: PhotoResponse, completion: @escaping (Data?, Error?) -> Void) {
        let request = URLRequest(url: Endpoints.downloadPhoto(photo: photo).url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            DispatchQueue.main.async {
                completion(data, nil)
            }
        }.resume()
    }


}
