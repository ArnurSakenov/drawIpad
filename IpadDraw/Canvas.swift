//
//  DemoView.swift
//  IpadDraw
//
//  Created by Arnur Sakenov on 08.02.2023.
//

import UIKit
enum DrawingMods {
    case rectangle
    case triangle
    case freeDraw
    case circle
    case line
}

class DemoView: UIView {
    var context: [CGContext] = []
    var currentMode = DrawingMods.freeDraw
    var rectangleDrawings: [RectangleDrawings] = []
    var triangleDrawings = [TriangleDrawings]()
    var freeDrawings = [FreeDrawings]()
    var circleDrawings: [CircleDrawings] = []
    var lineDrawings: [LineDrawings] = []
    var fillMode: Bool = false 
    var order: [Int] = []
    fileprivate var strokeColor = UIColor.red
    fileprivate var strokeWidth: Float = 1
    
    func setStrokeWidth(width: Float) {
        self.strokeWidth = width
    }
    
    func setStrokeColor(color: UIColor) {
        self.strokeColor = color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        //self.backgroundColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        //        super.draw(rect)
        drawSomething()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        lines.append([CGPoint]())
        print(currentMode)
        switch (currentMode) {
        case .freeDraw:
            freeDrawings.append(FreeDrawings.init(strokeWidth: strokeWidth, color: strokeColor, points: []))
            order.append(1)
            
        case .triangle:
            triangleDrawings.append(TriangleDrawings.init(strokeWidth: strokeWidth, color: strokeColor, opacity: fillMode, points: [touches.first!.location(in: self)]))
        case .rectangle:
            rectangleDrawings.append(RectangleDrawings.init(strokeWidth: strokeWidth, color: strokeColor, opacity: fillMode, points: [touches.first!.location(in: self)]))
        case .circle:
            circleDrawings.append(CircleDrawings.init(strokeWidth: strokeWidth, color: strokeColor, opacity: fillMode, points: [touches.first!.location(in: self)]))
        case .line:
            lineDrawings.append(LineDrawings.init(strokeWidth: strokeWidth, color: strokeColor,  points: [touches.first!.location(in: self)]))
        default:
            print("error")
        }
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if currentMode == .freeDraw {
            
            
            guard let point = touches.first?.location(in: self) else { return }
            //        print(point)
            
            guard var lastLine = freeDrawings.popLast() else { return }
            
            lastLine.points.append(point)
            freeDrawings.append(lastLine)
            if currentMode == .freeDraw
            {
                setNeedsDisplay()
            }
            //        var lastLine = lines.last
            //        lastLine?.append(point)
            
            //        line.append(point)
        }
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch (currentMode) {
        case .triangle:
            order.append(3)
            guard var last = triangleDrawings.popLast() else { return }
            print(triangleDrawings.count)
            last.points.append(touches.first!.location(in: self))
            triangleDrawings.append(last)
            print(triangleDrawings.count)
            setNeedsDisplay()
           
        case .rectangle:
            order.append(2)
            guard var last = rectangleDrawings.popLast() else { return }
            last.points.append(touches.first!.location(in: self))
            rectangleDrawings.append(last)
            
        case .circle:
            order.append(4)
            guard var last = circleDrawings.popLast() else { return }
            last.points.append(touches.first!.location(in: self))
            circleDrawings.append(last)
            
        case .line:
            order.append(5)
            guard var last = lineDrawings.popLast() else { return }
            last.points.append(touches.first!.location(in: self))
            lineDrawings.append(last)
            
        default:
            print("error")
        }
        setNeedsDisplay()
        
        
        
    }
    
    func undo() {
        
        switch (order.last) {
        case 1:
            _ = freeDrawings.popLast()
            
        case 2:
            _ = rectangleDrawings.popLast()
            _ = rectangleDrawings.popLast()

            
        case 3:
            _ = triangleDrawings.popLast()
            _ = triangleDrawings.popLast()
            
     
        case 4:
            _ = circleDrawings.popLast()
            _ = circleDrawings.popLast()
        
        case 5:
            _ = lineDrawings.popLast()
            _ = lineDrawings.popLast()
        
        
            
        default:
            print("hello")
            
        }
        order.popLast()
        setNeedsDisplay()
    }
    
