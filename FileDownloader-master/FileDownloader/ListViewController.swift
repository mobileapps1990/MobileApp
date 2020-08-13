//
//  ListViewController.swift
//  FileDownloader
//
//  Created by Good on 13/08/20.
//  Copyright © 2020 Victoria Hawkins. All rights reserved.
//

import UIKit

let movieURL = "https://v2s3z9v2.stackpathcdn.com/videos/2591/04-02-2019/utube_chicken_kurma__GLR6SCPE.mp4"


class ListViewController: UIViewController {
    
    var mDownloadingViewObj  : VtnDownloadingVC?
    let myDownloadPath = VtnDownloadUtilityV2.baseFilePath + "/My Downloads"
    @IBOutlet weak var downloadBtn: UIButton!
    var downloadedFilesArray : [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpDownloadingViewController()
        
         do {
             let contentOfDir: [String] = try FileManager.default.contentsOfDirectory(atPath: VtnDownloadUtilityV2.baseFilePath as String)
             downloadedFilesArray.append(contentsOf: contentOfDir)
             let index = downloadedFilesArray.firstIndex(of: ".DS_Store")
             if let index = index {
                 downloadedFilesArray.remove(at: index)
             }
             if downloadedFilesArray.count > 0 {
                 self.downloadBtn.isEnabled = false
                 self.downloadBtn.alpha = 0.5
             }
             print(downloadedFilesArray)
         } catch let error as NSError {
             print("Error while getting directory content \(error)")
         }
        
         NotificationCenter.default.addObserver(self, selector: #selector(downloadFinishedNotification(_:)), name: NSNotification.Name(rawValue: VtnDownloadUtilityV2.DownloadCompletedNotif as String), object: nil)
        // Do any additional setup after loading the view.
    }
    
    func removeExistingFiles() {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            for file in fileURLs {
                debugPrint("Removing file found at \(file)")
                try FileManager.default.removeItem(at: file)
            }
        } catch {
            debugPrint("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
    
    @IBAction func deleteDownload(_ sender: UIButton) {
        self.removeExistingFiles()
        self.downloadBtn.isEnabled = true
        self.downloadBtn.alpha = 1
    }
    
    
    @IBAction func startDownload(_ sender: UIButton) {
        self.downloadBtn.alpha = 0.5
        let fileURL  : NSString = movieURL as NSString
        var fileName : NSString = fileURL.lastPathComponent as NSString
        fileName = VtnDownloadUtilityV2.getUniqueFileNameWithPath((myDownloadPath as NSString).appendingPathComponent(fileName as String) as NSString)
        mDownloadingViewObj?.downloadManager.addDownloadTask(fileName as String, fileURL: fileURL as String, destinationPath: myDownloadPath)
    }
    
    @objc func downloadFinishedNotification(_ notification : Notification) {
         let fileName : NSString = notification.object as! NSString
         downloadedFilesArray.append(fileName.lastPathComponent)
         print(downloadedFilesArray)
        if downloadedFilesArray.count > 0 {
            self.downloadBtn.isEnabled = false
            self.downloadBtn.alpha = 0.5
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    func setUpDownloadingViewController() {
        let tabBarTabs : NSArray? = self.tabBarController?.viewControllers as NSArray?
        let mzDownloadingNav : UINavigationController = tabBarTabs?.object(at: 1) as! UINavigationController
        mDownloadingViewObj = mzDownloadingNav.viewControllers[0] as? VtnDownloadingVC
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
