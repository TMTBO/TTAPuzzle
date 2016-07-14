//
//  ViewController.swift
//  Puzzle
//
//  Created by TobyoTenma on 7/11/16.
//  Copyright © 2016 TobyoTenma. All rights reserved.
//
//
/**  逻辑要点:
 1.以 TTAView 的 tag 来记录每一张图的原始位置,并以 index 来记录每一张图的当前位置,
 2.以 resultPicArray 的 tag 值来判断游戏是否结束, 以修改 index 来保存移动后的图片的位置


 */

import UIKit

/// 文件路径
let filePath = "www.tobyotenma.win/Puzzle/"

/// 图片分割行数
let rowNum = 3
/// 图片分割列数
let colNum = 3

class ViewController: UIViewController {
	/// 游戏操作界面 view
	@IBOutlet weak var pictureLayerView: UIView!
	/// 分割后的图片数组
	lazy var picArray: [TTAView] = []
	/// 随机数组
	lazy var randomNumArray: [Int] = []
	/// frame 数组
	lazy var locationFrameDic: [String: CGRect] = [:]
	/// 结果图片数组
	lazy var resultPicArray: [TTAView] = []

	/// 一份占行比率
	let startRatioX = 1.0 / CGFloat(colNum)
	/// 一份占列比率
	let startRatioY = 1.0 / CGFloat(rowNum)

	/// 游戏操作界面的宽度
	var gameImageW: CGFloat = 0.0
	/// 游戏操作界面的高度
	var gameImageH: CGFloat = 0.0
	/// 游戏全图
	var gameImage = UIImage(named: "my_icon_large.png")

	/// 空缺位置
	var missingPartLocation: CGPoint = CGPoint(x: colNum - 1, y: rowNum - 1)
	/// 游戏完成条件对比数组
	var winArray: [Int] {
		get {
			var tempArray: [Int] = []
			for index in 0 ..< rowNum * colNum - 1 {
				tempArray.append(index)
			}
			tempArray.append(-1)
			return tempArray
		}
	}

	var netImageIndex = 0
	/// 游戏中每一张小图的宽度
	var preViewW: CGFloat = 0.0
	/// 游戏中每一张小图的高度
	var preViewH: CGFloat = 0.0

	override func viewDidLoad() {
		super.viewDidLoad()
		// 将 gameImage 剪切为 rowNum * colNum 份
		clipGameImage()
	}

	override func viewDidLayoutSubviews() {
		// 获取游戏操作界面的高度与宽度
		gameImageW = pictureLayerView.bounds.size.width
		gameImageH = pictureLayerView.bounds.size.height
		// 计算每一张小图的宽度与高度
		preViewW = gameImageW / CGFloat(colNum)
		preViewH = gameImageH / CGFloat(rowNum)

	}

	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		// 先显示原图
		showOrginalImage(2, gameImage: gameImage!)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}


