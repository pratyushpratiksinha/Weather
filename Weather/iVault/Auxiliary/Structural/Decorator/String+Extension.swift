//
//  String+Extension.swift
//  Weather
//
//  Created by Pratyush Pratik Sinha on 11/09/23.
//

import Foundation

extension String {
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    
    var withoutWhiteSpaces: String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    func removingCharacters(in characterSet: CharacterSet) -> String {
        return self.components(separatedBy: characterSet).joined()
    }
}
