//
//  BurnTimes.swift
//  Will I Burn?
//
//  Created by Ryan Morrison on 10/09/2017.
//  Copyright © 2017 egoDev. All rights reserved.
//

import Foundation

class BurnTimes {
    let bt1: Int = 67
    let bt2: Int = 100
    let bt3: Int = 200
    let bt4: Int = 300
    let bt5: Int = 400
    let bt6: Int = 500
    
    var uvIndex:Int = 10
    
    func calcBurnTime(skinType: String, uvIndex: Int) -> Int {
        self.uvIndex = uvIndex
        
        switch skinType {
        case SkinType().type1:
            return _calcBurnTime(skinTypeBurnIndex: bt1)
        case SkinType().type2:
            return _calcBurnTime(skinTypeBurnIndex: bt2)
        case SkinType().type3:
            return _calcBurnTime(skinTypeBurnIndex: bt3)
        case SkinType().type4:
            return _calcBurnTime(skinTypeBurnIndex: bt4)
        case SkinType().type5:
            return _calcBurnTime(skinTypeBurnIndex: bt5)
        case SkinType().type6:
            return _calcBurnTime(skinTypeBurnIndex: bt6)
        default:
            return 5
        }
    }
    
    private func _calcBurnTime(skinTypeBurnIndex: Int) -> Int {
        let burnTime = skinTypeBurnIndex / self.uvIndex
        print("burnTime " + String(burnTime))
        return burnTime
    }
    
}