    func drawSomething () {
        for k in order {
            switch (k){
            case 1:
                if !freeDrawings.isEmpty {
                    freeDraw()
                }
            case 2:
                if !rectangleDrawings.isEmpty {
                    createRectangle()
                }
            case 3:
                if !triangleDrawings.isEmpty {
                    createTriangle()
                }
            case 4:
                if !circleDrawings.isEmpty {
                    createCircle()
                }
            case 5:
                if !lineDrawings.isEmpty {
                    createLine()
                }
            default:
                print("nothing to do")
            }
            
        }
    }
    func freeDraw(){
        guard let contexts = UIGraphicsGetCurrentContext() else {return}
       
        
        freeDrawings.forEach { (line) in
            
            contexts.setStrokeColor(line.color.cgColor)
            contexts.setLineWidth(CGFloat(line.strokeWidth))
            contexts.setLineCap(.round)
            for (i, p) in line.points.enumerated() {
                if i == 0 {
                    contexts.move(to: p)
                } else {
                    contexts.addLine(to: p)
                }
            }
            contexts.strokePath()
        }
        
        
        
        
    }
    func createRectangle() {
        var rectangle: CGRect
        
        guard let contexts = UIGraphicsGetCurrentContext() else {return}
        
        for i in stride(from: 0, to: rectangleDrawings.count, by: 1) {
            var startX,startY,width,height: Double?
            contexts.setStrokeColor(rectangleDrawings[i].color.cgColor)
            contexts.setLineWidth(CGFloat(rectangleDrawings[i].strokeWidth))
            startX = rectangleDrawings[i].points[0].x
            startY = rectangleDrawings[i].points[0].y
            height = rectangleDrawings[i].points[1].y - rectangleDrawings[i].points[0].y
            width = rectangleDrawings[i].points[1].x - rectangleDrawings[i].points[0].x
            rectangle = CGRect(x: startX!, y: startY!, width: width!, height: height!)
            

            if !rectangleDrawings[i].opacity {
                contexts.stroke(rectangle)
                
            }else {
                contexts.setFillColor(rectangleDrawings[i].color.cgColor)
                contexts.fill(rectangle)
            }
            }
            
        }
    
    
    func createTriangle() {
        var rect: CGRect
      
        guard let contexts = UIGraphicsGetCurrentContext() else {return}
      
        
        for i in stride(from: 0, to: triangleDrawings.count, by: 1) {
          
            var startX,startY,width,height: Double?
            startX = triangleDrawings[i].points[0].x
            startY = triangleDrawings[i].points[0].y
            height = triangleDrawings[i].points[1].y - triangleDrawings[i].points[0].y
            width = triangleDrawings[i].points[1].x - triangleDrawings[i].points[0].x
             rect = CGRect(x: startX!, y: startY!, width: width!, height: height!)
            contexts.setStrokeColor(triangleDrawings[i].color.cgColor)
            contexts.setLineWidth(CGFloat(triangleDrawings[i].strokeWidth))
            print(currentMode)
            contexts.beginPath()
            contexts.move(to: CGPoint(x: rect.minX, y: rect.minY))
            contexts.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            contexts.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            contexts.closePath()
            
            if !triangleDrawings[i].opacity {
                contexts.strokePath()
                print("opacity true")
            } else {
                contexts.setFillColor(triangleDrawings[i].color.cgColor)
                contexts.fillPath()
            }
                        
               
                     
            
           
            context.append(contexts)
            
        }
        
    }
    func createCircle () {
        var rect: CGRect
        
        guard let contexts = UIGraphicsGetCurrentContext() else {return}
     
        
        for i in stride(from: 0, to: circleDrawings.count, by: 1) {
          
            var startX,startY,width,height: Double?
            startX = circleDrawings[i].points[0].x
            startY = circleDrawings[i].points[0].y
            height = circleDrawings[i].points[1].y - circleDrawings[i].points[0].y
            width = circleDrawings[i].points[1].x - circleDrawings[i].points[0].x
             rect = CGRect(x: startX!, y: startY!, width: width!, height: height!)
            contexts.setStrokeColor(circleDrawings[i].color.cgColor)
            contexts.setLineWidth(CGFloat(circleDrawings[i].strokeWidth))
            
            
            contexts.beginPath()
            contexts.addEllipse(in: rect)
            //contexts.drawPath(using: .fillStroke)
            contexts.closePath()
           
            if circleDrawings[i].opacity {
                contexts.setFillColor(circleDrawings[i].color.cgColor)
                contexts.fillPath()
            } else {
                contexts.strokePath()
            }
                        
              
                        
             
//            contexts.setFillColor(UIColor.red.cgColor)
//            contexts.fillPath()
            
        }
    }
    func createLine () {
        
        
        guard let contexts = UIGraphicsGetCurrentContext() else {return}
        
        
        for i in stride(from: 0, to: lineDrawings.count, by: 1) {
           
            contexts.setStrokeColor(lineDrawings[i].color.cgColor)
            contexts.setLineWidth(CGFloat(lineDrawings[i].strokeWidth))
            var startX,startY,endX,endY: Double?
            startX = lineDrawings[i].points[0].x
            startY = lineDrawings[i].points[0].y
            endX = lineDrawings[i].points[1].x
            endY = lineDrawings[i].points[1].y
          
           
            contexts.beginPath()
            contexts.move(to: CGPoint(x: startX!, y: startY!))
            contexts.addLine(to: CGPoint(x: endX!, y: endY!))
        
            contexts.closePath()
            contexts.strokePath()
            
      
            
        }
    }
}
