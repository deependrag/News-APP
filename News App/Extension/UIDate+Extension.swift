//
//  UIDate+Extension.swift
//  News App
//
//  Created by Deependra Dhakal on 08/12/2020.
//

import UIKit

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
