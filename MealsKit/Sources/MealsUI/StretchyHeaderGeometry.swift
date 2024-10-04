//
//  StretchyHeaderGeometry.swift
//  MealsKit
//
//  Created by Raul Mena on 10/3/24.
//


import SwiftUI

public struct StretchyHeaderGeometry {
    public static func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {
        geometry.frame(in: .global).minY
    }
    
    public static func getXOffset(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        return offset > 0 ? -offset : 0
    }
    
    public static func getYOffset(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        return offset > 0 ? -offset : 0
    }
    
    public static func getHeight(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height
        return offset > 0 ? imageHeight + offset : imageHeight
    }
    
    public static func getWidth(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageWidth = geometry.size.width
        return offset > 0 ? imageWidth + 2 * offset : imageWidth
    }
}
