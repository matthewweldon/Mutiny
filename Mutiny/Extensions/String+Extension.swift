//
//  String+Extension.swift
//  Muda
//
//  Created by Matthew Weldon on 2021-07-18.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}
