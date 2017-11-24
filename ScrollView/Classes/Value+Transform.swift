//
//  Value+Transform.swift
//  EAppleNFB
//
//  Created by Eric-Ingram on 2017/8/30.
//  Copyright © 2017年 Eapple. All rights reserved.
//

import UIKit


//protocol Int2Float :  FixedWidthInteger, SignedInteger {
//    func float() -> Float
//    func cgfloat() -> CGFloat
//
//}
//
//extension Int2Float{
//
//    func float() -> Float
//    {
//
//        return Float(self)
//    }
//
//
////    func cgfloat() -> CGFloat{
////
////
////    }
//
//}


extension Int{
    
    
    var cgfloat: CGFloat {
        
        return CGFloat(self)
        
    }
    
    var float: Float {
        
        return Float(self)
        
    }
}

extension Int32{
    
    var cgfloat: CGFloat {
        
        return CGFloat(self)
        
    }
    
    var float: Float {
        
        return Float(self)
        
    }
}

extension Int8{
    
    var cgfloat: CGFloat {
        
        return CGFloat(self)
        
    }
    
    var float: Float {
        
        return Float(self)
        
    }
    
}

extension Int16{
    
    var cgfloat: CGFloat {
        
        return CGFloat(self)
        
    }
    
    var float: Float {
        
        return Float(self)
        
    }
}

extension Int64{
    
    var cgfloat: CGFloat {
        
        return CGFloat(self)
        
    }
    
    
    var float: Float {
        
        return Float(self)
        
    }
}

extension CGFloat{
    
    var int: Int {
        
        return Int(self)
    }
}

extension Float{
    
    var int: Int {
        
        return Int(self)
    }
}

extension Float64{
    
    var int: Int {
        
        return Int(self)
    }
}

//extension Float80 {
//
//    var int: Int {
//
//        return Int(self)
//    }
//}


