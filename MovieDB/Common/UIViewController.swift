//
//  UIViewController.swift
//  MovieDB
//
//  Created by destanti on 02/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//

import UIKit

extension UIViewController{
    
    func setupNavigationBarTitle(_ title:String){
        
        navigationItem.title = title
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        } else {
            let textChangeColor = [NSAttributedString.Key.foregroundColor:UIColor.white]
            navigationController?.navigationBar.titleTextAttributes = textChangeColor
            navigationController?.navigationBar.barTintColor = .black
            navigationController?.navigationBar.tintColor = .black
        }
        

        UINavigationBar.appearance().barTintColor = .black
        
    }

}
