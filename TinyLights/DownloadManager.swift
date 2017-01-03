//
//  DownloadManager.swift
//  Jill the Jelly
//
//  Created by Pavel Yurevich on 8/29/16.
//  Copyright © 2016 Pavel Yurevich. All rights reserved.
//

import Foundation

protocol DownloadManagerDelegate {
    func didUpdate(storyID: Int, progress: Double)
    func didFinishDownload(storyID: Int)
}

/// Manager of asynchronous NSOperation objects

class DownloadManager: NSObject, URLSessionTaskDelegate, URLSessionDownloadDelegate {
    
    /// Dictionary of operations, keyed by the `taskIdentifier` of the `NSURLSessionTask`
    
    static let sharedInstance = DownloadManager()
    var operations = [Int: DownloadOperation]()
    var numOfOperations = 0
    var delegate: DownloadManagerDelegate?
    
    /// Serial NSOperationQueue for downloads
    
    let queue: OperationQueue = {
        let _queue = OperationQueue()
        _queue.name = "download"
        _queue.maxConcurrentOperationCount = 2
        
        return _queue
    }()
    
    /// Delegate-based NSURLSession for DownloadManager
    
    lazy var session: Foundation.URLSession = {
        let sessionConfiguration = URLSessionConfiguration.background(withIdentifier: "backgroundSession")
        return Foundation.URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
    }()
    
    /// Add download
    ///
    /// - parameter URL:  The URL of the file to be downloaded
    ///
    /// - returns:        The DownloadOperation of the operation that was queued
    
    func addDownload(_ story: Story) -> DownloadOperation {
        let operation = DownloadOperation(session: session, story: story)
        print("Operation sees this task - \(operation.task.taskIdentifier)")
        operations[operation.task.taskIdentifier] = operation
        queue.addOperation(operation)
        numOfOperations += 1
        return operation
    }
    
    /// Cancel all queued operations
    
    func cancelAll() {
        queue.cancelAllOperations()
    }
    
    // MARK: NSURLSessionDownloadDelegate methods
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        operations[downloadTask.taskIdentifier]?.URLSession(session, downloadTask: downloadTask, didFinishDownloadingToURL: location)
        print("Taskidentifier - \(String(describing: downloadTask.taskIdentifier))")
        let storyIndex =  operations[downloadTask.taskIdentifier]!.story.index
        delegate!.didFinishDownload(storyID: storyIndex)
        numOfOperations -= 1
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        operations[downloadTask.taskIdentifier]?.URLSession(session, downloadTask: downloadTask, didWriteData: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
        delegate!.didUpdate(storyID: operations[downloadTask.taskIdentifier]!.story.index, progress: Double(totalBytesWritten) / Double(totalBytesExpectedToWrite))
    }
    
    // MARK: NSURLSessionTaskDelegate methods
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        let key = task.taskIdentifier
        operations[key]?.URLSession(session, task: task, didCompleteWithError: error as NSError?)
        operations.removeValue(forKey: key)
    }
    
}
