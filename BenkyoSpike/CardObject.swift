//
//  CardObject.swift
//  BenkyoSpike
//
//  Created by Jason Cheladyn on 11/21/16.
//  Copyright © 2016 Liyicky. All rights reserved.
//

import Foundation


class CardObject {
    let frontValue:String!
    let backValue:String!
    var flipped = false
    init(front:String, back:String){
        frontValue = front
        backValue = back
    }
}
