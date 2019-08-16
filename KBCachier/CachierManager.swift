//
//  CachierManager.swift
//  KBCachier
//
//  Created by Keshav Bansal on 15/08/19.
//  Copyright © 2019 kb. All rights reserved.
//

import UIKit

class CachierManager: NSObject {

    public var isInMemoryCacheEnabled: Bool = true
    public var maxCacheSize: Int = 10485760 {
        didSet {
            self.memoryCache.memoryCapacity = maxCacheSize
        }
    }
    public var dispatchQueue = DispatchQueue.global(qos: .userInitiated)
    
    // To run only 10 api call tasks at a time
    let semaphore = DispatchSemaphore(value: 10)

    lazy var memoryCache: URLCache = {
        let cache = URLCache(memoryCapacity: self.maxCacheSize, diskCapacity: 0, diskPath: nil)
        return cache
    }()
    
    lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        let session = URLSession(configuration: config)
        return session
    }()
    
    override init() {
        super.init()
    }
    
    init(enableMemoryCache: Bool, maxCacheSize: Int, dispatchQueue: DispatchQueue) {
        self.isInMemoryCacheEnabled = enableMemoryCache
        self.maxCacheSize = maxCacheSize
        self.dispatchQueue = dispatchQueue
        super.init()
    }

    public func loadData(fromUrl url: URL, completion: @escaping DataCallback, error: ErrorCallback?, taskType: CachierTask.TaskType) -> CachierTask {
        let task = CachierTask(url: url, urlSession: self.urlSession, taskType: taskType)
        if self.isInMemoryCacheEnabled, let data = self.memoryCache.cachedResponse(for: task.request)?.data {
            CachierLogger.printDebug("Found cached response for URL: \(task.urlString)")
            completion(data)
        } else {
            self.dispatchQueue.async {
                self.semaphore.wait()
                task.start(withCompletion: { (data, response) in
                    if self.isInMemoryCacheEnabled {
                        let cacheData = CachedURLResponse(response: response, data: data, userInfo: nil, storagePolicy: .allowedInMemoryOnly)
                        self.memoryCache.storeCachedResponse(cacheData, for: task.request)
                        CachierLogger.printInfo("Current Memory Usage: \(self.memoryCache.currentMemoryUsage)")
                    }
                    self.semaphore.signal()
                    DispatchQueue.main.async {
                        completion(data)
                    }
                }, error: { errorString in
                    self.semaphore.signal()
                    DispatchQueue.main.async {
                        error?(errorString)
                    }
                })
            }
        }
        return task
    }
}
