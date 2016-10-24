//
//  Model.swift
//  CagetestMemory
//
//  Created by sky on 9/2/16.
//  Copyright © 2016 Cagetest. All rights reserved.
//

import Foundation

class Model: NSObject {
    
    func getPokers(groupNum: UInt32 = 8, pokerNumber: UInt = 16) -> [UInt] {
        var pokers: [UInt] = [1,1,2,2,3,3,4,4,5,5,6,6,2,2,5,5]
//        for _ in 1...((pokerNumber-8)/2) {
//            let pokerId = UInt(arc4random_uniform(groupNum) + 1)
//            pokers.append(pokerId)
//            pokers.append(pokerId)
//        }
        print("Before shuffle: \(pokers)")
        pokers.shuffleInPlace()
        print("After shuffle: \(pokers)")
        return pokers
    }
    
}

extension Array {
   
    /// Shuffle the elements of `self` in-place.
    mutating func shuffleInPlace() {
        // empty and single-element collections don't shuffle
        if count < 2 { return }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
    }
    
}
