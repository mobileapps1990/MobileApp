//
//  VtnDownloadingVC.swift
//  FileDownloader
//
//  Created by Good on 13/08/20.
//  Copyright © 2020 Victoria Hawkins. All rights reserved.
//

import UIKit

let alertControllerViewTag: Int = 500


class VtnDownloadingVC: UIViewController {

    var selectedIndexPath : IndexPath!
    @IBOutlet weak var tableView: UITableView?

    lazy var downloadManager: VtnDownloadManagerV2 = {
        [unowned self] in
        let sessionIdentifer: String = "com.iosDevelopment.VtnDownloadManager.BackgroundSession"
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var completion = appDelegate.backgroundSessionCompletionHandler
        
        let downloadmanager = VtnDownloadManagerV2(session: sessionIdentifer, delegate: self, completion: completion)
        return downloadmanager
        }()
    
    var downObject : VtnDownloadManagerV2?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    func loadObject () -> VtnDownloadManagerV2 {
        let sessionIdentifer: String = "com.iosDevelopment.VtnDownloadManager.BackgroundSession"
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let completion = appDelegate.backgroundSessionCompletionHandler
        let downloadmanager = VtnDownloadManagerV2(session: sessionIdentifer, delegate: self, completion: completion)
        return downloadmanager
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.downObject = downloadManager
//        let check = downloadManager.downloadingArray
//        print(check[0].userID)
        
       // self.downObject = self.loadObject()
    }
    
    func refreshCellForIndex(_ downloadModel: VtnDownloadModelV2, index: Int) {
        let indexPath = IndexPath.init(row: index, section: 0)
        let cell = self.tableView?.cellForRow(at: indexPath)
        if let cell = cell {
            let downloadCell = cell as! VtnDownloadingcell
            downloadCell.updateCellForRowAtIndexPath(indexPath, downloadModel: downloadModel)
        }
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

// MARK: UITableViewDatasource Handler Extension

extension VtnDownloadingVC : UITableViewDelegate ,UITableViewDataSource {
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downObject?.downloadingArray.count ?? 0
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier : NSString = "VtnDownloadingcell"
        let cell : VtnDownloadingcell = self.tableView?.dequeueReusableCell(withIdentifier: cellIdentifier as String, for: indexPath) as! VtnDownloadingcell
        
        let downloadModel = (downObject?.downloadingArray[indexPath.row])!
        cell.updateCellForRowAtIndexPath(indexPath, downloadModel: downloadModel)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         selectedIndexPath = indexPath
         let downloadModel = downObject?.downloadingArray[indexPath.row]
        self.showAppropriateActionController(downloadModel!.status)
         tableView.deselectRow(at: indexPath, animated: true)
     }
}

// MARK: UIAlertController Handler Extension

extension VtnDownloadingVC {
    
    func showAppropriateActionController(_ requestStatus: String) {
        
        if requestStatus == VtnTaskStatusV2.downloading.description() {
            self.showAlertControllerForPause()
        } else if requestStatus == VtnTaskStatusV2.failed.description() {
            self.showAlertControllerForRetry()
        } else if requestStatus == VtnTaskStatusV2.paused.description() {
            self.showAlertControllerForStart()
        }
    }
    
