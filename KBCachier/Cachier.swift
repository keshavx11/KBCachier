//
//  Cachier.swift
//  KBCachier
//
//  Created by Keshav Bansal on 12/08/19.
//  Copyright © 2019 kb. All rights reserved.
//

import Foundation

public typealias DataCallback = ((Data) -> ())
public typealias ImageCallback = ((UIImage) -> ())
public typealias ErrorCallback = ((String) -> ())
public typealias SuccessCallback = ((Bool) -> ())

public class Cachier: NSObject {
    
    public static let shared = Cachier()
    
    /* Whether or not to use memory cache. Defaults to true. */
    public var isInMemoryCacheEnabled: Bool = true {
        didSet {
            self.manager.isInMemoryCacheEnabled = isInMemoryCacheEnabled
        }
    }
    
    /* Max size of memory cache in bytes. oldest used images will be auto-purged beyond this limit. Defaults to 10 MB */
    public var maxCacheSize: Int = 10485760 {
        didSet {
            self.manager.maxCacheSize = maxCacheSize
        }
    }
    
    // Thread for making api calls. Can be customized by the developer. Defaults to global
    public var dispatchQueue = DispatchQueue.global(qos: .userInitiated) {
        didSet {
            self.manager.dispatchQueue = dispatchQueue
        }
    }
    
    /* Set log level */
    public var logLevel: CachierLoggerLevel = .warning {
        didSet {
            CachierLogger.logger.minLevel = logLevel
        }
    }
    
    lazy var manager: CachierManager = {
        let cachierManager = CachierManager(enableMemoryCache: isInMemoryCacheEnabled, maxCacheSize: maxCacheSize, dispatchQueue: dispatchQueue)
        return cachierManager
    }()
    
    func loadData(fromUrl url: String, completion: @escaping DataCallback, error: ErrorCallback?, taskType: CachierTask.TaskType) -> CachierTask? {
        guard let resourceURL = URL(string: url) else {
            error?("Please pass a valid URL")
            CachierLogger.printError("No URL passed for request")
            return nil
        }
        return self.manager.loadData(fromUrl: resourceURL, completion: completion, error: error, taskType: taskType)
    }
    
    // Generic function to download any type of data
    public func loadData(fromUrl url: String, completion: @escaping DataCallback, error: ErrorCallback?) -> CachierTask? {
        return self.loadData(fromUrl: url, completion: completion, error: error, taskType: .data)
    }
    
    // Generic function to download Images.
    public func downloadImage(fromUrl url: String, completion: @escaping ImageCallback, error: ErrorCallback?) -> CachierTask? {
        return self.loadData(fromUrl: url, completion: { (imageData) in
            if let image = UIImage(data: imageData) {
                completion(image)
            } else {
                error?("Failed to convert data to image")
            }
        }, error: error, taskType: .download)
    }
    
    // func gets JSON data and maps it to an object confirming to Codable.
    public func fetchJSONData<A: Codable>(forUrl url: String, completion: @escaping (A) -> Void, error: ErrorCallback?) {
        _ = self.loadData(fromUrl: url, completion: { (data) in
            do {
                let objects = try JSONDecoder().decode(A.self, from: data)
                completion(objects)
            } catch let jsonErr {
                CachierLogger.printError("Failed to decode json: \(jsonErr)")
                error?("Failed to decode json: \(jsonErr)")
            }
        }, error: error, taskType: .data)
    }
}
