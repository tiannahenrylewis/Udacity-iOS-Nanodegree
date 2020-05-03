//
//  LocationTableViewController.swift
//  OnTheMap
//
//  Created by Tianna Henry-Lewis on 2020-05-01.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController {
    
    //MARK: - Storyboard Outlets
    
    

    //MARK:  - VARIABLES
    let cellReuseIdentifier = "LocationCell"

    
    //MARK: - LIFECYCLE FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - TABLEVIEW DATA SOURCE
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return UdacityAPIClient.Variables.studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! LocationTableViewCell
        let studentLocation = UdacityAPIClient.Variables.studentLocations[indexPath.row]
    
        cell.nameLabel.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell.urlLabel.text = studentLocation.mediaURL
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = UdacityAPIClient.Variables.studentLocations[indexPath.row].mediaURL
        if let url = URL(string: url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            let ac = UIAlertController(title: "Invalid URL", message: "Sorry, but the url you are attempting to access is invalid.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(ac, animated: true)
        }
    }
    
    //MARK: - UI-DRIVEN FUNCTIONS
    @IBAction func logoutButtonTapped(_ sender: Any) {
        UdacityAPIClient.logout(completion: handleLogoutResponse(success:error:))
    }
    
    
    //MARK: - FUNCTIONS
    func handleLogoutResponse(success: Bool, error: Error?) {
        DispatchQueue.main.async {
            if success {
                self.dismiss(animated: true, completion: nil)
            } else {
                print("ERROR LOGGIN OUT - IMPLEMENT ALERT")
            }
        }
    }
    

}
