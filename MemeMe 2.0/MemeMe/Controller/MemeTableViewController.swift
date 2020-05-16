//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Tianna Henry-Lewis on 2020-04-23.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import UIKit

//Present a tableview that shows all of the saved memes
class MemeTableViewController: UITableViewController {

    //MARK: - Variables
    //Create a computed meme property and set as the meme array in the app delegate
    var savedMemes : [Meme] {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    //Set the cell reuseIdentifier into a variable for easier management
    let cellReuseIdentifier = "MemeTableViewCell"
    //Set the Detail View Identifier into a variable
    let detailVCIdentifier = "MemeDetailVC"
    
    
    
    //MARK: - Lifecycle Funtions
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .darkGray
        self.title = "Sent Memes"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return savedMemes.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! MemeTableViewCell

        let meme = savedMemes[indexPath.row]

        cell.memeImageView.image = meme.editedImage
        cell.memeLabel.text = String("\(meme.topText)\n\(meme.bottomText)")

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedMeme = savedMemes[indexPath.row]
        
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: detailVCIdentifier) as! MemeDetailViewController
        destinationVC.meme = selectedMeme
        
        //Segue to Detail View
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }

    
    //MARK: - Functions


}
