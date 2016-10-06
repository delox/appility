//
//  AppCell.swift
//  Appi
//
//  Created by Jose Solorzano on 10/4/16.
//  Copyright © 2016 Jose Solorzano. All rights reserved.
//

import UIKit

class AppCell: UITableViewCell {

    @IBOutlet weak var leftImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var artistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.leftImageView.layer.cornerRadius = 7.0
        self.leftImageView.clipsToBounds = true
        
        self.layoutMargins = UIEdgeInsetsZero
        self.separatorInset = UIEdgeInsetsZero
    }
    
    func configureWithImage( image : UIImage)
    {
        self.leftImageView.image = image
    }
    
    func configureWithApp( app : App)
    {
        self.titleLabel.text = app.title
        self.artistLabel.text = app.artist
        self.leftImageView.image = UIImage()
    }

    override func setSelected(selected: Bool, animated: Bool) {
       // super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
