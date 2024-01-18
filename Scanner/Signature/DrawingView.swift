//
//  DrawingView.swift
//  Scanner
//
//  Created by Petros Gabrielyan on 16.01.24.
//

import UIKit

class DrawingView: UIView {
    
    var drawColor = UIColor.black
    var lineWidth: CGFloat = 5
    
    private var lastPoint: CGPoint!
    private var bezierPath: UIBezierPath!

    private var preRenderImage: UIImage!
    private var paths = [UIBezierPath]()
    private var lineWidths = [CGFloat]()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initBezierPath()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initBezierPath()
    }
    
    func initBezierPath() {
        bezierPath = UIBezierPath()
        bezierPath.lineCapStyle = CGLineCap.round
        bezierPath.lineJoinStyle = CGLineJoin.round
    }
    
    func reset() {
        paths.removeAll()
        lineWidths.removeAll()
        bezierPath.removeAllPoints()
        
        for view in self.subviews {
            view.isHidden = false
        }
        
        setNeedsDisplay()
    }
    
    public func setPathParams(color: UIColor = .black, width: CGFloat = 5) {
        self.lineWidth = width
        self.drawColor = color
    }
    
    func undo() {
        if paths.count == 1 {
            if let path = paths.popLast() {
                lineWidths.removeLast()
                path.removeAllPoints()
            }
            for view in self.subviews {
                view.isHidden = false
            }
        } else if let path = paths.popLast() {
            lineWidths.removeLast()
            path.removeAllPoints()
        }
        
        setNeedsDisplay()
    }
    
    func save() -> UIImage? {
        if !paths.isEmpty {
            var image = getImageFromView(self)
            image = image?.cropAlpha()
            return image
        }
        return nil
    }
    
    // MARK: - Touch handling
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject? = touches.first
        lastPoint = touch!.location(in: self)
        initBezierPath()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: AnyObject? = touches.first
        let newPoint = touch!.location(in: self)
        
        for view in self.subviews {
            view.isHidden = true
        }
        
        bezierPath.move(to: lastPoint)
        bezierPath.addLine(to: newPoint)
        lastPoint = newPoint
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        bezierPath.close()
        paths.append(bezierPath)
        lineWidths.append(lineWidth)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        touchesEnded(touches!, with: event)
    }
    
    // MARK: - Render
    func getImageFromView(_ view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        if paths.count > 0{
            for i in 0..<paths.count {
                paths[i].lineWidth = lineWidths[i]
                drawColor.setStroke()
                paths[i].stroke()
            }
        }

        if let bezierPath = bezierPath {
            bezierPath.lineWidth = lineWidth
            drawColor.setFill()
            drawColor.setStroke()
            bezierPath.stroke()
        }
    }

}


