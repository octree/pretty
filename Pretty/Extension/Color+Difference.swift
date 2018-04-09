//
//  UIColor+Difference.swift
//  Pretty
//
//  Created by Octree on 2018/4/7.
//  Copyright © 2018年 Octree. All rights reserved.
//

import Foundation

#if os(iOS) || os(watchOS) || os(tvOS)
import UIKit
public typealias OCTColor = UIColor
#else
import Cocoa
public typealias OCTColor = NSColor
#endif

import GLKit

extension OCTColor {

    
    /// 计算与另一个颜色的差异
    ///
    /// - Parameter other: NSColor Or UIColor
    /// - Returns: CIE2000 颜色差异值
    func colorDifference(_ other: OCTColor) -> Float {

        let red = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        let green = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        let blue = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        let alpha = UnsafeMutablePointer<CGFloat>.allocate(capacity: 1)
        
        var color = usingColorSpace(.deviceRGB)!
        color.getRed(red, green: green, blue: blue, alpha: alpha)
        let lab1 = GLKVector3Make(Float(red[0]), Float(green[0]), Float(blue[0]))
        
        color = other.usingColorSpace(.deviceRGB)!
        color.getRed(red, green: green, blue: blue, alpha: alpha)
        let lab2 = GLKVector3Make(Float(red[0]), Float(green[0]), Float(blue[0]))
        
        return CIE2000SquaredColorDifference(1, kC: 1, kH: 1)(lab1, lab2)
    }
}


