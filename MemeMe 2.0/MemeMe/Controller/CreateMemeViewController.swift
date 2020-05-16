//
//  VaiewController.swift
//  MemeMe
//
//  Created by Tianna Henry-Lewis on 2020-04-22.
//  Copyright © 2020 Tianna Henry-Lewis. All rights reserved.
//

import Foundation
import UIKit

class CreateMemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //MARK: -  Variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let memeTextAttributes : [NSAttributedString.Key : Any] = [
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth : CGFloat(-5.0)
    ]
    
    
    
    //MARK: - UI Connections
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    
    
    //MARK: - Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Set the title of the NavBar
        self.title = "Meme Editor"
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white,
        ]
        
        //Un-enable cameraButton if source is not available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //Un-enable the share and save buttons on first load as no image has been selected
        setShareSaveStatus(enabled: false)
        
        //Configuration of the Top and Bottom TextField UI elements
        configureTextField(toTextField: topTextField, defaultText: "TOP TEXT")
        configureTextField(toTextField: bottomTextField, defaultText: "BOTTOM TEXT")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotificatios()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("User has selected an image.")
        
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("User has cancelled action.")
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Clear the default text if the user clicks into the text field.
        if textField.text == "TOP TEXT" || textField.text == "BOTTOM TEXT" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Dismiss the Keyboard if the user taps Return
        textField.resignFirstResponder()
        return true
    }
    
    
    
    //MARK: - IBAction Functions
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        openImagePicker(.photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        openImagePicker(.camera)
    }
    
    @IBAction func shareMemeButtonTapped(_ sender: Any) {
        shareMeme()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        //Generate a meme to be saved
        let memedImage = generateMemedImage()
        //Save the meme
        saveMeme(image: memedImage)
        //Dismiss the View
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Functions
    //Configure the Top and Bottom TextFields
    func configureTextField(toTextField textField: UITextField, defaultText: String) {
        //Set the textfield delegate
        textField.delegate = self
        //Set the appearance of the textfield font
        textField.defaultTextAttributes = memeTextAttributes
        //Center align the text field
        textField.textAlignment = .center
        //Set the default text of the text field
        textField.text = defaultText
        //Set the captilization of the font
        textField.autocapitalizationType = .allCharacters
    }
    
    //Set is the isEnabled status of the share and save buttons
    func setShareSaveStatus(enabled: Bool) {
        shareButton.isEnabled = enabled
        saveButton.isEnabled = enabled
    }
    
    //Set the image picker controller and delegate and open the stated source type
    func openImagePicker(_ type: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = type
        present(imagePicker, animated: true, completion: nil)
        setShareSaveStatus(enabled: true)
    }
    
    //Hide Toolbar & NavBar
    func configureToolbars(hide: Bool) {
        toolbar.isHidden = hide
        navigationController?.setNavigationBarHidden(hide, animated: true)
    }
    
    @objc func presentKeyboard(_ notification : Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func hideKeyboard(_ notification : Notification) {
        if bottomTextField.isFirstResponder {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(_ notification : Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(presentKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(hideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotificatios() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func generateMemedImage() -> UIImage {
        //call function that controls the the isHidden state of the toolbar and NavBar
        configureToolbars(hide: true)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //call function that controls the the isHidden state of the toolbar and NavBar
        configureToolbars(hide: false)

        return memedImage
    }
    
    func saveMeme(image: UIImage) {
        //Create the Meme from the Meme Model
        let createdMeme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, editedImage: image)
        
        //Save meme to the app delegates memes array
        appDelegate.memes.append(createdMeme)
    }
    
    //Generated a memed Image, launch share sheet, once user has completed share action, save the memed image
    func shareMeme() {
        //Generate a memed image
        let memedImage = generateMemedImage()
        
        //Define an instance of ActivityViewController, passing the memed image as an activity item
        let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        //Present ActivityViewController
        present(activityController, animated: true, completion: nil)
        
        activityController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            if completed {
                //Save the memed image
                self.saveMeme(image: memedImage)
            }
            //Dismiss the View
            self.dismiss(animated: true, completion: nil)
        }
    }
}

