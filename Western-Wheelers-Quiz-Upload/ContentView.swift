//https://www.hackingwithswift.com/read/33/4/writing-to-icloud-with-cloudkit-ckrecord-and-ckasset

import SwiftUI
import CloudKit

class Model {
    var status_text = ""
    init () {
        
    }
    func write() {
        let container = CKContainer(identifier: "iCloud.com.dmurphy.westernwheelers")
        let rec = CKRecord(recordType: "Quiz_Images")
        rec["genre"] = "test" as CKRecordValue
        //CKContainer.default().publicCloudDatabase.save(rec) { [unowned self] record, error in
        container.publicCloudDatabase.save(rec) { record, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.status_text = "Error: \(error.localizedDescription)"
                    //self.spinner.stopAnimating()
                    print("=====================>", self.status_text)
                } else {
                    //self.view.backgroundColor = UIColor(red: 0, green: 0.6, blue: 0, alpha: 1)
                    self.status_text = "Done!"
                    //self.spinner.stopAnimating()
                    //ViewController.isDirty = true
                }
            }
        }
    }
}
struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello, World!").frame(maxWidth: .infinity, maxHeight: .infinity)
            Button(action: {
                print("Delete button tapped!")
                Model().write()
            }) {
                Text("GO")
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
