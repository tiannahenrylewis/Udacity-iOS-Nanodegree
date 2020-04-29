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
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case session
        
        var stringValue: String {
            switch self {
            case .session:
                return Endpoints.base + "/session"
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
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.session.url)
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
                print("SET DECODER")
                let decoder = JSONDecoder()
                print("SET RESPONSE")
                let response = try decoder.decode(SessionResponse.self, from: data)
                print("RESPONSE: \(response)")
                Auth.sessionID = response.session.id
                //Auth.accountKey = response.account.key
                print("Sesssion ID: \(Auth.sessionID)")
                print("Account Key: \(Auth.accountKey)")
                completion(true, nil)
            } catch {
                completion(false, error)
                print("DATA: \(data)")
                print("[2]: \(error)")
            }
        }
        task.resume()
    }
}
