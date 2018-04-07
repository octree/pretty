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
