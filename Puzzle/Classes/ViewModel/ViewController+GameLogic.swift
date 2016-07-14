//
//  ViewController+GameLogic.swift
//  Puzzle
//
//  Created by TobyoTenma on 7/14/16.
//  Copyright © 2016 TobyoTenma. All rights reserved.
//
//TODO: showOrginalImage这个方法与其它方法偶合度过高,要解偶

import UIKit

// MARK: - 游戏逻辑处理
extension ViewController {
	/// 显示完整图片
	///
	/// - parameter time: 显示时长
	/// - parameter gameImage: 下一轮游戏图片
	func showOrginalImage (time: UInt64, gameImage: UIImage) {
//        print(#function)
		// 先显示 time 秒钟完整图
		pictureLayerView.layer.contents = gameImage.CGImage

		let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(time * NSEC_PER_SEC))

		dispatch_after(delayTime, dispatch_get_main_queue()) {
			// 移除完整图
			self.pictureLayerView.layer.contents = nil
			// 随机重排 picView
//			self.resortPicViews()

			// TODO: test game part
			self.testGetLastDifferentFromWinArray(&self.picArray, pictureLayerView: self.pictureLayerView, resultPicArray: &self.resultPicArray, preViewW: self.preViewW, preViewH: self.preViewH, locationFrameDic: &self.locationFrameDic, missingPartLocation: &self.missingPartLocation)

			// 为 locationFrameDic 添加右下角缺失的位置的 frame
			self.addMissingPartFrameToLocationFrameDic()
			// 在 resultPicArray 最后面追加一个空白的 view
			self.addPlaceHolderToResultPicture()
		}
	}

	/// 将 gameImage 剪切为 rowNum * colNum 份
	func clipGameImage() {
		print("======>func \(#function)")
		// 创建一个临时的 picArray
		var tempPicArray: [TTAView] = []

		randomNumArray = []
		for index in 0..<rowNum * colNum {
			let rowIndex = index / colNum
			let colIndex = index % rowNum

			let picView = TTAView()

			// 为每个 picView 添加一个 tag 值
			picView.tag = index

			// 给 picView 添加四个方向的手势
			let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
			leftGesture.direction = .Left
			picView.addGestureRecognizer(leftGesture)

			let upGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp))
			upGesture.direction = .Up
			picView.addGestureRecognizer(upGesture)

			let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
			rightGesture.direction = .Right
			picView.addGestureRecognizer(rightGesture)

			let downGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
			downGesture.direction = .Down
			picView.addGestureRecognizer(downGesture)

			// 使picView 显示完整图
			picView.layer.contents = gameImage?.CGImage
			// 从完整图中截取一部分
			picView.layer.contentsRect = CGRect(x: CGFloat(colIndex) * startRatioX, y: CGFloat(rowIndex) * startRatioY, width: startRatioX, height: startRatioY)
			if index == rowNum * colNum - 1 {
				break
			}
			// 准备一个随机数组
			randomNumArray.append(index)
			tempPicArray.append(picView)
		}
		picArray = tempPicArray
	}

	/// 将 picView 随机重新排列
	func resortPicViews() {
//		 print("======>func \(#function)")
//		 print("======>pic  \(picArray.count)")
//		 print("======>rand \(randomNumArray.count)")

		// 声明一个临时结果数组
		var tempResultPicArray: [TTAView] = []

		// 取出一个临时随机数组
		var tempRandomNumArray = randomNumArray
		// 随机重排 picView
		for index in 0..<picArray.count {
			let rowIndex = index / colNum
			let colIndex = index % rowNum

			// 产和随机数
			let num = Int(arc4random_uniform(UInt32(tempRandomNumArray.count)))
			// 取出随机的 picView
			let picView = picArray[tempRandomNumArray.removeAtIndex(num)]
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

	/// 为 locationFrameDic 添加右下角缺失的位置的 frame
	func addMissingPartFrameToLocationFrameDic() {
		// print("======>func \(#function)")
		let missingPartLocationString = NSStringFromCGPoint(CGPoint(x: colNum - 1, y: rowNum - 1))
		// 取出 colNum - 2 与 rowNum - 2位置处的 frame
		let latestFrame = locationFrameDic[NSStringFromCGPoint(CGPoint(x: colNum - 2, y: rowNum - 2))]
		locationFrameDic[missingPartLocationString] = CGRect(origin: CGPoint(x: (latestFrame?.maxX)!, y: (latestFrame?.maxY)!), size: (latestFrame?.size)!)
	}

	/// 在 resultPicArray 最后面追加一个空白的 view
	func addPlaceHolderToResultPicture() {
		// print("======>func \(#function)")
		let placeHolderView = TTAView(frame: CGRect(x: 0, y: 0, width: preViewW, height: preViewH))
		placeHolderView.index = -1
		placeHolderView.tag = -1
		resultPicArray.append(placeHolderView)
	}
}
