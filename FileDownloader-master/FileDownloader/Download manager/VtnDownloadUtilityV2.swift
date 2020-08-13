//
//  VtnUtility.swift
//  FileDownloader
//
//  Created by Good on 13/08/20.
//  Copyright © 2020 Victoria Hawkins. All rights reserved.
//

import UIKit

open class VtnDownloadUtilityV2: NSObject {

    @objc public static let DownloadCompletedNotif: String = {
           return "com.VtnDownloadManager.DownloadCompletedNotif"
       }()
       
       @objc public static let baseFilePath: String = {
           return (NSHomeDirectory() as NSString).appendingPathComponent("Documents") as String
       }()
    
    @objc public class func getUniqueFileNameWithPath(_ filePath : NSString) -> NSString {
        let fullFileName        : NSString = filePath.lastPathComponent as NSString
        let fileName            : NSString = fullFileName.deletingPathExtension as NSString
        let fileExtension       : NSString = fullFileName.pathExtension as NSString
        var suggestedFileName   : NSString = fileName
        
        var isUnique            : Bool = false
        var fileNumber          : Int = 0
        
        let fileManger          : FileManager = FileManager.default
        
        repeat {
            var fileDocDirectoryPath : NSString?
            
            if fileExtension.length > 0 {
                fileDocDirectoryPath = "\(filePath.deletingLastPathComponent)/\(suggestedFileName).\(fileExtension)" as NSString?
            } else {
                fileDocDirectoryPath = "\(filePath.deletingLastPathComponent)/\(suggestedFileName)" as NSString?
            }
            
            let isFileAlreadyExists : Bool = fileManger.fileExists(atPath: fileDocDirectoryPath! as String)
            
            if isFileAlreadyExists {
                fileNumber += 1
                suggestedFileName = "\(fileName)(\(fileNumber))" as NSString
            } else {
                isUnique = true
                if fileExtension.length > 0 {
                    suggestedFileName = "\(suggestedFileName).\(fileExtension)" as NSString
                }
            }
        
        } while isUnique == false
        
        return suggestedFileName
    }
 
}
