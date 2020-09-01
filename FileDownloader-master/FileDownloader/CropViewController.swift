//
//  CropViewController.swift
//  FileDownloader
//
//  Created by Good on 01/09/20.
//  Copyright © 2020 Victoria Hawkins. All rights reserved.
//

import UIKit

class CropViewController: UIViewController {
    
    @IBOutlet weak var staticImage: UIImageView!
    @IBOutlet weak var cropImaged: UIImageView!
    @IBOutlet weak var slider: UISlider!
    
    var sliderImage : [String] = ["Lockdown Paavangal - Gopi & Sudhakar - Parithabangal.vtx#xywh=6,6,182,102","Lockdown Paavangal - Gopi & Sudhakar - Parithabangal.vtx#xywh=193,6,182,102","Lockdown Paavangal - Gopi & Sudhakar - Parithabangal.vtx#xywh=380,6,182,102","Lockdown Paavangal - Gopi & Sudhakar - Parithabangal.vtx#xywh=567,6,182,102","Lockdown Paavangal - Gopi & Sudhakar - Parithabangal.vtx#xywh=754,6,182,102","Lockdown Paavangal - Gopi & Sudhakar - Parithabangal.vtx#xywh=941,6,182,102","Lockdown Paavangal - Gopi & Sudhakar - Parithabangal.vtx#xywh=1128,6,182,102"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.slider.maximumValue = Float(sliderImage.count)
        slider.minimumValue = 1

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        print(sender.value)
        
        if sliderImage.count > Int(sender.value) {
            self.loadImage(sliderImage[Int(sender.value)])
        }
    }
    
    func loadImage(_ string:String) {
        let splitArray = string.components(separatedBy: "#xywh=")
        if splitArray.count > 1 {
            let secondArray = splitArray[1]
            let splitValue = secondArray.components(separatedBy: ",")
            let posX: CGFloat = (splitValue[0].CGFloatValue()) ?? 0
            let posY: CGFloat = (splitValue[1].CGFloatValue()) ?? 0
            let width: CGFloat = (splitValue[2].CGFloatValue()) ?? 0
            let height: CGFloat = (splitValue[3].CGFloatValue()) ?? 0
            let croppedImage = staticImage?.image?.cropped( CGRect(x: posX, y: posY, width: width, height: height))
            cropImaged.image = croppedImage
        }
    }
    
    
//    func cropToRect(image: UIImage, rect: CGRect, scale: CGFloat) -> UIImage? {
//        UIGraphicsBeginImageContextWithOptions(CGSize(width: rect.size.width / scale, height: rect.size.height / scale), true, 0.0)
//        image.draw(at: CGPoint(x: -rect.origin.x / scale, y: -rect.origin.y / scale))
//        let croppedImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return croppedImage
//    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension String {

  func CGFloatValue() -> CGFloat? {
    guard let doubleValue = Double(self) else {
      return nil
    }

    return CGFloat(doubleValue)
  }
}


extension UIImage {
    func cropped(_ boundingBox: CGRect) -> UIImage? {
        guard let cgImage = self.cgImage?.cropping(to: boundingBox) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
