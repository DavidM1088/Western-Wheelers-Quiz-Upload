//https://www.hackingwithswift.com/read/33/4/writing-to-icloud-with-cloudkit-ckrecord-and-ckasset

import SwiftUI
import CloudKit
import CoreImage
import Cocoa

class Model {
    var rec_ids : [CKRecord.ID] = []
    let db = CKContainer(identifier: "iCloud.com.dmurphy.westernwheelers").publicCloudDatabase
    
    func delete_records() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Quiz_Images", predicate: predicate)
        let fetch_operation = CKQueryOperation(query: query)
        
        fetch_operation.recordFetchedBlock = { record in
            let image_id = record.recordID
            self.rec_ids.append(image_id)
            print("FETCH:", image_id)
//            if image_loaded != nil {
//                print("=============== image updated, count:", image_desc)
//                self.image_records.append(ImageRecord(im: UIImage(data: data!)!, desc: image_desc))
//            }
        }
        
        fetch_operation.queryCompletionBlock = { [unowned self] (cursor, error) in
            if error == nil {
                DispatchQueue.main.async {
                    //print("=============== quiz images updated, count:", self.image_records.count)
                    //print("=============== quiz image updated 2 nil::", self.image_loaded == nil, self.image_loaded.debugDescription, self.image_loaded?.size)
                }
                //self.container.publicCloudDatabase.add(del_operation)
                var del_operation : CKModifyRecordsOperation?
                del_operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: self.rec_ids)
                del_operation!.savePolicy = .allKeys
                del_operation!.modifyRecordsCompletionBlock = { added, deleted, error in
                    if error != nil {
                        print(error)
                    } else {
                        print("All deleted, count:") //, self.rec_ids.count)
                    }
                }
                self.db.add(del_operation!)
            } else {
                print("Load ================ERR:", error?.localizedDescription ?? "")
            }
        }
        //container.publicCloudDatabase
        self.db.add(fetch_operation)
    }
    
    func upload_record(path: String, fields : [String])  {
        let record = CKRecord(recordType: "Quiz_Images")
//        var index = filepath.index(filepath.endIndex, offsetBy: -10)
//        let file_name = String(filepath[index..<filepath.endIndex])
//        index = file_name.index(file_name.endIndex, offsetBy: -4)
//        let image_num = String(file_name[..<index])
        
        let image_num = fields[0]
        let filepath = path + "/" + image_num + ".png"
        let image_asset = CKAsset(fileURL: URL(fileURLWithPath: filepath))
        
        //record["image_num"] = Int(image_num)
        print("=========================>IMAGE NUM:", image_num)
        record["image"] = image_asset
        record["image_desc"] = fields[2]
        record["latitude"] = Float(fields[3])
        record["longitude"] = Float(fields[4])
        record["url"] = fields[5]
        record["enabled"] = 1

        //self.container.publicCloudDatabase
        db.save(record, completionHandler: {
            record, error in
            if error != nil {
                print("\nERROR UPLOADING IMAGE ===================\(String(describing: error))")
            } else {
                print("saved:"+filepath)
            }
        })
    }
    
    func upload_index()  {
        let path = "/Users/davidm/Library/Containers/com.david-murphy.Western-Wheelers-Quiz-Upload/Data/Documents/data"
        do {
            let data = try String(contentsOfFile: path+"/index.txt", encoding: .utf8)
            let line_data = data.components(separatedBy: .newlines)
            var line_num = 0
            let max_lines = 2000000000000
            for line in line_data {
                let fields = line.components(separatedBy: ", ")
                print("=========================>LINE NUM:", line_num, line, fields)
                if fields.count == 6 {
                    upload_record(path: path, fields: fields)
                }
                line_num += 1
                if line_num >= max_lines {
                    break
                }
            }
        }
            catch {print("\nERROR ===================\(String(describing: error))")
        }
    }
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
            //self.getImage()
            Text("hit upload ...")
            Button(action: {
                print("Delete tapped!")
                Model().delete_records()
            }) {
                Text("Delete Images")
            }
            Button(action: {
                print("Upload tapped!")
                Model().upload_index()
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
