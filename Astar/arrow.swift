// Extension to BezierPath to draw custom arrow path

import UIKit

extension UIBezierPath {
    
    class func arrow(points: [CGPoint], tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) -> Self {
        var lines = find_lines(points: points)
        
        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
        func signOf(_ num: CGFloat) -> CGFloat{ return num < 0 ? -1 : 1}
        var finalPoints1 = [CGPoint]()
        var finalPoints2 = [CGPoint]()
        finalPoints1.append(points[0])
        for line in lines{
            
            let dx = line[0].x - line[1].x
            let dy = line[0].y - line[1].y
            
            if line == lines[lines.count - 1]{
                if dx == 0{
                    finalPoints1.append(p(line[0].x + signOf(dy)*tailWidth, line[0].y))
                    finalPoints2.append(p(line[0].x - signOf(dy)*tailWidth, line[0].y))
                    finalPoints1.append(p(line[1].x + signOf(dy)*tailWidth, line[1].y + signOf(dy)*headLength))
                    finalPoints2.append(p(line[1].x - signOf(dy)*tailWidth, line[1].y + signOf(dy)*headLength))
                    finalPoints1.append(p(line[1].x + signOf(dy)*(tailWidth+headWidth), line[1].y + signOf(dy)*headLength))
                    finalPoints2.append(p(line[1].x - signOf(dy)*(tailWidth+headWidth), line[1].y + signOf(dy)*headLength))
                }
                
                if dy == 0{
                    finalPoints1.append(p(line[0].x, line[0].y - signOf(dx)*tailWidth))
                    finalPoints2.append(p(line[0].x, line[0].y + signOf(dx)*tailWidth))
                    finalPoints1.append(p(line[1].x + signOf(dx)*headLength, line[1].y - signOf(dx)*tailWidth))
                    finalPoints2.append(p(line[1].x + signOf(dx)*headLength, line[1].y + signOf(dx)*tailWidth))
                    finalPoints1.append(p(line[1].x + signOf(dx)*headLength, line[1].y - signOf(dx)*(tailWidth+headWidth)))
                    finalPoints2.append(p(line[1].x + signOf(dx)*headLength, line[1].y + signOf(dx)*(tailWidth+headWidth)))
                }
            }else{
            
                if dx == 0{
                    finalPoints1.append(p(line[0].x + signOf(dy)*tailWidth, line[0].y))
                    finalPoints2.append(p(line[0].x - signOf(dy)*tailWidth, line[0].y))
                    finalPoints1.append(p(line[1].x + signOf(dy)*tailWidth, line[1].y))
                    finalPoints2.append(p(line[1].x - signOf(dy)*tailWidth, line[1].y))
                }
                
                if dy == 0{
                    finalPoints1.append(p(line[0].x, line[0].y - signOf(dx)*tailWidth))
                    finalPoints2.append(p(line[0].x, line[0].y + signOf(dx)*tailWidth))
                    finalPoints1.append(p(line[1].x, line[1].y - signOf(dx)*tailWidth))
                    finalPoints2.append(p(line[1].x, line[1].y + signOf(dx)*tailWidth))
                }
            }
        }
        finalPoints2.append(points[points.count - 1])
        finalPoints2.reverse()
        finalPoints1.append(contentsOf: finalPoints2)
        
//        let length = hypot(end.x - start.x, end.y - start.y)
//        let tailLength = length - headLength
//
//        func p(_ x: CGFloat, _ y: CGFloat) -> CGPoint { return CGPoint(x: x, y: y) }
//        let points: [CGPoint] = [
//            p(0, tailWidth / 2),
//            p(tailLength, tailWidth / 2),
//            p(tailLength, headWidth / 2),
//            p(length, 0),
//            p(tailLength, -headWidth / 2),
//            p(tailLength, -tailWidth / 2),
//            p(0, -tailWidth / 2)
//        ]
//
//        let cosine = (end.x - start.x) / length
//        let sine = (end.y - start.y) / length
//        let transform = CGAffineTransform(a: cosine, b: sine, c: -sine, d: cosine, tx: start.x, ty: start.y)
//
        let path = CGMutablePath()
        path.addLines(between: finalPoints1)
        path.closeSubpath()
        return self.init(cgPath: path)
    }
    
}

private func find_lines(points: [CGPoint]) -> [[CGPoint]]{
    var lines = [[CGPoint]]()
    var prev : CGPoint?
    var start: CGPoint?
    var end: CGPoint?
    var horizontal = false
    var vertical = false
    for point in points{
        if prev == nil{
            prev = point
            start = point
            end = point
            continue
        }
        if point.x == prev?.x && horizontal == false{
            if vertical == true{
                print("took horizontal")
                end = prev
                lines.append([start!,end!])
                start = prev
            }
            horizontal = true
            //            end = point
            prev = point
            vertical = false
            continue
        }
        if point.y == prev?.y && vertical == false{
            if horizontal == true{
                print("took vertical")
                end = prev
                lines.append([start!,end!])
                start = prev
            }
            vertical = true
            //            end = point
            prev = point
            horizontal = false
            continue
        }
        if point.x == prev?.x && horizontal == true{
            
        }
        prev = point
    }
    if lines.count == 0{
        lines.append([points[0],points[points.count-1]])
    }
    lines.append([start!,points[points.count - 1]])
    return lines
}
