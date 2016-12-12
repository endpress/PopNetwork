//
//  SessionDelegate.swift
//  PopNetwork
//
//  Created by apple on 12/8/16.
//  Copyright © 2016 zsc. All rights reserved.
//

import Foundation

/// handling all delegate callbacks.
class SessionDelegate: NSObject {
    
    /// A default instance of `SessionDelegate`.
    static let `default` = SessionDelegate()
    
    fileprivate var responses = [Int: Response]()
    private let lock = NSLock()
    
    subscript(task: URLSessionTask) -> Response? {
        get {
            lock.lock(); defer { lock.unlock() }
            return responses[task.taskIdentifier]
        }
        set {
            lock.lock(); defer { lock.unlock() }
            responses[task.taskIdentifier] = newValue
        }
    }
}

// MARK: - URLSessionDelegate
extension SessionDelegate: URLSessionDelegate {
    /// Tells the delegate that the session has been invalidated.
    ///
    /// - parameter session: The session object that was invalidated.
    /// - parameter error:   The error that caused invalidation, or nil if the invalidation was explicit.
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        
    }
    
    /// Requests credentials from the delegate in response to a session-level authentication request from the
    /// remote server.
    ///
    /// - parameter session:           The session containing the task that requested authentication.
    /// - parameter challenge:         An object that contains the request for authentication.
    /// - parameter completionHandler: A handler that your delegate method must call providing the disposition
    ///                                and credential.
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
                                                     completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential: URLCredential?
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                disposition = .useCredential
                credential = URLCredential(trust: serverTrust)
            } else {
                disposition = .cancelAuthenticationChallenge
            }
        }
        completionHandler(disposition, credential)
    }
    
    #if !os(macOS)
    /// Tells the delegate that all messages enqueued for a session have been delivered.
    ///
    /// - parameter session: The session that no longer has any outstanding requests.
    public func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
    }
    #endif
}

//MARK: - URLSessionTaskDelegate
extension SessionDelegate: URLSessionTaskDelegate {
    /// Tells the delegate that the remote server requested an HTTP redirect.
    ///
    /// - parameter session:           The session containing the task whose request resulted in a redirect.
    /// - parameter task:              The task whose request resulted in a redirect.
    /// - parameter response:          An object containing the server’s response to the original request.
    /// - parameter request:           A URL request object filled out with the new location.
    /// - parameter completionHandler: A closure that your handler should call with either the value of the request
    ///                                parameter, a modified URL request object, or NULL to refuse the redirect and
    ///                                return the body of the redirect response.
    open func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        willPerformHTTPRedirection response: HTTPURLResponse,
        newRequest request: URLRequest,
        completionHandler: @escaping (URLRequest?) -> Void)
    {
        completionHandler(nil)
    }
    
    /// Requests credentials from the delegate in response to an authentication request from the remote server.
    ///
    /// - parameter session:           The session containing the task whose request requires authentication.
    /// - parameter task:              The task whose request requires authentication.
    /// - parameter challenge:         An object that contains the request for authentication.
    /// - parameter completionHandler: A handler that your delegate method must call providing the disposition
    ///                                and credential.
    open func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didReceive challenge: URLAuthenticationChallenge,
        completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)
    {
        var disposition: URLSession.AuthChallengeDisposition = .performDefaultHandling
        var credential: URLCredential?
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                disposition = .useCredential
                credential = URLCredential(trust: serverTrust)
            } else {
                disposition = .cancelAuthenticationChallenge
            }
        }
        completionHandler(disposition, credential)
    }
    
    /// Tells the delegate when a task requires a new request body stream to send to the remote server.
    ///
    /// - parameter session:           The session containing the task that needs a new body stream.
    /// - parameter task:              The task that needs a new body stream.
    /// - parameter completionHandler: A completion handler that your delegate method should call with the new body stream.
    open func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        needNewBodyStream completionHandler: @escaping (InputStream?) -> Void)
    {

    }
    
    /// Periodically informs the delegate of the progress of sending body content to the server.
    ///
    /// - parameter session:                  The session containing the data task.
    /// - parameter task:                     The data task.
    /// - parameter bytesSent:                The number of bytes sent since the last time this delegate method was called.
    /// - parameter totalBytesSent:           The total number of bytes sent so far.
    /// - parameter totalBytesExpectedToSend: The expected length of the body data.
    open func urlSession(
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64)
    {
    }
    
    #if !os(watchOS)
    
    /// Tells the delegate that the session finished collecting metrics for the task.
    ///
    /// - parameter session: The session collecting the metrics.
    /// - parameter task:    The task whose metrics have been collected.
    /// - parameter metrics: The collected metrics.
    @available(iOS 10.0, macOS 10.12, tvOS 10.0, *)
    open func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
    }
    
    #endif
    
    /// Tells the delegate that the task finished transferring data.
    ///
    /// - parameter session: The session containing the task whose request finished transferring data.
    /// - parameter task:    The task whose request finished transferring data.
    /// - parameter error:   If an error occurred, an error object indicating how the transfer failed, otherwise nil.
    open func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if let response = self[task], let dataHandler = response.dataHandler {
            if let _ = error {
                dataHandler(Result.Faliure(error: PopError.error(reason: "faliure")))
                return
            }
            dataHandler(Result.Success(result: response.data!))
        }
    }
}

//MARK: - URLSessionDataDelegate

