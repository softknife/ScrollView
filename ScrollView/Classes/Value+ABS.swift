//
//  Value+ABS.swift
//  EAppleNFB
//
//  Created by Eric-Ingram on 2017/8/28.
//  Copyright © 2017年 Eapple. All rights reserved.
//

import UIKit

extension Int{
    
    var absolute: Int {
        return Int( abs(Int32(self)) )
    }
}

extension Int32{
    
    var absolute: Int32 {
        return abs(self)
    }
    
}

extension Int8{
    
    var absolute: Int8 {
        return Int8( abs(Int32(self)) )
    }
    
    
}

extension Int16{
    
    var absolute: Int16 {
        return Int16( abs(Int32(self)) )
    }
}

extension Int64{
    
    var absolute: Int64 {
        return Int64( abs(Int32(self)) )
    }
}

extension CGFloat{
    
    var absolute: CGFloat {
        return CGFloat( fabs(Double(self)))
    }
}

extension Float{
    
    var absolute: Float {
        return fabsf(self)
    }
    
}

extension Float64{
    
    var absolute: Float64 {
        return Float64( fabs(self) )
    }
}

//extension Float80 {
//
//    var absolute: Float80 {
//        return Float80( fabs(self) )
//    }
//
//}


