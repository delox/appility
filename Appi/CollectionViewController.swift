//
//  CollectionViewController.swift
//  Appi
//
//  Created by Jose Solorzano on 10/5/16.
//  Copyright © 2016 Jose Solorzano. All rights reserved.
//

import UIKit
import CoreData
import AMScrollingNavbar
import RevealingSplashView

private let reuseIdentifier = "appView"

class CollectionViewController: UICollectionViewController, NSFetchedResultsControllerDelegate {

    var images = [String : UIImage]()
    let moc = AppDelegate().managedObjectContext
    var resultsController : NSFetchedResultsController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let request = NSFetchRequest(entityName: "App")
        request.sortDescriptors = [NSSortDescriptor(key: "releaseDate", ascending: false)]
        
        self.resultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.moc, sectionNameKeyPath: nil, cacheName: nil)
        
        self.resultsController.delegate = self

        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        let revealingSplashView = RevealingSplashView(iconImage: UIImage(named: "appility")!,iconInitialSize: CGSizeMake(240, 128), backgroundColor: UIColor(red: 49, green: 163, blue: 114))
        
        self.view.addSubview(revealingSplashView)
        
        revealingSplashView.startAnimation(){
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.title = "Top 20 free apps"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu-icon"), style: .Plain, target: self, action: Selector("showFilters"))
        
        self.fetchFromServer()
        self.fetchFromLocal()
    }
    
    func showFilters()
    {
        let sheet = UIAlertController(title: "Choose a filter", message: nil, preferredStyle: .ActionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        sheet.addAction(UIAlertAction(title: "Sort by app name", style: .Default, handler: { (alert) -> Void in
            
            self.resultsController.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            self.fetchFromLocal()
        }))
        
        sheet.addAction(UIAlertAction(title: "Sort by developer", style: .Default, handler: { (alert) -> Void in
            
            self.resultsController.fetchRequest.sortDescriptors = [NSSortDescriptor(key: "artist", ascending: true)]
            self.fetchFromLocal()
        }))
        
        sheet.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        self.presentViewController(sheet, animated: true, completion: nil)
    }

    
    func fetchFromServer()
    {
        AppilityBackendManager.sharedManager.fetchTopFreeApps { (result) -> Void in
            
            let appsJson = result.arrayValue
            
            for appJson in appsJson
            {
                let app = NSEntityDescription.insertNewObjectForEntityForName("App", inManagedObjectContext: self.moc) as! App
                
                app.title = appJson["im:name"]["label"].stringValue
                app.category = appJson["category"]["attributes"]["label"].stringValue
                app.releaseDate = appJson["im:releaseDate"]["attributes"]["label"].stringValue
                app.image = appJson["im:image"].arrayValue.last!["label"].stringValue
                app.artist = appJson["im:artist"]["label"].stringValue
                app.summary = appJson["summary"]["label"].stringValue
            }
            
            do {
                try self.moc.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
            
            self.fetchFromLocal()
        }

    }
    
    func fetchFromLocal()
    {
        
        do {
            try self.resultsController.performFetch()
        } catch {
            fatalError("Failed to fetch person: \(error)")
        }
        
        self.collectionView!.reloadData()
    }
    
    func downloadAndSaveImage(forApp app : App)
    {
        AppilityBackendManager.sharedManager.fetchImage(app.image, completion: { (result : UIImage) -> Void in
            
            if let data = UIImagePNGRepresentation(result) {
                
                let filename = AppDelegate().getDocumentsDirectory().URLByAppendingPathComponent("\(app.key()).png")
                try! data.writeToFile(filename.path!, options: NSDataWritingOptions.DataWritingFileProtectionNone)
                
            }
            self.collectionView!.reloadData()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navigationController = navigationController as? ScrollingNavigationController {
            navigationController.followScrollView(collectionView!, delay: 50.0)
        }
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let sections = self.resultsController.sections
        {
            let info = sections[section]
            return info.numberOfObjects
        }
        else
        {
            return 0
        }
        
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! AppView
        
        let app = self.resultsController.objectAtIndexPath(indexPath) as! App
        let path = AppDelegate().getDocumentsDirectory().URLByAppendingPathComponent("\(app.key()).png").path!
        
        cell.configureWithApp(app)
        
        if let image = UIImage(contentsOfFile: path)
        {
            cell.configureWithImage(image)
        }
        else
        {
            cell.configureWithImage(UIImage())
            self.downloadAndSaveImage(forApp: app)
        }

        return cell
    }
    
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let controller = DetailsViewController()
        controller.app = self.resultsController.objectAtIndexPath(indexPath) as! App
        self.navigationController!.pushViewController(controller, animated: true)

    }
}
