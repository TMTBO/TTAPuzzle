//
//  ViewController+GestureProcessing.swift
//  Puzzle
//
//  Created by TobyoTenma on 7/14/16.
//  Copyright © 2016 TobyoTenma. All rights reserved.
//

import UIKit

///  图片块移动方向
///
///  - up:    向上移动
///  - down:  向下移动
///  - left:  向左移动
///  - right: 向右移动
enum MoveDirection {
    case up
    case down
    case left
    case right
}

// MARK: - 滑动手势处理事件
extension ViewController {
    /// 左滑手势
    func swipeLeft(leftGesture: UISwipeGestureRecognizer) -> Void {
        let moveView = leftGesture.view as? TTAView
        // 向左移动 picView,计算坐标
        if ((moveView?.location.x)! - 1) == missingPartLocation.x && moveView?.location.y == missingPartLocation.y {
            exchangePicViewLocationInArrayWithIndex((moveView?.index)!, direction: .left)
            movePicView(moveView!)
        }
    }
    /// 上滑手势
    func swipeUp(upGesture: UISwipeGestureRecognizer) -> Void {
        let moveView = upGesture.view as? TTAView
        // 向右移动 picView,计算坐标
        if ((moveView?.location.y)! - 1) == missingPartLocation.y && moveView?.location.x == missingPartLocation.x {
            exchangePicViewLocationInArrayWithIndex((moveView?.index)!, direction: .up)
            movePicView(moveView!)
        }
    }
    /// 右滑手势
    func swipeRight(rightGesture: UISwipeGestureRecognizer) -> Void {
        let moveView = rightGesture.view as? TTAView
        // 向右移动 picView,计算坐标
        if ((moveView?.location.x)! + 1) == missingPartLocation.x && moveView?.location.y == missingPartLocation.y {
            exchangePicViewLocationInArrayWithIndex((moveView?.index)!, direction: .right)
            movePicView(moveView!)
        }
    }
    /// 下滑手势
    func swipeDown(downGesture: UISwipeGestureRecognizer) -> Void {
        let moveView = downGesture.view as? TTAView
        // 向右移动 picView,计算坐标
        if ((moveView?.location.y)! + 1) == missingPartLocation.y && moveView?.location.x == missingPartLocation.x {
            exchangePicViewLocationInArrayWithIndex((moveView?.index)!, direction: .down)
            movePicView(moveView!)
        }
    }
    /// 交换 picView 与 missingPart
    ///
    /// @param moveView:  将要移动的 picView
    func movePicView(moveView: TTAView) {
        // 交换两个 location
        let temp = moveView.location
        moveView.location = missingPartLocation
        missingPartLocation = temp
        
        let locationString = NSStringFromCGPoint((moveView.location))
        // 更新 missingPartLocation 位置
        UIView.animateWithDuration(0.15) {
            moveView.frame = self.locationFrameDic[locationString]!
        }
        // 判断是否完成游戏
        isFinishGame()
    }
    /// 上下移动时,交换resultPicArray数组中元素位置
    ///
    /// @param index:       当前移动的 picView 的 index 属性
    /// @param direction:   滑动手势方向
    func exchangePicViewLocationInArrayWithIndex(index: Int, direction: MoveDirection) {
        let tempView = resultPicArray[index]
        switch direction {
        case .up:
            resultPicArray[index] = resultPicArray[index - rowNum]
            resultPicArray[index - rowNum] = tempView
            // 修改 tempView 的 index
            tempView.index = index - rowNum
        case .down:
            resultPicArray[index] = resultPicArray[index + rowNum]
            resultPicArray[index + rowNum] = tempView
            // 修改 tempView 的 index
            tempView.index = index + rowNum
        case .left:
            resultPicArray[index] = resultPicArray[index - 1]
            resultPicArray[index - 1] = tempView
            // 修改 tempView 的 index
            tempView.index = index - 1
        case .right:
            resultPicArray[index] = resultPicArray[index + 1]
            resultPicArray[index + 1] = tempView
            // 修改 tempView 的 index
            tempView.index = index + 1
        }
    }
}

