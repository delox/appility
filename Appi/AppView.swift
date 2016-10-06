//
//  AppView.swift
//  Appi
//
//  Created by Jose Solorzano on 10/4/16.
//  Copyright © 2016 Jose Solorzano. All rights reserved.
//

import UIKit

class AppView: UICollectionViewCell {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func configureWithImage( image : UIImage)
    {
        self.mainImageView.layer.cornerRadius = 10
        self.mainImageView.clipsToBounds = true
        self.mainImageView.image = image
    }
    
    func configureWithApp( app : App)
    {
        self.titleLabel.text = app.title
    }

}
