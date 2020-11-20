//
//  UploadImageViewController.swift
//  FirebaseDemo
//
//  Created by Ahmed Nasr on 11/20/20.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

class UploadImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var imageView: UIImageView!
    private let storage = Storage.storage().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func selectPhotoOnClick(_ sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.modalPresentationStyle = .fullScreen
        self.present(picker, animated: true, completion: nil)
        print("Upload photos")
    }
   //when finish from select photo that upload in firebase storage
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        dismiss(animated: true, completion: nil)
        //photo that selected
        guard let imagePickerView = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else{ return }
        //data for photo that selected
        guard let dataImage = imagePickerView.pngData() else { return }
        //upload photo to firebase storage
        storage.child("images").child(Auth.auth().currentUser!.uid).child("file.png").putData(dataImage, metadata: nil) { (_, error) in
            if error == nil{
                print("image is Uploaded")
            }else{
                print("Upload image is faild")
            }
        }
    }
    //when cancel ImagePicker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }
    //get photo from fireabse storage
    @IBAction func getPhotofromServerOnClick(_ sender: UIButton) {
        //Way One
        storage.child("images").child(Auth.auth().currentUser!.uid).child("file.png").getData(maxSize: 4000000) { (data, error) in
            if error != nil{
                print("error when get data\(String(describing: error?.localizedDescription))")
            }else{
                let image = UIImage(data: data!)
                self.imageView.image = image
            }
        
        }
        //Way Two: Get Url
        storage.child("images").child(Auth.auth().currentUser!.uid).child("file.png").downloadURL { url, error in
          if let error = error {
            // Handle any errors
            print("Error When get url\(error.localizedDescription)")
          } else {
            // Get the download URL for 'images/stars.jpg'
            print("url: \(String(describing: url?.absoluteURL))")
           }
        }
    }
}
