//
//  App+CoreDataProperties.swift
//  Appi
//
//  Created by Jose Solorzano on 10/4/16.
//  Copyright © 2016 Jose Solorzano. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension App {

    @NSManaged var title: String?
    @NSManaged var summary: String?
    @NSManaged var category: String?
    @NSManaged var releaseDate: String?
    @NSManaged var artist: String?
    @NSManaged var image: String?

}
