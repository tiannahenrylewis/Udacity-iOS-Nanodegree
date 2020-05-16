//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Tianna Henry-Lewis on 2020-04-23.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    //MARK: - Variables
    //Create a computed meme property and set as the meme array in the app delegate
    var savedMemes : [Meme] {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    //Set the cell reuseIdentifier into a variable for easier management
    let cellReuseIdentifier = "MemeCollectionViewCell"
    //Set the Detail View Identifier into a variable
    let detailVCIdentifier = "MemeDetailVC"
    
    
    
    //MARK: - Storyboard Connections
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    
    //MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Set the views background colour
        view.backgroundColor = .darkGray
        
        //Set the navigation bar title
        self.title = "Sent Memes"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
        ]
        
        //Configure FlowLayout
        let space : CGFloat = 2.0
        let heightDimension = (view.frame.size.width - (space * 2)) / 3
        let widthDimension = heightDimension
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: widthDimension, height: heightDimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    


    //MARK: - CollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return savedMemes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //Set the collection cell reuse identifier and cast as MemeCollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        
        let meme = savedMemes[indexPath.row]
        
        //Configure cell appearance
        cell.memeImageView.image = meme.editedImage
        
        return cell
    }
    
    
    //MARK: - CollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedMeme = savedMemes[indexPath.row]
        
        let destinationVC = storyboard?.instantiateViewController(withIdentifier: detailVCIdentifier) as! MemeDetailViewController
        destinationVC.meme = selectedMeme
        
        //Segue to Detail View
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }

}
