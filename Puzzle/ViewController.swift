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

enum MoveDirection {
    case up
    case down
    case left
    case right
}

/// 文件路径
let  filePath = "www.tobyotenma.win/Puzzle/"

/// 图片分割行数
let rowNum = 3
/// 图片分割列数
let colNum = 3

class ViewController: UIViewController {

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
    
    var gameImageW: CGFloat = 0.0
    var gameImageH: CGFloat = 0.0
    
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
    
    
    var preViewW: CGFloat = 0.0
    var preViewH: CGFloat = 0.0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 将 gameImage 剪切为 rowNum * colNum 份
        clipGameImage()
    }
    
    override func viewDidLayoutSubviews() {
        
        gameImageW = pictureLayerView.bounds.size.width
        gameImageH = pictureLayerView.bounds.size.height
        
        preViewW = gameImageW / CGFloat(colNum)
        preViewH = gameImageH / CGFloat(rowNum)
        
        // 随机重排 picView
        // resortPicViews()
        
        // TODO: test game part
        testGetLastDifferentFromWinArray(picArray: &picArray, pictureLayerView: pictureLayerView, resultPicArray: &resultPicArray, preViewW: preViewW, preViewH: preViewH, locationFrameDic: &locationFrameDic, missingPartLocation: &missingPartLocation)
        
        // 为 locationFrameDic 添加右下角缺失的位置的 frame
        addMissingPartFrameToLocationFrameDic()
        // 在 resultPicArray 最后面追加一个空白的 view
        addPlaceHolderToResultPicture()
    }
    
    /// 将 gameImage 剪切为 rowNum * colNum 份
    func clipGameImage() {
        // print("======>func \(#function)")
        for index in 0..<rowNum * colNum {
            let rowIndex = index / colNum
            let colIndex = index % rowNum
            
            let picView = TTAView()
            
            // 为每个 picView 添加一个 tag 值
            picView.tag = index
            
            // 给 picView 添加四个方向的手势
            let leftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
            leftGesture.direction = .left
            picView.addGestureRecognizer(leftGesture)
            
            let upGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp))
            upGesture.direction = .up
            picView.addGestureRecognizer(upGesture)
            
            let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight))
            rightGesture.direction = .right
            picView.addGestureRecognizer(rightGesture)
            
            let downGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
            downGesture.direction = .down
            picView.addGestureRecognizer(downGesture)
            
            // 使picView 显示完整图
            picView.layer.contents = gameImage?.cgImage
            // 从完整图中截取一部分
            picView.layer.contentsRect = CGRect(x: CGFloat(colIndex) * startRatioX , y: CGFloat(rowIndex) * startRatioY, width: startRatioX, height: startRatioY)
            if index == rowNum * colNum - 1 {
                break
            }
            // 准备一个随机数组
            randomNumArray.append(index)
            picArray.append(picView)
        }
    }
    
    /// 将 picView 随机重新排列
    func resortPicViews() {
        // print("======>func \(#function)")
        // print("======>pic  \(picArray.count)")
        
        // print("======>rand \(randomNumArray.count)")
        
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
            let picView = picArray[tempRandomNumArray.remove(at: num)]
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
    func addPlaceHolderToResultPicture(){
        // print("======>func \(#function)")
        let placeHolderView = TTAView(frame: CGRect(x: 0, y: 0, width: preViewW, height: preViewH))
        placeHolderView.index = -1
        placeHolderView.tag = -1
        resultPicArray.append(placeHolderView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - 滑动手势处理事件
extension ViewController {
    /// 左滑手势
    func swipeLeft(leftGesture: UISwipeGestureRecognizer) -> Void {
        let moveView = leftGesture.view as? TTAView
        // 向左移动 picView,计算坐标
        if ((moveView?.location.x)! - 1) == missingPartLocation.x && moveView?.location.y == missingPartLocation.y {
            exchangePicViewLocationInArrayWithIndex(index: (moveView?.index)!, direction: .left)
            movePicView(moveView: moveView!)
        }
    }
    /// 上滑手势
    func swipeUp(upGesture: UISwipeGestureRecognizer) -> Void {
        let moveView = upGesture.view as? TTAView
        // 向右移动 picView,计算坐标
        if ((moveView?.location.y)! - 1) == missingPartLocation.y && moveView?.location.x == missingPartLocation.x {
            exchangePicViewLocationInArrayWithIndex(index: (moveView?.index)!, direction: .up)
            movePicView(moveView: moveView!)
        }
    }
    /// 右滑手势
    func swipeRight(rightGesture: UISwipeGestureRecognizer) -> Void {
        let moveView = rightGesture.view as? TTAView
        // 向右移动 picView,计算坐标
        if ((moveView?.location.x)! + 1) == missingPartLocation.x && moveView?.location.y == missingPartLocation.y {
            exchangePicViewLocationInArrayWithIndex(index: (moveView?.index)!, direction: .right)
            movePicView(moveView: moveView!)
        }
    }
    /// 下滑手势
    func swipeDown(downGesture: UISwipeGestureRecognizer) -> Void {
        let moveView = downGesture.view as? TTAView
        // 向右移动 picView,计算坐标
        if ((moveView?.location.y)! + 1) == missingPartLocation.y && moveView?.location.x == missingPartLocation.x {
            exchangePicViewLocationInArrayWithIndex(index: (moveView?.index)!, direction: .down)
            movePicView(moveView: moveView!)
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
        UIView.animate(withDuration: 0.15) {
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

// MARK: - 游戏事件判断
extension ViewController {
    /// 判断是否完成游戏
    func isFinishGame() {
        // 取出 picView 的tag 存在一个数组中
        var currentResult: [Int] = []
        for picView in resultPicArray {
            let index = picView.tag
            currentResult.append(index)
        }
        print("=======>\(currentResult)\(winArray)")
        
        // 比较结果
        if currentResult == winArray {
            print("=======>\(currentResult)\n\(winArray)")
            print("=======>完成游戏")
            
            // 完成游戏
            finishedTihsTurn()
        }
    }
    
    /// 当前游戏完成后处理
    func finishedTihsTurn() {
        let alert = UIAlertController(title: "恭喜", message: "完成本轮游戏", preferredStyle: .alert)
        let confirm = UIAlertAction(title: "确定", style: .destructive) { (action) in
            // TODO: go to next game
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel) { (action) in
            // TODO: cancel
        }
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - 按钮点击事件
extension ViewController {
    @IBAction func didClickGetNewImage() {
        netImageIndex += 1
//        let urlString = "http://\(filePath)\(netImageIndex).jpg"
        let urlString = "http://www.tobyotenma.win/index.html"
        let url = NSURL(string: urlString)
        var request = URLRequest(url: url as! URL)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            print("======>data: \(data) response: \(response.allHeaderFields) error:\(error)")
        }
        task.resume()
    }
}










