//
//  DownloadOperation.swift
//  Jill the Jelly
//
//  Created by Pavel Yurevich on 8/29/16.
//  Copyright © 2016 Pavel Yurevich. All rights reserved.
//

import Foundation


class DownloadOperation : Operation {
    let task: URLSessionTask
    let story: Story
    
    init(session: Foundation.URLSession, story: Story) {
        
        task = session.downloadTask(with: story.storyURL)
        print("Downloading \(story.storyURL)")
        self.story = story
        super.init()
    }
    
    override func cancel() {
        task.cancel()
        super.cancel()
    }
    
    override func main() {
        task.resume()
    }
    
    // MARK: NSURLSessionDownloadDelegate methods
    
    func URLSession(_ session: Foundation.URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingToURL location: URL) {
        do {
            let manager = FileManager.default
            let documents = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let destinationURL = documents.appendingPathComponent(downloadTask.originalRequest!.url!.lastPathComponent)
            if manager.fileExists(atPath: destinationURL.path) {
                try manager.removeItem(at: destinationURL)
            }
            try manager.moveItem(at: location, to: destinationURL)
            
            
        } catch {
            print(error)
        }
    }
    
    func URLSession(_ session: Foundation.URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        //print("\(downloadTask.taskIdentifier) \(progress)")
        story.downloadStatus = Float(progress)
    }
    
    // MARK: NSURLSessionTaskDelegate methods
    
    func URLSession(_ session: Foundation.URLSession, task: URLSessionTask, didCompleteWithError error: NSError?) {
        //completeOperation()
        if error != nil {
            print(error)
        }
    }
    
}
