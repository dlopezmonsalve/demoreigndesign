//
//  Utils.swift
//  Demo ReignDesign
//
//  Created by Daniel López  on 11-09-17.
//  Copyright © 2017 Daniel. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class Utils{
    
    init(){
    }
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    class func dateFromString(dateToFormat : String) -> Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from:dateToFormat)!
        
        return date
    }
    
    class func makeSimpleAlert(title: String, subtitle: String) -> UIAlertController{
        let title = title
        let subtitle = subtitle
        
        let alertController = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        
        let cancelar = UIAlertAction(title: "Ok", style: .cancel) { (action:UIAlertAction!) in
            
        }
        alertController.addAction(cancelar)
        
        return alertController
    }
}
