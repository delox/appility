//
//  App.swift
//  Appi
//
//  Created by Jose Solorzano on 10/5/16.
//  Copyright © 2016 Jose Solorzano. All rights reserved.
//

import Foundation
import CoreData

class App: NSManagedObject {

    func key() -> String
    {
        return self.title.stringByReplacingOccurrencesOfString(" ", withString: "")
    }
// Insert code here to add functionality to your managed object subclass

}
