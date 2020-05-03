//
//  UdacityAPIClient.swift
//  OnTheMap
//
//  Created by Tianna Henry-Lewis on 2020-04-28.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import Foundation

class UdacityAPIClient {
    
    struct Auth {
        static var sessionID = ""
        static var accountKey = ""
    }
    
    struct Variables {
        static var studentLocations = [StudentInformation]()
    }
    
    //MARK : - Endpoint Handler
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        static let session = "/session"
        static let studentLocations = "/StudentLocation?limit=100&order=-updatedAt"
        
        case baseURL
        case getSessionURL
        case getStudentLocationsURL
        
        var stringValue: String {
            switch self {
            case.baseURL:
                return Endpoints.base
            case .getSessionURL:
                return Endpoints.base + Endpoints.session
            case .getStudentLocationsURL:
                return Endpoints.base + Endpoints.studentLocations
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    //MARK: - FUNCTIONS
    class func parseAPIResponse(data: Data) -> Data {
        let range = 5..<data.count
        return data.subdata(in: range)
    }
    
    //MARK: login()
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.getSessionURL.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody = LoginRequest(udacity: UdacityRequest(username: username, password: password))
        request.httpBody = try! JSONEncoder().encode(requestBody)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard var data = data else {
                completion(false, error)
                print("[1]: \(error)")
                return
            }
            
            data = parseAPIResponse(data: data)
            
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(SessionResponse.self, from: data)
                Auth.sessionID = response.session.id
                Auth.accountKey = response.account.key
                completion(true, nil)
            } catch {
                completion(false, error)
                print("DATA: \(data)")
                print("[2]: \(error)")
            }
        }
        task.resume()
    }
    
    //MARK: logout()
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.getSessionURL.url)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task  = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("Error Logging Out")
                completion(false, error)
            } else {
                //1. Clear the Auth Variables saved during login process
                Auth.sessionID = ""
                Auth.accountKey = ""
                
                //2. Set completion handler return variables
                completion(true, nil)
            }
        }
        task.resume()
    }
    
//    request.httpMethod = "DELETE"
//    var xsrfCookie: HTTPCookie? = nil
//    let sharedCookieStorage = HTTPCookieStorage.shared
//    for cookie in sharedCookieStorage.cookies! {
//      if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
//    }
//    if let xsrfCookie = xsrfCookie {
//      request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
//    }
    
    //MARK: getStudentLocations()
    class func getStudentLocations(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.getStudentLocationsURL.url)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false, error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(StudentLocationResponse.self, from: data)
                Variables.studentLocations = response.results
                completion(true, nil)
            } catch {
                completion(false, error)
            }
        }
        task.resume()
    }
    
    
    
}
