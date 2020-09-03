//
//  NSAttributedString.swift
//  MovieDB
//
//  Created by destanti on 03/09/20.
//  Copyright © 2020 destanti. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    var boldFontSize:CGFloat { return 13 }
    var boldFont:UIFont { return UIFont.boldSystemFont(ofSize: boldFontSize) }
    var normalFont:UIFont { return UIFont.systemFont(ofSize: 13)}

    func setBold(substring: String){
        let boldAttribute = [NSAttributedString.Key.font: boldFont]
        self.setAttributes(boldAttribute, range: self.mutableString.range(of: substring, options: .caseInsensitive))
    }
    
    func setNormal(substring: String){
        let normalAttribute = [NSAttributedString.Key.font: normalFont]
        self.setAttributes(normalAttribute, range: self.mutableString.range(of: substring, options: .caseInsensitive))
    }
   
}
