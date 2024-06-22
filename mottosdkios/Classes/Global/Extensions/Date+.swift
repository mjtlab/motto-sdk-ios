//
//  Date+.swift
//  mottoapp
//
//  Created by MHD on 2024/05/17.
//

import UIKit

extension Date {
    public func dateCompare(fromDate: Date) -> Bool {
        var strDateMessage:Bool
        let result:ComparisonResult = self.compare(fromDate)
        switch result {
        case .orderedAscending:
            strDateMessage = true   // future
        case .orderedDescending:
            strDateMessage = false  // past
        default:
            strDateMessage = false
        }
        return strDateMessage
    }
}
