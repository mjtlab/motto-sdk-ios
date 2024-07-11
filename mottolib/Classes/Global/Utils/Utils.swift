//
//  Utils.swift
//  mottoapp
//
//  Created by MHD on 2024/02/13.
//

import UIKit

class Utils {
    static func getWidth(_ value: CGFloat) -> CGFloat {
        let width = UIScreen.main.bounds.width
        let standardWidth: CGFloat = 375.0
        return width / standardWidth * value
    }
    
    static func getHeight(_ value: CGFloat) -> CGFloat {
        let height = UIScreen.main.bounds.height
        let standardheight: CGFloat = 812.0
        return height / standardheight * value
    }
    
//    static func printAlret(title: String, msg: String) {
//        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
//        let yes = UIAlertAction(title: "Yes", style: .default, handler: nil)
//        //      let no = UIAlertAction(title: "No", style: .destructive, handler: nil)
//        
//        //      alret.addAction(no)
//        alert.addAction(yes)
//        
//        present(alert, animated: true, completion: nil)
//    }
    
    public static func consoleLog(_ tag: String, _ object: Any = "nil", _ flag: Bool = false, filename: String = #file, _ line: Int = #line, _ funcname: String = #function) {
        if !flag { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss:SSS"
        let classname = filename.components(separatedBy: "/")
        print("-----------------------------------------------------------------------")
        print("########## [\(dateFormatter.string(from: Date()))] \(classname[classname.count - 1].components(separatedBy: ".")[0]) >> \(funcname) >> line: \(line)")
        print("### \(tag) = [", object, "]")
        print("-----------------------------------------------------------------------")
    }
    
    public static func extractKeywordFromUrl(url: String) -> String {
        var searchKeyword = ""
        let queryString = "query="
        if let range = url.range(of: queryString) {
            let strStartIndex = url.distance(from: url.startIndex, to: range.lowerBound)
            let strEndIndex = url.distance(from: url.startIndex, to: range.upperBound)
            let endIndex = url.index(before: url.endIndex)
            searchKeyword = String(url[range.upperBound...endIndex])
            
            if (searchKeyword.count > 0) {
                if searchKeyword.contains("&")  {
                    searchKeyword = String(searchKeyword.prefix(upTo: searchKeyword.firstIndex(of: "&")!))
                    let frontWordDecode = searchKeyword.removingPercentEncoding
                    
                    return frontWordDecode ?? ""
                }
            }
        } else {
            return ""
        }
        return ""
    }
    
    public static func podImage(context: AnyClass, img: String) -> UIImage? {
        let frameworkBundle = Bundle(for: context)
        let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("mottolib")
        let resourceBundle = Bundle(url: bundleURL!)

        return UIImage(named: img, in: resourceBundle, compatibleWith: nil)
    }
}
