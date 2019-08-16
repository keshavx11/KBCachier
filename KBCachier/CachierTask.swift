//
//  CachierRequestManager.swift
//  KBCachier
//
//  Created by Keshav Bansal on 15/08/19.
//  Copyright © 2019 kb. All rights reserved.
//

import UIKit

public typealias ResponseDataCallback = ((_ data: Data, _ response: URLResponse) -> ())

public class CachierTask: NSObject {

    public enum TaskType {
        case data
        case download
    }
    
    /// The request sent or to be sent to the server.
    open var request: URLRequest!
    
    var urlSession: URLSession!
    
    open var taskType: TaskType = .data
    
    var dataTask: URLSessionDataTask?
    
    // The request URL.
    open var url: URL? {
        return self.request?.url
    }
    
    open var urlString: String {
        return self.url?.absoluteString ?? "Unknown"
    }
    
    var isCancelled: Bool = false
    
    var completion: ResponseDataCallback?
    var error: ErrorCallback?
    
    init(url: URL, urlSession: URLSession, taskType: TaskType) {
        self.request = URLRequest(url: url)
        self.taskType = taskType
        self.urlSession = urlSession
    }
    
    func start(withCompletion completion: ResponseDataCallback?, error: ErrorCallback?) {
        self.completion = completion
        self.error = error
        self.start()
    }

    func start() {
        if self.isCancelled {
            self.error?("Task cancelled")
            return
        }
        CachierLogger.printDebug("Fetching response for URL: \(self.urlString)")
        self.dataTask = self.urlSession.dataTask(with: self.request, completionHandler: { (data, response, error) in
            if let data = data, let response = response, error == nil {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
                if statusCode == 200 {
                    // API success
                    CachierLogger.printDebug("Success getting response for URL: \(self.urlString)")
                    self.completion?(data, response)
                } else {
                    self.error?("Unable to load resource for URL: \(self.urlString). Status Code \(statusCode)")
                }
            } else if let error = error {
                self.error?(error.localizedDescription)
            } else {
                self.error?("Unable to load resource for URL: \(self.urlString)")
            }
        })
        self.dataTask?.resume()
    }
    
    public func cancel() {
        if let task = self.dataTask {
            task.cancel()
        } else {
            self.isCancelled = true
        }
    }
    
}
