//
//  DateTImeHandler.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 14/09/23.
//

import UIKit

//MARK: - DateTimeDataSource
protocol DateTimeDataSource {
    func toWeekday(from unixTime: Int) -> String
}

extension DateTimeDataSource where Self: AnyObject {
    
    func toWeekday(from unixTime: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(unixTime))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: date)
    }
}
