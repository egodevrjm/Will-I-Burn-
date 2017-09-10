//
//  Utils.swift
//  Will I Burn?
//
//  Created by Ryan Morrison on 09/09/2017.
//  Copyright © 2017 egoDev. All rights reserved.
//

import Foundation

class Utils {
    
    var SkinTypeKey = "skinType"
    
    func getStore () -> UserDefaults {
        return UserDefaults.standard
    }
    
    func setSkinType(value: String) {
        let defaults = getStore()
        defaults.setValue(value, forKey: SkinTypeKey)
        defaults.synchronize()
    }

    func getSkinType() -> String {
        let defaults = getStore()
        if let result = defaults.string(forKey: SkinTypeKey) {
            return result
        }
        return SkinType().type1
    }
}