extension SessionDelegate: URLSessionDataDelegate {
    /// Tells the delegate that the data task received the initial reply (headers) from the server.
    ///
    /// - parameter session:           The session containing the data task that received an initial reply.
    /// - parameter dataTask:          The data task that received an initial reply.
    /// - parameter response:          A URL response object populated with headers.
    /// - parameter completionHandler: A completion handler that your code calls to continue the transfer, passing a
    ///                                constant to indicate whether the transfer should continue as a data task or
    ///                                should become a download task.
    open func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didReceive response: URLResponse,
        completionHandler: @escaping (URLSession.ResponseDisposition) -> Void)
    {
        
        let disposition: URLSession.ResponseDisposition = .allow
        
        if var resp = self[dataTask] {
            resp.response = response as? HTTPURLResponse
            self[dataTask] = resp
        }
        
        completionHandler(disposition)
    }
    
    /// Tells the delegate that the data task was changed to a download task.
    ///
    /// - parameter session:      The session containing the task that was replaced by a download task.
    /// - parameter dataTask:     The data task that was replaced by a download task.
    /// - parameter downloadTask: The new download task that replaced the data task.
    open func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        didBecome downloadTask: URLSessionDownloadTask)
    {
    }
    
    /// Tells the delegate that the data task has received some of the expected data.
    ///
    /// - parameter session:  The session containing the data task that provided data.
    /// - parameter dataTask: The data task that provided data.
    /// - parameter data:     A data object containing the transferred data.
    open func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if var response = self[dataTask] {
            response.data?.append(data)
            self[dataTask] = response
        }
    }
    
    /// Asks the delegate whether the data (or upload) task should store the response in the cache.
    ///
    /// - parameter session:           The session containing the data (or upload) task.
    /// - parameter dataTask:          The data (or upload) task.
    /// - parameter proposedResponse:  The default caching behavior. This behavior is determined based on the current
    ///                                caching policy and the values of certain received headers, such as the Pragma
    ///                                and Cache-Control headers.
    /// - parameter completionHandler: A block that your handler must call, providing either the original proposed
    ///                                response, a modified version of that response, or NULL to prevent caching the
    ///                                response. If your delegate implements this method, it must call this completion
    ///                                handler; otherwise, your app leaks memory.
    open func urlSession(
        _ session: URLSession,
        dataTask: URLSessionDataTask,
        willCacheResponse proposedResponse: CachedURLResponse,
        completionHandler: @escaping (CachedURLResponse?) -> Void)
    {
        completionHandler(proposedResponse)
    }
}

// MARK: - URLSessionDownloadDelegate

extension SessionDelegate: URLSessionDownloadDelegate {
    /// Tells the delegate that a download task has finished downloading.
    ///
    /// - parameter session:      The session containing the download task that finished.
    /// - parameter downloadTask: The download task that finished.
    /// - parameter location:     A file URL for the temporary file. Because the file is temporary, you must either
    ///                           open the file for reading or move it to a permanent location in your app’s sandbox
    ///                           container directory before returning from this delegate method.
    open func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL)
    {
        
    }
    
    /// Periodically informs the delegate about the download’s progress.
    ///
    /// - parameter session:                   The session containing the download task.
    /// - parameter downloadTask:              The download task.
    /// - parameter bytesWritten:              The number of bytes transferred since the last time this delegate
    ///                                        method was called.
    /// - parameter totalBytesWritten:         The total number of bytes transferred so far.
    /// - parameter totalBytesExpectedToWrite: The expected length of the file, as provided by the Content-Length
    ///                                        header. If this header was not provided, the value is
    ///                                        `NSURLSessionTransferSizeUnknown`.
    open func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64)
    {
        
    }
    
    /// Tells the delegate that the download task has resumed downloading.
    ///
    /// - parameter session:            The session containing the download task that finished.
    /// - parameter downloadTask:       The download task that resumed. See explanation in the discussion.
    /// - parameter fileOffset:         If the file's cache policy or last modified date prevents reuse of the
    ///                                 existing content, then this value is zero. Otherwise, this value is an
    ///                                 integer representing the number of bytes on disk that do not need to be
    ///                                 retrieved again.
    /// - parameter expectedTotalBytes: The expected length of the file, as provided by the Content-Length header.
    ///                                 If this header was not provided, the value is NSURLSessionTransferSizeUnknown.
    open func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didResumeAtOffset fileOffset: Int64,
        expectedTotalBytes: Int64)
    {
       
    }
}

// MARK: - URLSessionStreamDelegate

#if !os(watchOS)
    
    @available(iOS 9.0, macOS 10.11, tvOS 9.0, *)
    extension SessionDelegate: URLSessionStreamDelegate {
        /// Tells the delegate that the read side of the connection has been closed.
        ///
        /// - parameter session:    The session.
        /// - parameter streamTask: The stream task.
        open func urlSession(_ session: URLSession, readClosedFor streamTask: URLSessionStreamTask) {
            
        }
        
        /// Tells the delegate that the write side of the connection has been closed.
        ///
        /// - parameter session:    The session.
        /// - parameter streamTask: The stream task.
        open func urlSession(_ session: URLSession, writeClosedFor streamTask: URLSessionStreamTask) {
            
        }
        
        /// Tells the delegate that the system has determined that a better route to the host is available.
        ///
        /// - parameter session:    The session.
        /// - parameter streamTask: The stream task.
        open func urlSession(_ session: URLSession, betterRouteDiscoveredFor streamTask: URLSessionStreamTask) {
            
        }
        
        /// Tells the delegate that the stream task has been completed and provides the unopened stream objects.
        ///
        /// - parameter session:      The session.
        /// - parameter streamTask:   The stream task.
        /// - parameter inputStream:  The new input stream.
        /// - parameter outputStream: The new output stream.
        open func urlSession(
            _ session: URLSession,
            streamTask: URLSessionStreamTask,
            didBecome inputStream: InputStream,
            outputStream: OutputStream)
        {
            
        }
    }
    
#endif

