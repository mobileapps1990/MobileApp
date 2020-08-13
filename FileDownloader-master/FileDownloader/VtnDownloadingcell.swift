//
//  VtnDownloadingcell.swift
//  FileDownloader
//
//  Created by Good on 13/08/20.
//  Copyright © 2020 Victoria Hawkins. All rights reserved.
//

import UIKit

class VtnDownloadingcell: UITableViewCell {

    @IBOutlet var posterImage : UIImageView?
    @IBOutlet var lblTitle : UILabel?
    @IBOutlet var lblDetails : UILabel?
    @IBOutlet var progressDownload : UIProgressView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCellForRowAtIndexPath(_ indexPath : IndexPath, downloadModel: VtnDownloadModelV2) {
        
        self.lblTitle?.text = "File Title: \(downloadModel.fileName!)"
        self.progressDownload?.progress = downloadModel.progress
                
        let detailLabelText = NSMutableString()
        detailLabelText.appendFormat("Status: \(downloadModel.status)\n Progress:\( Int(downloadModel.progress * 100.0))\n VideoID\(downloadModel.videoID ?? "")" as NSString)
        lblDetails?.text = detailLabelText as String
    }

}
