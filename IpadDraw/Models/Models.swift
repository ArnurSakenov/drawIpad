//
//  Models.swift
//  IpadDraw
//
//  Created by Arnur Sakenov on 12.02.2023.
//

import UIKit

struct FreeDrawings {
    let strokeWidth: Float
    let color: UIColor
    var points: [CGPoint]
}

struct RectangleDrawings {
    let strokeWidth: Float
    let color: UIColor
    let opacity: Bool
    var points: [CGPoint]
}
struct TriangleDrawings {
    let strokeWidth: Float
    let color: UIColor
    let opacity: Bool
    var points: [CGPoint]
}
struct CircleDrawings {
    let strokeWidth: Float
    let color: UIColor
    let opacity: Bool
    var points: [CGPoint]
}
struct LineDrawings {
    let strokeWidth: Float
    let color: UIColor
    var points: [CGPoint]
}
