//
//  AddItemViewController.swift
//  Collector
//
//  Created by Ryan Miller on 4/12/18.
//  Copyright © 2018 Ryan Miller. All rights reserved.
//

import UIKit

//Need to add UIImagePickerControllerDelegate and UINavigationControllerDelegate as sublcasses for this controller, because this class will be references using "self" as the delegate for controlling image retrieval and use
class AddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var itemImageView: UIImageView!
    
    //intantiate image picker controller to be used (source set below dep. on user choice)
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
    }

    @IBAction func photosTapped(_ sender: Any) {
        //set imagepicker source to library
        imagePicker.sourceType = .photoLibrary
        //present viewControllerToPresent (choose image picker)
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        //set imagepicker source to camera
        imagePicker.sourceType = .camera
        //present viewControllerToPresent (choose image picker)
        present(imagePicker, animated: true, completion: nil)
    }
    
    //Add this function to be called whenever user picks an image, returns a "dictionary" called info
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //pull out image from dictionary
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //if we have an actual image, we can put it inside our imageview
            itemImageView.image = chosenImage
        }
        //now dismiss the imagePicker
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    //function for adding image to core data
    @IBAction func addTapped(_ sender: Any) {
        //use generic chunk of code to set up context for interacting with core data
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            //create new item in coredata
            let item = Item(entity: Item.entity(), insertInto: context)
            //set item properties to be whatever the chosen image and title are
            item.title = titleTextField.text
            //to set image, first get access to chosen image, then convert to type data since it has to be in data format to store in core data
            if let image = itemImageView.image {
                //converts to data format, but as an optional so use if let again:
                if let imageData = UIImagePNGRepresentation(image) {
                    item.image = imageData
                }
            }
            //save context
            try? context.save()
            //pop back to previous view controller
            navigationController?.popViewController(animated: true)
        }
        
        
    }
    
}
