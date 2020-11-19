//
//  ViewController+Extenstion.swift
//  FirebaseDemo
//
//  Created by Ahmed Nasr on 11/19/20.
//

import Foundation
import UIKit
extension UIViewController{
    func goToWithNavigate(viewControllerName: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewControllerName)
        self.navigationController?.pushViewController(storyboard, animated: true)
    }
    
    func goToWithPresent(viewControllerName: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewControllerName)
        self.present(storyboard, animated: true, completion: nil)
    }
}
