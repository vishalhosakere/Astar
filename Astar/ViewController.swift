//
//  ViewController.swift
//  Astar
//
//  Created by Vishal Hosakere on 20/03/19.
//  Copyright © 2019 Vishal Hosakere. All rights reserved.
//

import UIKit

//let infinity = 99999

class ViewController: UIViewController , UIGestureRecognizerDelegate{

    var Xsize: CGFloat!
    var Ysize: CGFloat!
    var nodes: [[Node]] = []
    var firstTouch: CGPoint? = nil
    var newView: UIView?
    let gridSize: CGFloat = 20
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var view = UIView(frame: self.view.bounds)
        newView = UIView(frame: self.view.bounds)
        newView?.backgroundColor = UIColor.orange
        self.view.addSubview(newView!)
        view.backgroundColor = UIColor.yellow
//        self.view.addSubview(view)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.delegate = self
        newView!.addGestureRecognizer(tapGesture)
        Xsize = self.view.frame.width
        Ysize = self.view.frame.height
        
        let obsView = UIView(frame: CGRect(x: 10.0*gridSize, y: 10.0*gridSize, width: 10.0*gridSize, height: 10.0*gridSize))
        obsView.backgroundColor = UIColor.black
        self.view.addSubview(obsView)
        
//        for _ in 0..<Int(Ysize/10){
//            var final: [Node] = []
//            for _ in 0..<Int(Xsize/10){
//                let node: Node = Node()
//                node.type = 0
//                final.append(node)
//            }
//            nodes.append(final)
//        }
//
//        for i in 0..<nodes.count{
//            for j in 0..<nodes[i].count{
//                nodes[i][j].x = j
//                nodes[i][j].y = i
//            }
//        }
        resetAllNodes()

    }
    
    @objc func tapAction(_ sender: UITapGestureRecognizer){
        
        if firstTouch == nil{
            print("first touch at \(sender.location(in: self.view))")
            firstTouch = sender.location(in: self.view)
            return
        }
        print("second touch at \(sender.location(in: self.view))")
        let secondTouch = sender.location(in: self.view)
        let path = a_star(_start: nodes[Int(firstTouch!.y/gridSize)][Int(firstTouch!.x/gridSize)], _goal: nodes[Int(secondTouch.y/gridSize)][Int(secondTouch.x/gridSize)])
        
//        let bzpath = UIBezierPath()
////        let mutePath = CGMutablePath()
//
////        var points = [CGPoint]()
//        bzpath.move(to: CGPoint(x: path[0].x*10, y: path[0].y*10))
//        for i in path{
//            bzpath.addLine(to: CGPoint(x: i.x*10, y: i.y*10))
////            points.append(CGPoint(x: i.x*10, y: i.y+10))
//            print("\(i.x) \(i.y)")
//        }
////        mutePath.addLines(between: points)
//        //mutePath.closeSubpath()
        
        var points = [CGPoint]()
        for i in path{
            points.append(CGPoint(x: i.x*Int(gridSize), y: i.y*Int(gridSize)))
        }
        
        let bzpath = UIBezierPath.arrow(points: points, tailWidth: 10, headWidth: 5, headLength: 15)
        
        let layer = CAShapeLayer()
        layer.path = bzpath.cgPath
        layer.fillColor = UIColor.white.cgColor
        layer.strokeColor = UIColor.black.cgColor
        layer.lineWidth = 2.0
        self.view.layer.addSublayer(layer)
        self.view.layer.setNeedsDisplay()
        self.view.layer.displayIfNeeded()
        firstTouch = nil
        resetAllNodes()
        
    }
    
    
    func getneighbor(node : Node) -> [Node]{
        var neighbors : [Node] = []
        let x = node.x
        let y = node.y
        if nodes.checkIndex(num: y-1){
            neighbors.append(nodes[y-1][x])
        }
        if nodes.checkIndex(num: y+1){
            neighbors.append(nodes[y+1][x])
        }
        if nodes.checkIndex(num: x+1){
            neighbors.append(nodes[y][x+1])
        }
        if nodes.checkIndex(num: x-1){
            neighbors.append(nodes[y][x-1])
        }
        
        var realNeighbors: [Node] = []
        for i in neighbors{
            if i.from == nil && i.type != 1{
                realNeighbors.append(i)
            }
        }
        return realNeighbors
    }
    
    
    func heuristicCostEstimate(from: Node, to: Node) -> Int{
        return (abs(from.x - to.x) + abs(from.y - to.y)) * 40
    }
    
    func a_star(_start: Node, _goal: Node) -> [Node]{
        let start = _start
        let goal = _goal
        var closedSet: [Node] = []
        var openSet: [Node] = [start]
        start.g = 0
        start.h = heuristicCostEstimate(from: start, to: goal)
        for node in nodes{
            print(node[0].g)
        }
        while openSet.count != 0 {
            print("inside while")
            var current = lowestFScore()
            if closedSet.count > 0 && openSet.count > 0{
                if current == closedSet[closedSet.count-1]{
                    current = openSet[0]
                }
            }
            
            if current == goal{
                return reconstructPath(current: current)
            }
            
            openSet.removeObjFromArray(object: current)
            closedSet.append(current)
            
            for neighbor in getneighbor(node: current){
                var shouldExec = true
                if closedSet.contains(neighbor){
                    shouldExec = false
                }
                if shouldExec{
                    var tentativeGScore = 0
                    tentativeGScore = current.g + 10
                    if !openSet.contains(neighbor) || tentativeGScore < neighbor.g{
                        neighbor.from = current
                        neighbor.g = tentativeGScore
                        neighbor.h = heuristicCostEstimate(from: neighbor, to: goal)
                        if !openSet.contains(neighbor){
                            openSet.append(neighbor)
                        }
                        
                    }
                    
                }
            }
        }
        return []
    }
    
    func reconstructPath(current: Node) -> [Node] {
        var totalPath: [Node] = [current]
        while let par = totalPath.first!.from {
            totalPath.insert(par, at: 0)
        }
        return totalPath
    }
    
    
    func lowestFScore() -> Node{
        var finalNode: Node = Node()
        finalNode.g = infinity
        finalNode.h = infinity
        
        for i in nodes{
            for j in i{
                if j.f <= finalNode.f && j.g != -100{
                    finalNode = j
                }
            }
        }
        return finalNode
    }

    func resetAllNodes(){
        nodes = []
        for _ in 0..<Int(Ysize/gridSize){
            var final: [Node] = []
            for _ in 0..<Int(Xsize/gridSize){
                let node: Node = Node()
                node.type = 0
                final.append(node)
            }
            nodes.append(final)
        }
        for i in 0..<nodes.count{
            for j in 0..<nodes[i].count{
                if i >= 10{
                    if i <= 20{
                        if j >= 10{
                            
                            if j <= 20{
                                nodes[i][j].type = 1
                            }
                        }
                    }
                }
                nodes[i][j].x = j
                nodes[i][j].y = i
            }
        }
    }
    
}

