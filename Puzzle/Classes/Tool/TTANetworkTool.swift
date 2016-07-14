//
//  TTANetworkTool.swift
//  Puzzle
//
//  Created by TobyoTenma on 7/14/16.
//  Copyright © 2016 TobyoTenma. All rights reserved.
//

import UIKit

class TTANetworkTool: NSObject {
	/// 创建 TTANetworkTool 单例工具
	static let sharedNetworkTool = TTANetworkTool()

	/// GET 请求网络数据
	///
	/// - parameter urlString: 网络资源 URL 字符串
	/// - parameter success:   成功回调
	/// - parameter failure:   失败回调
	func GETNetworkResources(urlString: String, success: (data: NSData, response: NSURLResponse) -> Void, failure: (error: NSError) -> Void) {
		let url = NSURL(string: urlString)
		let request = NSMutableURLRequest(URL: url!)
		request.HTTPMethod = "GET"
		let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) in

			guard error == nil else {
				failure(error: error!)
				return
			}

			if let data = data, let response = response {
				success(data: data, response: response)
			} else {
				failure(error: error!)
			}
		}
		task.resume()
	}
}
