//
//  DateHelpers.swift
//  Tasks
//
//  Created by Jason Koceja on 9/16/20.
//  Copyright © 2020 Jason Koceja. All rights reserved.
//

import Foundation

extension Date {
    func stringValue() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium

        return formatter.string(from: self)
    }
}
