//
//  NetworkManager.swift
//  Assignment
//
//  Created by iOS TNK on 12/10/20
//  Copyright © 2020 iOS TNK. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import SystemConfiguration

public class NetworkManager {
    
    //MARK: Variable declaration
    static let sharedInstance = NetworkManager()
    let device  = UIDevice.current.userInterfaceIdiom == .phone ? "IPHONE" : "IPAD"
    //MARK:- Check Internet Connectivity
    func isInternetAvailable() -> Bool{
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
    //MARK:- Common Network Service Call with header
    func commonNetworkCallWithHeader(header : [String:String], url: String, method : HTTPMethod, parameters : [String:Any]?, completionHandler:@escaping (Data?,String?)->Void) {
        
        let configuration = URLSessionConfiguration.background(withIdentifier: "")
        let manager = Alamofire.SessionManager(configuration: configuration)
        manager.startRequestsImmediately = true
        let authHeader = self.getHeaders()
        Alamofire.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: authHeader).responseJSON { (response) in
            if(response.result.isSuccess){
                if response.result.value != nil{
                    //var  jsonDict : Dictionary<String, Any>?
                    //jsonDict = data as? Dictionary<String, Any>
                    completionHandler(response.data,nil)
                    return
                }
            }
            completionHandler(nil,response.result.error?.localizedDescription)
        }
    }
    
    //Upload images with parameter - -
    func commonNetworkCallWithHeaderandFormData(header :[String:String], url : String, method:HTTPMethod, parameters : [String:Any]?, imageDict: [String:Any]?, completionHandler:@escaping (Dictionary<String, Any>?,String?)->Void) {
        let url = URL(string: url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = getHeaders()
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for key in imageDict!.keys{
                let image = imageDict![key] as! UIImage
                let userImageData = image.jpegData(compressionQuality: 0.5)!
                multipartFormData.append(userImageData, withName: key, fileName: "image.jpg", mimeType: "image/jpg")
            }
            for (key, value) in parameters! {
                if value is Int {
                    multipartFormData.append("\(value)".data(using:.utf8)!, withName: key)
                } else {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }
        }, with: urlRequest) { (encodingResult) in
            
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print(response)
                    if let data = response.result.value {
                        var  jsonDict : Dictionary<String, Any>?
                        jsonDict = data as? Dictionary<String, Any>
                        completionHandler(jsonDict,nil)
                        return
                    } else {
                        print(response.result.error!)
                    }
                }
            case .failure(_): break }
        }
    }
    //Basic Auth
    private func getHeaders() -> [String: String] {
        let userName = "WhiteLabelSuper"
        let password = "Test123!"
        let credentialData = "\(userName):\(password)".data(using: .utf8)
        guard let cred = credentialData else { return ["" : ""] }
        let base64Credentials = cred.base64EncodedData(options: [])
        guard let base64Date = Data(base64Encoded: base64Credentials) else { return ["" : ""] }
        return ["Authorization": "Basic \(base64Date.base64EncodedString())", "User-Agent" : device]

    }
}
//Class ends here
