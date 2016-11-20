//
//  ImagePreview.swift
//  Khedmat
//
//  Created by Ali Alibrahim on 7/12/16.
//  Copyright © 2016 Ali Alebrahim. All rights reserved.
//

import UIKit
//TODO: delete this image.
class ImagePreview: UIViewController {
    var image: UIImage?
    var imageIndex: Int?
    @IBOutlet weak var myImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myImageView.contentMode = .scaleAspectFit
        myImageView.clipsToBounds = true
        if let myImage = image {
            myImageView.image = myImage
        }
        
    }
}
