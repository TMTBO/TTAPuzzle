//
//  TTATestFunction.swift
//  Puzzle
//
//  Created by TobyoTenma on 7/13/16.
//  Copyright © 2016 TobyoTenma. All rights reserved.
//

import UIKit

extension UIViewController {
    /// 测试方法
    func testGetLastDifferentFromWinArray(picArray: inout [TTAView], pictureLayerView: UIView, resultPicArray: inout [TTAView], preViewW: CGFloat, preViewH: CGFloat, locationFrameDic: inout [String: CGRect], missingPartLocation: inout CGPoint) {
            // print("======>func \(#function)")
            // print("======>pic  \(picArray.count)")
            
            // print("======>rand \(randomNumArray.count)")
            
            // 声明一个临时结果数组
            var tempResultPicArray: [TTAView] = []
            // 随机重排 picView
            for index in 0..<picArray.count {
                let rowIndex = index / colNum
                let colIndex = index % rowNum

                // 取出随机的 picView
                let picView = picArray[index]
                pictureLayerView.addSubview(picView)
                tempResultPicArray.append(picView)
                
                picView.index = index
                
                // 布局 picView
                picView.frame = CGRect(x: CGFloat(colIndex) * preViewW, y: CGFloat(rowIndex) * preViewH, width: preViewW, height: preViewH)
                
                // 设置 picView 的坐标, 以横向为 x,纵向为 y
                picView.location = CGPoint(x: colIndex, y: rowIndex)
                
                // 将 frame 以 location 为 key 存入到字典中
                let locationString = NSStringFromCGPoint(picView.location)
                locationFrameDic[locationString] = picView.frame
            }
            // 将临时结果数组赋值给结果数组
            resultPicArray = tempResultPicArray
            // print("======>pic2  \(picArray.count)")
            // print("======>subviews  \(pictureLayerView.subviews.count)")
    }

}
