//
//  Network.swift
//  TwoFlick
//
//  Created by Fitzroy Edinborough on 16/12/2015.
//  Copyright © 2015 Muscovado. All rights reserved.
//

import SystemConfiguration

public class Network {
    func  isConnected() -> Bool {
        var zeroAddress = sockaddr_in()
        
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        
        var flags = SCNetworkReachabilityFlags()
        
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        
        // perform binary addition on values
        let isReachable = flags == .Reachable
        let needsConnection = flags == .ConnectionRequired
        
        return (isReachable && !needsConnection)
    }
}
