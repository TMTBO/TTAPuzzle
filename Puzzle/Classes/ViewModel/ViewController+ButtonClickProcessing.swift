//
//  ViewController+ButtonClickProcessing.swift
//  Puzzle
//
//  Created by TobyoTenma on 7/14/16.
//  Copyright © 2016 TobyoTenma. All rights reserved.
//

import UIKit

// MARK: - 按钮点击事件
extension ViewController {

	@IBAction func didClickGetNewImage() {
		// 拼接 url 字符串
		let urlString = "http://\(filePath)\(netImageIndex)"

		TTANetworkTool.sharedNetworkTool.GETNetworkResources(urlString, success: { (data, response) in
			// print("======>data: \(data) response: \(response) error:\(error)")

			self.gameImage = UIImage(data: data)

			self.clipGameImage()

			dispatch_async(dispatch_get_main_queue(), {
				// 先移除pictureLayerView 上的所有的子 view
				for picView in self.pictureLayerView.subviews {
					picView.removeFromSuperview()
				}

				if let gameImage = self.gameImage {
					self.showOrginalImage(2, gameImage: gameImage)
				} else {
					// TODO: 显示进阶,colNum,rowNum 加 1
				}
			})

			// 更新从服务获猎取图片的索引
			self.netImageIndex += 1
		}) { (error) in
            //TODO: 处理网请求错误
		}
	}
}