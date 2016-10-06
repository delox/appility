//
//  GrappilityBackendManager.swift
//  GrAPPility
//
//  Created by Jose Solorzano on 10/5/16.
//  Copyright © 2016 Jose Solorzano. All rights reserved.
//

import Foundation
import Alamofire
import JLToast

class AppilityBackendManager {
    
    static let endPoint = "https://itunes.apple.com/us/rss/topfreeapplications/limit=*/json"
    static let fetchLimit = 20
    static let sharedManager = AppilityBackendManager()
    
    private init() {} //evito que usen el default initializer
    static func constructedEndPointURL() -> String
    {
        return AppilityBackendManager.endPoint.stringByReplacingOccurrencesOfString("*", withString: String(AppilityBackendManager.fetchLimit))
    }
    
    func fetchTopFreeApps(completion: (result : JSON) -> Void)
    {
        NSURLCache.sharedURLCache().removeAllCachedResponses()

        Alamofire.request(Method.GET, AppilityBackendManager.constructedEndPointURL())
            .responseJSON
            { response in
                
                guard response.result.error == nil else {
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        JLToast.makeText("Appility is OFFLINE", duration: JLToastDelay.LongDelay).show()
                    })
                    
                    return;
                }
                
                if let value = response.result.value
                {                    
                    let jsonValue = JSON(value)
                    let feedEntries = jsonValue["feed"]["entry"]
                    completion(result: feedEntries)
                }
        }
    }
    
    func fetchImage(url : String, completion: (result : UIImage) -> Void)
    {
        Alamofire.request(Method.GET, url)
            .responseData { (response) -> Void in
                guard response.result.error == nil
                    else { return }
                
                if let result = response.result.value
                {
                    if let image = UIImage(data: result)
                    {
                        completion(result: image)
                    }
                }
        }
        
    }
}