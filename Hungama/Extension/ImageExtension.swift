//
//  ImageExtension.swift
//  Hungama
//
//  Created by admin_vserv on 19/12/20.
//

import Foundation
import UIKit

extension UIImageView {
    
    func loadImage(_ imgURL: String?) {
        
        let imageURL = imgURL
        
        guard let imageURLString: String = imageURL else {
            self.image = UIImage(named: "placeholder")
            return
        }
        if imageURLString == "" {
            self.image = UIImage(named: "placeholder")
            return
        }
        
        DispatchQueue.global().async { [weak self] in
            let data = try? Data(contentsOf: URL(string: imageURLString)!)
            DispatchQueue.main.async {
                self?.image = data != nil ? UIImage(data: data!) : UIImage(named: "placeholder")
            }
        }
    }
}
