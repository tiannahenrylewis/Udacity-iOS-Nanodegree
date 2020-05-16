//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Tianna Henry-Lewis on 2020-04-23.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    //MARK: - Variables
    var meme : Meme!
    
    //MARK: - Storyboard Connections
    @IBOutlet weak var memeImageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the view background to dark gray
        view.backgroundColor = .darkGray
        
        //Set the navigation title
        self.title = "\(meme.topText) - \(meme.bottomText)"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
        ]

        //Hide the tab bar when user is viewing a saved meme
        self.tabBarController?.tabBar.isHidden = true
        
        memeImageView.image = meme.editedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
