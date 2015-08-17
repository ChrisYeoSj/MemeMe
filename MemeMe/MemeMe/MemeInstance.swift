//
//  MemeInstance.swift
//  imagePickerExperiment
//
//  Created by Christopher on 16/8/15.
//  Copyright (c) 2015 Chris. All rights reserved.
//

import UIKit

struct Meme{
    
    var bottomText: String!
    var topText: String!
    var memedImage : UIImage!
    var originalImage : UIImage!
    
    init(topText: String, bottomText: String, memeImage: UIImage, originalImage: UIImage){
        self.topText = topText
        self.bottomText = bottomText
        self.memedImage = memeImage
        self.originalImage = originalImage
    }
}
