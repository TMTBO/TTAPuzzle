//
//  TTAView.swift
//  Puzzle
//
//  Created by TobyoTenma on 7/12/16.
//  Copyright © 2016 TobyoTenma. All rights reserved.
//

import UIKit

class TTAView: UIView {
    /// 位置坐标
    var location: CGPoint = CGPoint(x: 0, y: 0)
    /// 重排后位置索引
    var index: Int = 0
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        print("=======>index\(index)  \(location)")
    }
}