    func showAlertControllerForPause() {
        
        let pauseAction = UIAlertAction(title: "Pause", style: .default) { (alertAction: UIAlertAction) in
            self.downloadManager.pauseDownloadTaskAtIndex(self.selectedIndexPath.row)
        }
        
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (alertAction: UIAlertAction) in
            self.downloadManager.cancelTaskAtIndex(self.selectedIndexPath.row)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tag = alertControllerViewTag
        alertController.addAction(pauseAction)
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertControllerForRetry() {
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { (alertAction: UIAlertAction) in
            self.downloadManager.retryDownloadTaskAtIndex(self.selectedIndexPath.row)
        }
        
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (alertAction: UIAlertAction) in
            self.downloadManager.cancelTaskAtIndex(self.selectedIndexPath.row)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tag = alertControllerViewTag
        alertController.addAction(retryAction)
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertControllerForStart() {
        
        let startAction = UIAlertAction(title: "Start", style: .default) { (alertAction: UIAlertAction) in
            self.downloadManager.resumeDownloadTaskAtIndex(self.selectedIndexPath.row)
        }
        
        let removeAction = UIAlertAction(title: "Remove", style: .destructive) { (alertAction: UIAlertAction) in
            self.downloadManager.cancelTaskAtIndex(self.selectedIndexPath.row)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tag = alertControllerViewTag
        alertController.addAction(startAction)
        alertController.addAction(removeAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func safelyDismissAlertController() {
        /***** E.g App will eventually crash if download is completed and user tap remove *****/
        /***** As it was already removed from the array *****/
        if let controller = self.presentedViewController {
            guard controller is UIAlertController && controller.view.tag == alertControllerViewTag else {
                return
            }
            controller.dismiss(animated: true, completion: nil)
        }
    }
}

extension VtnDownloadingVC: VtnDownloadManagerDelegateV2 {
    
    func downloadRequestStarted(_ downloadModel: VtnDownloadModelV2, index: Int) {
        let indexPath = IndexPath.init(row: index, section: 0)
        tableView?.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)
    }
    
    func downloadRequestDidPopulatedInterruptedTasks(_ downloadModels: [VtnDownloadModelV2]) {
        tableView?.reloadData()
    }
    
    func downloadRequestDidUpdateProgress(_ downloadModel: VtnDownloadModelV2, index: Int) {
        self.refreshCellForIndex(downloadModel, index: index)
    }
    
    func downloadRequestDidPaused(_ downloadModel: VtnDownloadModelV2, index: Int) {
        self.refreshCellForIndex(downloadModel, index: index)
    }
    
    func downloadRequestDidResumed(_ downloadModel: VtnDownloadModelV2, index: Int) {
        self.refreshCellForIndex(downloadModel, index: index)
    }
    
    func downloadRequestCanceled(_ downloadModel: VtnDownloadModelV2, index: Int) {
        
        self.safelyDismissAlertController()
        
        let indexPath = IndexPath.init(row: index, section: 0)
        tableView?.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
    }
    
    func downloadRequestFinished(_ downloadModel: VtnDownloadModelV2, index: Int) {
        
        self.safelyDismissAlertController()
        
        downloadManager.presentNotificationForDownload("Ok", notifBody: "Download did completed")
        
        let indexPath = IndexPath.init(row: index, section: 0)
        tableView?.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
        
        let docDirectoryPath : NSString = (VtnDownloadUtilityV2.baseFilePath as NSString).appendingPathComponent(downloadModel.fileName) as NSString
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: VtnDownloadUtilityV2.DownloadCompletedNotif as String), object: docDirectoryPath)
    }
    
    func downloadRequestDidFailedWithError(_ error: NSError, downloadModel: VtnDownloadModelV2, index: Int) {
        self.safelyDismissAlertController()
        self.refreshCellForIndex(downloadModel, index: index)
        
        debugPrint("Error while downloading file: \(String(describing: downloadModel.fileName))  Error: \(String(describing: error))")
    }
    
    //Oppotunity to handle destination does not exists error
    //This delegate will be called on the session queue so handle it appropriately
    func downloadRequestDestinationDoestNotExists(_ downloadModel: VtnDownloadModelV2, index: Int, location: URL) {
        let myDownloadPath = VtnDownloadUtilityV2.baseFilePath + "/Videos"
        if !FileManager.default.fileExists(atPath: myDownloadPath) {
            try! FileManager.default.createDirectory(atPath: myDownloadPath, withIntermediateDirectories: true, attributes: nil)
        }
        let fileName = VtnDownloadUtilityV2.getUniqueFileNameWithPath((myDownloadPath as NSString).appendingPathComponent(downloadModel.fileName as String) as NSString)
        let path =  myDownloadPath + "/" + (fileName as String)
        try! FileManager.default.moveItem(at: location, to: URL(fileURLWithPath: path))
        debugPrint("Videos folder path: \(myDownloadPath)")
    }
}
