//
//  CustomURLCache.swift
//  Rotten Tomatoes
//
//  Created by Dang Quoc Huy on 6/9/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//
//  Ref: http://stackoverflow.com/questions/19840688/bypassing-http-response-header-cache-control-how-to-set-cache-expiration
//

import Foundation

class CustomURLCache: NSURLCache {
    
    // UserInfo expires key
    let kUrlCacheExpiresKey = "CacheData";
    // How long is cache data valid in seconds
    let kCacheExpireInterval: NSTimeInterval = 60*60*24*5;
    
    // get cache response for a request
    override func cachedResponseForRequest(request:NSURLRequest) -> NSCachedURLResponse? {
        // create empty response
        var response:NSCachedURLResponse? = nil
        
        // try to get cache response
        if let cachedResponse = super.cachedResponseForRequest(request) {
            
            // try to get userInfo
            if let userInfo = cachedResponse.userInfo {
                
                // get cache date
                if let cacheDate = userInfo[kUrlCacheExpiresKey] as! NSDate? {
                    
                    // check if the cache data are expired
                    if (cacheDate.timeIntervalSinceNow < -kCacheExpireInterval) {
                        // remove old cache request
                        self.removeCachedResponseForRequest(request);
                    } else {
                        // the cache request is still valid
                        response = cachedResponse
                    }
                }
            }
        }
        
        return response;
    }
    
    // store cached response
    override func storeCachedResponse(cachedResponse: NSCachedURLResponse, forRequest: NSURLRequest) {
        // create userInfo dictionary
        var userInfo = NSMutableDictionary()
        if let cachedUserInfo = cachedResponse.userInfo {
            userInfo = NSMutableDictionary(dictionary:cachedUserInfo)
        }
        // add current date to the UserInfo
        userInfo[kUrlCacheExpiresKey] = NSDate()
        
        // create new cached response
        let newCachedResponse = NSCachedURLResponse(response: cachedResponse.response, data: cachedResponse.data, userInfo: userInfo as [NSObject : AnyObject], storagePolicy: cachedResponse.storagePolicy)
        super.storeCachedResponse(newCachedResponse, forRequest:forRequest)
    }
}