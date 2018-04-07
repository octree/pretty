//
//  ColorSpaceConversion.swift
//  Pretty
//
//  Created by Octree on 2018/4/7.
//  Copyright © 2018年 Octree. All rights reserved.
//

import GLKit

// From https://github.com/indragiek/DominantColor


func RGBToSRGB(_ rgbVector: GLKVector3) -> GLKVector3 {
    #if TARGET_OS_IPHONE
    // sRGB is the native device color space on iOS, no conversion is required.
    return rgbVector
    #else
    let color = NSColor(deviceRed: CGFloat(rgbVector.x), green: CGFloat(rgbVector.y), blue: CGFloat(rgbVector.z), alpha: 1.0)
    let srgbColor = color.usingColorSpace(.sRGB)
    return GLKVector3Make(Float(srgbColor?.redComponent ?? 0),
                          Float(srgbColor?.greenComponent ?? 0),
                          Float(srgbColor?.blueComponent ?? 0))
    #endif
}

func SRGBToRGB(_ srgbVector: GLKVector3) -> GLKVector3 {
    #if TARGET_OS_IPHONE
    // sRGB is the native device color space on iOS, no conversion is required.
    return srgbVector
    #else
    let components = [ CGFloat(srgbVector.x), CGFloat(srgbVector.y), CGFloat(srgbVector.z), 1.0 ]
    let srgbColor = NSColor(colorSpace: .sRGB, components: components, count: 4)
    let rgbColor = srgbColor.usingColorSpace(.deviceRGB)
    return GLKVector3Make(Float(rgbColor?.redComponent ?? 0),
                          Float(rgbColor?.greenComponent ?? 0),
                          Float(rgbColor?.blueComponent ?? 0))
    #endif
}

//// http://en.wikipedia.org/wiki/SRGB#Specification_of_the_transformation
//
func SRGBToLinearSRGB(_ srgbVector:  GLKVector3) ->  GLKVector3 {
    
    let f: (Float) -> Float = { c in
        if (c <= 0.04045) {
            return c / 12.92
        } else {
            return powf((c + 0.055) / 1.055, 2.4)
        }
    }
    return GLKVector3Make(f(srgbVector.x), f(srgbVector.y), f(srgbVector.z))
}

func LinearSRGBToSRGB(_ lSrgbVector: GLKVector3) -> GLKVector3 {
    
    let f: (Float) -> Float = { c in
        if (c <= 0.0031308) {
            return c * 12.92
        } else {
            return (1.055 * powf(c, 1.0 / 2.4)) - 0.055
        }
    }
    
    return GLKVector3Make(f(lSrgbVector.x), f(lSrgbVector.y), f(lSrgbVector.z))
}

// mark: XYZ (CIE 1931)
//// http://en.wikipedia.org/wiki/CIE_1931_color_space#Construction_of_the_CIE_XYZ_color_space_from_the_Wright.E2.80.93Guild_data

private let LinearSRGBToXYZMatrix = GLKMatrix3Make(0.4124, 0.2126, 0.0193, 0.3576, 0.7152, 0.1192, 0.1805, 0.0722, 0.9505)

func LinearSRGBToXYZ(_ linearSrgbVector: GLKVector3) -> GLKVector3 {
    
    let unscaledXYZVector = GLKMatrix3MultiplyVector3(LinearSRGBToXYZMatrix, linearSrgbVector)
    return GLKVector3MultiplyScalar(unscaledXYZVector, 100)
}

private let XYZToLinearSRGBMatrix = GLKMatrix3Make(3.2406, -0.9689, 0.0557, -1.5372, 1.8758, -0.2040, -0.4986, 0.0415, 1.0570)

func XYZToLinearSRGB(_ xyzVector: GLKVector3) -> GLKVector3 {
    
    let scaledXYZVector = GLKVector3DivideScalar(xyzVector, 100)
    return GLKMatrix3MultiplyVector3(XYZToLinearSRGBMatrix, scaledXYZVector)
}

//  MARK: LAB
//// http://en.wikipedia.org/wiki/Lab_color_space#CIELAB-CIEXYZ_conversions

func XYZToLAB(_ xyzVector: GLKVector3, tristimulus: GLKVector3) -> GLKVector3 {
    
    let f: (Float) -> Float = { t in
        
        if (t > powf(6 / 29, 3)) {
            return powf(t, 1 / 3)
        } else {
            return ((1 / 3) * powf(29 / 6, 2) * t) + (4 / 29)
        }
    }
    let fx = f(xyzVector.x / tristimulus.x)
    let fy = f(xyzVector.y / tristimulus.y)
    let fz = f(xyzVector.z / tristimulus.z)

    let l = (116 * fy) - 16
    let a = 500 * (fx - fy)
    let b = 200 * (fy - fz)

    return GLKVector3Make(l, a, b)
}

func LABToXYZ(_ labVector: GLKVector3, tristimulus: GLKVector3) -> GLKVector3 {
    let f: (Float) -> Float = { t in
        if (t > (6 / 29)) {
            return powf(t, 3)
        } else {
            return 3 * powf(6 / 29, 2) * (t - (4 / 29))
        }
    }
    let c = (1 / 116) * (labVector.x + 16)

    let y = tristimulus.y * f(c)
    let x = tristimulus.x * f(c + ((1 / 500) * labVector.y))
    let z = tristimulus.z * f(c - ((1 / 200) * labVector.z))

    return GLKVector3Make(x, y, z)
}

//#pragma mark - Public
//
//// From http://www.easyrgb.com/index.php?X=MATH&H=15#text15
let D65Tristimulus =  GLKVector3Make(95.047, 100, 108.883)

func RGBToLAB(rgbVector: GLKVector3) -> GLKVector3 {
    
    let srgbVector = RGBToSRGB(rgbVector)
    let lSrgbVector = SRGBToLinearSRGB(srgbVector)
    let xyzVector = LinearSRGBToXYZ(lSrgbVector)
    return XYZToLAB(xyzVector, tristimulus: D65Tristimulus)
}

func LABToRGB(labVector: GLKVector3) -> GLKVector3 {

    let xyzVector = LABToXYZ(labVector, tristimulus: D65Tristimulus)
    let lSrgbVector = XYZToLinearSRGB(xyzVector)
    let srgbVector = LinearSRGBToSRGB(lSrgbVector)
    return SRGBToRGB(srgbVector)
}





