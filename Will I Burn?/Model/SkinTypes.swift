//
//  SkinTypes.swift
//  Will I Burn?
//
//  Created by Ryan Morrison on 09/09/2017.
//  Copyright © 2017 egoDev. All rights reserved.
//

import Foundation

struct SkinType {
    let type1 = "Pale/Light"
    let type2 = "White/Fair"
    let type3 = "Medium"
    let type4 = "Olive Brown"
    let type5 = "Dark Brown"
    let type6 = "Very Dark/Black"
    
    func allSkinTypes() -> [String] {
        return [type1, type2, type3, type4, type5, type6]
    }
}
