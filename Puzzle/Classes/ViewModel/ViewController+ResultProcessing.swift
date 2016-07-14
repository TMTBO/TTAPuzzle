//
//  ViewController+ResultProcessing.swift
//  Puzzle
//
//  Created by TobyoTenma on 7/14/16.
//  Copyright © 2016 TobyoTenma. All rights reserved.
//

import UIKit

// MARK: - 游戏结果处理
extension ViewController {
    /// 判断是否完成游戏
    func isFinishGame() {
        // 取出 picView 的tag 存在一个数组中
        var currentResult: [Int] = []
        for picView in resultPicArray {
            let index = picView.tag
            currentResult.append(index)
        }
        //		print("=======>\(currentResult)\(winArray)")
        
        // 比较结果
        if currentResult == winArray {
            //			print("=======>\(currentResult)\n\(winArray)")
            //			print("=======>完成游戏")
            
            // 完成游戏
            finishedTihsTurn()
        }
    }
    
    /// 当前游戏完成后处理
    func finishedTihsTurn() {
        let alert = UIAlertController(title: "恭喜完成本轮游戏", message: "是否进入下一轮游戏", preferredStyle: .Alert)
        let confirm = UIAlertAction(title: "下一轮", style: .Destructive) { (action) in
            self.didClickGetNewImage()
        }
        let cancel = UIAlertAction(title: "取消", style: .Cancel) { (action) in
            // TODO: cancel
        }
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        presentViewController(alert, animated: true, completion: nil)
    }
}