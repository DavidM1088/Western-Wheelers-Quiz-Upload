//https://www.hackingwithswift.com/read/33/4/writing-to-icloud-with-cloudkit-ckrecord-and-ckasset

import SwiftUI
import CloudKit
import CoreImage
import Cocoa

class Model {
    
    func upload_image()  {
        let record = CKRecord(recordType: "Quiz_Images")
        let path = "/Users/davidm/Library/Containers/com.david-murphy.test2/Data/Documents/data/km.png"
        let asset = CKAsset(fileURL: URL(fileURLWithPath: path))
        record["image1"] = asset
        
        let container = CKContainer(identifier: "iCloud.com.dmurphy.westernwheelers")
        container.publicCloudDatabase.save(record, completionHandler: {
            record, error in
            if error != nil {
                print("\(String(describing: error))")
            } else {
                print("============ saved")
            }
        })
    }
    
//    func write2()  {
//        let container = CKContainer(identifier: "iCloud.com.dmurphy.westernwheelers")
//        let rec = CKRecord(recordType: "Quiz_Images")
//        rec["genre"] = "test" as CKRecordValue
//
//        //let asset = CKAsset(fileURL: url)
//        //rec["image"] = ns_image as! CKRecordValue
//        //return ns_image!
//
//        //CKContainer.default().publicCloudDatabase.save(rec) { [unowned self] record, error in
//        container.publicCloudDatabase.save(rec) { record, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    self.status_text = "Error: \(error.localizedDescription)"
//                    //self.spinner.stopAnimating()
//                    print("=====================>", self.status_text)
//                } else {
//                    //self.view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
//                    self.status_text = "Done!"
//                    //self.spinner.stopAnimating()
//                    //ViewController.isDirty = true
//                }
//            }
//        }
//    }
}

struct ContentView: View {

    func getImage() -> Image {
        let documentsPath = NSURL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0])
        let logsPath = documentsPath.appendingPathComponent("data")
        print(logsPath!)
        do {
            try FileManager.default.createDirectory(atPath: logsPath!.path, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError{
            print("Unable to create directory", error)
        }
        let fle = "km.png"
        let fileURL = logsPath!.appendingPathComponent(fle)

        let fm = FileManager.default
        if fm.fileExists(atPath: fileURL.relativePath) {
            print("exists")
            if (fm.fileExists(atPath: fileURL.relativePath)) {
                print("File Exists")
                if (fm.isReadableFile(atPath: fileURL.relativePath))   {
                    print("File is readable")
                }
            }
        }
        print ("=================", fileURL.relativePath)
        
        //let image    = NSImage(contentsOfFile: fileURL.relativePath)
        //let im1 = NSImage.init(imageLiteralResourceName: fileURL.relativePath)
        //return UIImage(named: "test")
        let x : NSImage = NSImage(named: NSImage.Name("test"))!
        return Image(nsImage: x)
    }
    
    var body: some View {
        VStack {
            self.getImage()
            Button(action: {
                print("\n========================Delete button tapped!")
                Model().upload_image()
            }) {
                Text("Upload Images")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
