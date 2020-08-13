//
//  VtnDownloadModel.swift
//  FileDownloader
//
//  Created by Good on 13/08/20.
//  Copyright © 2020 Victoria Hawkins. All rights reserved.
//

import UIKit

public enum VtnTaskStatusV2: Int {
    case unknown, gettingInfo, downloading, paused, failed
    
    public func description() -> String {
        switch self {
        case .gettingInfo:
            return "GettingInfo"
        case .downloading:
            return "Downloading"
        case .paused:
            return "Paused"
        case .failed:
            return "Failed"
        default:
            return "Unknown"
        }
    }
}

open class VtnDownloadModelV2: NSObject {

    open var fileName: String!
    open var fileURL: String!
    open var status: String = VtnTaskStatusV2.gettingInfo.description()
    open var progress: Float = 0
    open var task: URLSessionDownloadTask?
    open var videoID: String!
    open var userID: String!
    
    fileprivate(set) open var destinationPath: String = ""
    
    fileprivate convenience init(fileName: String, fileURL: String,userID:String,videoID:String) {
        self.init()
        
        self.fileName = fileName
        self.fileURL = fileURL
        self.userID = userID
        self.videoID = videoID
    }
    
    convenience init(fileName: String, fileURL: String, destinationPath: String,userID:String,videoID :String) {
        self.init(fileName: fileName, fileURL: fileURL,userID:userID,videoID:videoID)
        self.destinationPath = destinationPath
    }
    
}
