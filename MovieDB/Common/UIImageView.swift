//
//  UIImageView.swift
//  MovieDB
//
//  Created by destanti on 02/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String) {
        
        let url = URL(string: "\(AppContants.imageBasePath)\(urlString)")
        if url == nil {return}
        self.image = nil

        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }

        let activityIndicator: UIActivityIndicatorView
        
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView.init(style: .medium)
        } else {
            activityIndicator = UIActivityIndicatorView.init(style: .gray)
        }
        
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.center = self.center

        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }

            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }

        }).resume()
    }
}
