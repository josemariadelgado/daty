
import Foundation
import UIKit


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}

extension UIImageView {
    func downloadAsyncImageFrom(link:String?, contentMode mode: UIViewContentMode) {
        contentMode = mode
        if link == nil {
            self.image = UIImage(named: "default")
            return
        }
        if let url = URL(string: link!) {
            //            print("\nstart download: \(url.lastPathComponent!)")
            URLSession.shared.dataTask(with: url, completionHandler: { (data, _, error) -> Void in
                guard let data = data , error == nil else {
                    //                    print("\nerror on download \(error)")
                    return
                }
                DispatchQueue.main.async { () -> Void in
                    //                    print("\ndownload completed \(url.lastPathComponent!)")
                    self.image = UIImage(data: data)
                }
            }).resume()
        } else {
            self.image = UIImage(named: "default")
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension Date {
    var age: Int {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year!
    }
}

