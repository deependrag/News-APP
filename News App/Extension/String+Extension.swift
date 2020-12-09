//
//  String+Extension.swift
//  News App
//
//  Created by Deependra Dhakal on 07/12/2020.
//

import Foundation
extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func convertToLocalDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale =  Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
//        if let date = dateFormatter.date(from: self) {
//            dateFormatter.locale = Locale.current
//            dateFormatter.timeZone = TimeZone.current
//            let dateStr = dateFormatter.string(from: date)
//            return dateFormatter.date(from: dateStr)
//        }
        return dateFormatter.date(from: self)
    }
}
