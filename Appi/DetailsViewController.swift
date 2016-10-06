//
//  DetailsViewController.swift
//  Appi
//
//  Created by Jose Solorzano on 10/5/16.
//  Copyright © 2016 Jose Solorzano. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    var app : App!
    var imageView: UIImageView!
    var scrollView: UIScrollView!
    var titleLabel : UILabel!
    var artistLabel : UILabel!
    var separator : UIView!
    var summaryLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = self.app.title
        
        self.imageView = UIImageView()
        self.imageView.layer.cornerRadius = 10
        self.imageView.clipsToBounds = true
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let path = AppDelegate().getDocumentsDirectory().URLByAppendingPathComponent("\(app.key()).png").path!
        if let image = UIImage(contentsOfFile: path)
        {
            self.imageView.image = image
        }
        
        self.scrollView = UIScrollView()
        self.scrollView.backgroundColor = UIColor.whiteColor()
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(imageView)
        
        self.titleLabel = UILabel()
        self.titleLabel.minimumScaleFactor = 0.5
        self.titleLabel.font = UIFont(name: "Futura-Medium", size: 14)
        self.titleLabel.textColor = UIColor.blackColor()
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.text = self.app.title
        self.scrollView.addSubview(self.titleLabel)

        self.artistLabel = UILabel()
        self.artistLabel.minimumScaleFactor = 0.5
        self.artistLabel.font = UIFont(name: "Futura-Medium", size: 13)
        self.artistLabel.textColor = UIColor.darkGrayColor()
        self.artistLabel.translatesAutoresizingMaskIntoConstraints = false
        self.artistLabel.text = self.app.artist
        self.scrollView.addSubview(self.artistLabel)

        
        self.separator = UIView()
        self.separator.translatesAutoresizingMaskIntoConstraints = false
        self.separator.backgroundColor = UIColor(red: 49, green: 163, blue: 114)
        self.scrollView.addSubview(self.separator)
        
        self.summaryLabel = UILabel()
        self.summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        self.summaryLabel.numberOfLines = 0
        self.summaryLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.summaryLabel.text = self.app.summary
        self.summaryLabel.font = UIFont(name: "Futura-Medium", size: 12)
        self.scrollView.addSubview(self.summaryLabel)
        
        self.updateViewConstraints()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()

        let views = ["image" : self.imageView, "scrollView" : self.scrollView, "title" : self.titleLabel, "artist" : self.artistLabel, "separator" : self.separator, "summary" : self.summaryLabel]
        
        var constraints = [NSLayoutConstraint]()
        
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[scrollView]-0-|", options: NSLayoutFormatOptions.DirectionLeftToRight, metrics: nil, views: views))
        
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[scrollView]-0-|", options: NSLayoutFormatOptions.DirectionLeftToRight, metrics: nil, views: views))
        
        self.view.addConstraints(constraints)
        
        constraints.removeAll()
        
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[image(==100)]-10-[title]", options: NSLayoutFormatOptions.DirectionLeftToRight, metrics: nil, views: views))
        
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("H:[image]-10-[artist]-10-|", options: NSLayoutFormatOptions.DirectionLeftToRight, metrics: nil, views: views))
        
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[image(==100)]-15-[separator(==1)]-15-[summary]", options: NSLayoutFormatOptions.DirectionLeftToRight, metrics: nil, views: views))
        
        constraints.appendContentsOf(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[title(==25)]-0-[artist(==25)]", options: NSLayoutFormatOptions.DirectionLeftToRight, metrics: nil, views: views))
        
        self.scrollView.addConstraints(constraints)
        
        constraints.removeAll()
        
        constraints.append(NSLayoutConstraint(item: self.titleLabel, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: -10))
        
        constraints.append(NSLayoutConstraint(item: self.separator, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 0))
        
        constraints.append(NSLayoutConstraint(item: self.separator, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0))
        
        constraints.append(NSLayoutConstraint(item: self.summaryLabel, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Leading, multiplier: 1.0, constant: 10))
        
        constraints.append(NSLayoutConstraint(item: self.summaryLabel, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: -10))
        
        self.view.addConstraints(constraints)
        
        //Update scrollable content
        
        self.scrollView.contentSize = self.view.frame.size
        self.scrollView.contentSize.height = 150 + self.summaryLabel.frame.height

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
