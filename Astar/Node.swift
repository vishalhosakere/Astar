//
//  nodeView.swift
//  Astar
//
//  Created by Vishal Hosakere on 20/03/19.
//  Copyright © 2019 Vishal Hosakere. All rights reserved.
//

import UIKit

let infinity = 99999

class Node: NSObject {

    private var realType: Int = 0
    var x: Int = 0
    var y: Int = 0
    
    var g: Int = -100
    var h: Int = -100	
    var f: Int {
        get{
            return g+h
        }
    }
    
    var from: Node!
    
    var color: UIColor{
        get{
            if self.type == 0{
                return UIColor.white
            }
            else{
                return UIColor.black
            }
        }
    }
    
    var type: Int {
        set{
            realType = newValue
        }
        get{
            return realType
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
