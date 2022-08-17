//
//  TetrisViewManager.swift
//  BytedanceTetris
//
//  Created by 麻志翔 on 2022/8/9.
//

import Foundation
import UIKit
import AVFoundation

class TetrisViewManager {
    // 代理对象
    var delegate: TetrisDelegate?
    
    let tetrisView: TetrisView
    // 得分
    var score:Int = 0
    // 速度
    var speed = 1
    

    
    //当前的计时器
    var currentTimer: Timer!
    
    // 消除音乐
    var displayer: AVAudioPlayer = {
        let url = Bundle.main.url(forResource: "shake", withExtension: "wav")
        let player = try! AVAudioPlayer(contentsOf: url!)
        player.numberOfLoops = 0
        return player
    }()
    
    init(tv: TetrisView) {
        self.tetrisView = tv
    }
}

//MARK: - 控制动作
extension TetrisViewManager {
    
    
    func startGame () {
        self.speed = 1
        self.delegate?.updateSpeed(speed: self.speed)
        self.score = 0
        self.delegate?.updateScore(score: self.score)
        self.tetrisView.initTetrisStatus()
        self.tetrisView.initBlock()
        self.currentTimer = Timer.scheduledTimer(timeInterval: 0.6 / Double(self.speed), target: self, selector: #selector(blockMoveDown), userInfo: nil, repeats: true)
   }
    /**
     判断是否有一行已满
     */
    func lineFull() {
        //依次便利每一行
        for i in 0  ..< ROW_COUNT {
            var flag = true
            //遍历当前行的每一个单元格
            for j in 0  ..< COLUMN_COUNT {
                if self.tetrisView.tetrisStatus[i][j] == NO_BLOCK_STATUS {
                    flag = false
                    break
                }
            }
            //如果当前有全部方块了
            if flag {
                //将当前积分增加100
                self.score += 100
                
                self.delegate?.updateScore(score: score)
                
                //如果当前积分达到升级极限升速度
                if self.score >= self.speed * self.speed * 500 {
                    //速度加1
                    self.speed += 1
                    self.delegate?.updateSpeed(speed: self.speed)
                    //让原有计时器失效，开始新的计时器
                    self.currentTimer.invalidate()
                    self.currentTimer = Timer.scheduledTimer(timeInterval: 0.6 / Double(self.speed), target: self, selector: #selector(down), userInfo: nil, repeats: true)
                }
                //把当前行上边的所有方块下移一行
                for j in ((0 + 1)...i).reversed() {
                    for k in 0  ..< COLUMN_COUNT {
                        self.tetrisView.tetrisStatus[j][k] = self.tetrisView.tetrisStatus[j-1][k]
                    }
                }
                //播放消除方块的音乐
                if !self.displayer.isPlaying {
                    self.displayer.play()
                }
            }
        }
    }
    
    @objc func blockMoveDown() {
        //定义向下的旗标
        var canDown = true
        
        //判断当前的的滑块是不是可以下滑
        for i in 0  ..< self.tetrisView.currentBlock.count {
            
            //判断是否已经到底了
            if self.tetrisView.currentBlock[i].y >= ROW_COUNT - 1
            {
                canDown = false
                break
            }
            
            //判断下一个是不是有方块
            if self.tetrisView.tetrisStatus[self.tetrisView.currentBlock[i].y + 1][self.tetrisView.currentBlock[i].x] != NO_BLOCK_STATUS
            {
                canDown = false
                break
            }
        }
        
        if canDown {
            
            self.tetrisView.drawblock()
            //将下移前的方块白色
            for i in 0  ..< self.tetrisView.currentBlock.count {
                
                let cur = self.tetrisView.currentBlock[i]
                self.tetrisView.updateCtx(rect: CGRect(x: CGFloat(cur.x * self.tetrisView.cellSize + 1.0) ,
                                                       y: CGFloat(cur.y * self.tetrisView.cellSize + 1.0),
                                                       width: CGFloat(self.tetrisView.cellSize - 1.0 * 2) ,
                                                       height: CGFloat(self.tetrisView.cellSize - 1.0 * 2)),
                                                        color: UIColor.white.cgColor)
            }
            
            //遍历每个方块，控制每个方块的y坐标加1
            for i in 0  ..< self.tetrisView.currentBlock.count {
                self.tetrisView.currentBlock[i].y += 1
            }
            //将下移的每个方块的背景涂成方块的颜色
            for i in 0  ..< self.tetrisView.currentBlock.count {
                
                let cur = self.tetrisView.currentBlock[i]
                self.tetrisView.updateCtx(rect: CGRect(x: CGFloat(cur.x * self.tetrisView.cellSize + 1.0) ,
                                                       y: CGFloat(cur.y * self.tetrisView.cellSize + 1.0),
                                                       width: CGFloat(self.tetrisView.cellSize - 1.0 * 2),
                                                       height: CGFloat(self.tetrisView.cellSize - 1.0 * 2)),
                                                        color: BLOCK_COLORS[cur.color])
            }
        } else { // 不能下落
            
            //遍历每个方块，把每个方块的值记录到tetris_status数组中
            for i in 0  ..< self.tetrisView.currentBlock.count {
                let cur = self.tetrisView.currentBlock[i]
                //如果有方块在最上边了，表明已经输了
                if cur.y < 2 {
                    currentTimer.invalidate()
                    delegate?.gameFail()
                    //显示提示框
                    let alert = UIAlertController(title: "游戏结束", message: "游戏已经结束，点击重新开始", preferredStyle:UIAlertController.Style.alert )
                    
                    let yeslAction = UIAlertAction(title: "重新开始", style: UIAlertAction.Style.default, handler: { (UIAlertAction) -> Void in
                        self.startGame()
                    })
                    
                    alert.addAction(yeslAction)
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    return
                    
                }
                //把每个方块当前所在的位置赋为当前方块的颜色值
                self.tetrisView.tetrisStatus[cur.y][cur.x] = cur.color
                
            }
            //判断是不是可消除
            lineFull()
            
            //开始新一组方块
            tetrisView.initBlock()
        }
        tetrisView.updateImage()
    }
}


//MARK: - move
extension TetrisViewManager {
    
    // 往下
    @objc func down() {
        //定义向下的旗标
        var canDown = true

        //判断当前的的滑块是不是可以下滑
        for i in 0  ..< self.tetrisView.currentBlock.count {
            //判断是否已经到底了
            if self.tetrisView.currentBlock[i].y >= ROW_COUNT - 1 {
                canDown = false
                break
            }
            
            //判断下一个是不是有方块
            if self.tetrisView.tetrisStatus[self.tetrisView.currentBlock[i].y + 1][self.tetrisView.currentBlock[i].x] != NO_BLOCK_STATUS {
                canDown = false
                break
            }
        }
        
        if canDown {
            
            tetrisView.drawblock()
            //将下移前的方块白色
            for i in 0  ..< self.tetrisView.currentBlock.count {
                
                let cur = self.tetrisView.currentBlock[i]
                tetrisView.updateCtx(rect: CGRect(x: CGFloat(cur.x * self.tetrisView.cellSize + 1.0) ,
                                                       y: CGFloat(cur.y * self.tetrisView.cellSize + 1.0),
                                                       width: CGFloat(self.tetrisView.cellSize - 1.0 * 2) ,
                                                       height: CGFloat(self.tetrisView.cellSize - 1.0 * 2)),
                                                        color: UIColor.white.cgColor)
            }
            
            //遍历每个方块，控制每个方块的y坐标加1
            for i in 0  ..< self.tetrisView.currentBlock.count {
                self.tetrisView.currentBlock[i].y += 1
            }
            //将下移的每个方块的背景涂成方块的颜色
            for i in 0  ..< self.tetrisView.currentBlock.count {
                
                let cur = self.tetrisView.currentBlock[i]
                tetrisView.updateCtx(rect: CGRect(x: CGFloat(cur.x * self.tetrisView.cellSize + 1.0) ,
                                                       y: CGFloat(cur.y * self.tetrisView.cellSize + 1.0),
                                                       width: CGFloat(self.tetrisView.cellSize - 1.0 * 2) ,
                                                       height: CGFloat(self.tetrisView.cellSize - 1.0 * 2)),
                                                        color: BLOCK_COLORS[cur.color])
            }
        }
        //不能下落
        else {
            
            //遍历每个方块，把每个方块的值记录到tetris_status数组中
            for i in 0  ..< self.tetrisView.currentBlock.count {
                let cur = self.tetrisView.currentBlock[i]
                //如果有方块在最上边了，表明已经输了
                if cur.y < 2 {
                    currentTimer.invalidate()
                    delegate?.gameFail()
                    //显示提示框
                    let alert = UIAlertController(title: "游戏结束", message: "游戏已经结束，点击重新开始", preferredStyle:UIAlertController.Style.alert )
                    
                    let yeslAction = UIAlertAction(title: "重新开始", style: UIAlertAction.Style.default, handler: { (UIAlertAction) -> Void in
                        self.startGame()
                    })
                    
                    alert.addAction(yeslAction)
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                    return
                    
                }
                //把每个方块当前所在的位置赋为当前方块的颜色值
                self.tetrisView.tetrisStatus[cur.y][cur.x] = cur.color
                
            }
            //判断是不是可消除
            lineFull()
            
            //开始新一组方块
            self.tetrisView.initBlock()
        }
        self.tetrisView.updateImage()
    }
    // 方块向左移动
    func moveLeft() {
        
        //定义能否左移
        var canLeft = true
        for i in 0  ..< self.tetrisView.currentBlock.count {
            //如果已经到了最左边
            if self.tetrisView.currentBlock[i].x <= 0 {
                canLeft = false
                break
            }
            
            //或者左边已经有方块
            if self.tetrisView.tetrisStatus[self.tetrisView.currentBlock[i].y][self.tetrisView.currentBlock[i].x - 1] != NO_BLOCK_STATUS {
                canLeft = false
                break
            }
        }
        
        //如果能左移
        if canLeft {
            self.tetrisView.drawblock()
            //将左移前的方块涂成白色
            for i in 0  ..< self.tetrisView.currentBlock.count {
                let cur = self.tetrisView.currentBlock[i]
                self.tetrisView.updateCtx(rect: CGRect(x: CGFloat(cur.x * self.tetrisView.cellSize + 1.0),
                                                       y: CGFloat(cur.y * self.tetrisView.cellSize + 1.0),
                                                       width: CGFloat(self.tetrisView.cellSize - 1.0 * 2),
                                                       height: CGFloat(self.tetrisView.cellSize - 1.0 * 2)),
                                                        color: UIColor.white.cgColor)
                
            }
            
            //左移所有正在下降的方块
            for i in 0  ..< self.tetrisView.currentBlock.count {
                self.tetrisView.currentBlock[i].x -= 1
            }
            
            //将左移的方块渲染颜色
            for i in 0  ..< self.tetrisView.currentBlock.count {
                let cur = self.tetrisView.currentBlock[i]
                self.tetrisView.updateCtx(rect: CGRect(x: CGFloat(cur.x * self.tetrisView.cellSize + 1.0),
                                                       y: CGFloat(cur.y * self.tetrisView.cellSize + 1.0),
                                                       width: CGFloat(self.tetrisView.cellSize - 1.0 * 2),
                                                       height: CGFloat(self.tetrisView.cellSize - 1.0 * 2)),
                                                        color: BLOCK_COLORS[cur.color])
            }
            self.tetrisView.updateImage()
        }
    }
    
    
    //方块右移的方法
    func moveRight() {
        //定义能否右移
        var canRight = true
        for i in 0  ..< self.tetrisView.currentBlock.count {
            //如果已经到了最右边
            if self.tetrisView.currentBlock[i].x >= COLUMN_COUNT - 1 {
                canRight = false
                break
            }
            
            //右边已经有方块
            if self.tetrisView.tetrisStatus[self.tetrisView.currentBlock[i].y][self.tetrisView.currentBlock[i].x + 1] != NO_BLOCK_STATUS {
                canRight = false
                break
            }
        }
        
        //如果能右移
        if canRight {
            self.tetrisView.drawblock()
            //将左移前的方块涂成白色
            for i in 0  ..< self.tetrisView.currentBlock.count {
                let cur = self.tetrisView.currentBlock[i]
                self.tetrisView.updateCtx(rect: CGRect(x: CGFloat(cur.x * self.tetrisView.cellSize + 1.0),
                                                       y: CGFloat(cur.y * self.tetrisView.cellSize + 1.0),
                                                       width: CGFloat(self.tetrisView.cellSize - 1.0 * 2),
                                                       height: CGFloat(self.tetrisView.cellSize - 1.0 * 2)),
                                                        color: UIColor.white.cgColor)
            }
            
            //右移所有正在下降的方块
            for i in 0  ..< self.tetrisView.currentBlock.count {
                self.tetrisView.currentBlock[i].x += 1
            }
            
            //将右移的方块渲染颜色
            for i in 0  ..< self.tetrisView.currentBlock.count {
                let cur = self.tetrisView.currentBlock[i]
                self.tetrisView.updateCtx(rect: CGRect(x: CGFloat(cur.x * self.tetrisView.cellSize + 1.0),
                                                       y: CGFloat(cur.y * self.tetrisView.cellSize + 1.0),
                                                       width: CGFloat(self.tetrisView.cellSize - 1.0 * 2),
                                                       height: CGFloat(self.tetrisView.cellSize - 1.0 * 2)),
                                                        color: BLOCK_COLORS[cur.color])
            }
            self.tetrisView.updateImage()
        }
    }
    
    //旋转
    func blockRotate() {
        var canRotate = true
        for i in 0 ..< self.tetrisView.currentBlock.count {
            let preX = self.tetrisView.currentBlock[i].x
            let preY = self.tetrisView.currentBlock[i].y
            
            if i != 2 {
                //计算旋转后的坐标
                let afterRotateX = self.tetrisView.currentBlock[2].x + preY - self.tetrisView.currentBlock[2].y
                let afterRotateY = self.tetrisView.currentBlock[2].y + self.tetrisView.currentBlock[2].x - preX
                //如果旋转后的x。y越界或者旋转后的位置已有方块，表明不能旋转
                if afterRotateX < 0 || afterRotateX > COLUMN_COUNT - 1 || afterRotateY < 0 || afterRotateY > ROW_COUNT - 1||self.tetrisView.tetrisStatus[afterRotateY][afterRotateX] != NO_BLOCK_STATUS
                {
                    canRotate = false
                    break
                }
            }
        }
        if canRotate {
            for i in 0  ..< self.tetrisView.currentBlock.count {
                let cur = self.tetrisView.currentBlock[i]
                self.tetrisView.updateCtx(rect: CGRect(x: CGFloat(cur.x * self.tetrisView.cellSize + 1.0),
                                                       y: CGFloat(cur.y * self.tetrisView.cellSize + 1.0),
                                                       width: CGFloat(self.tetrisView.cellSize - 1.0 * 2),
                                                       height: CGFloat(self.tetrisView.cellSize - 1.0 * 2)),
                                                        color: UIColor.white.cgColor)
            }
            
            for i in 0  ..< self.tetrisView.currentBlock.count {
                let preX = self.tetrisView.currentBlock[i].x
                let preY = self.tetrisView.currentBlock[i].y
                
                if i != 2 {
                    self.tetrisView.currentBlock[i].x = self.tetrisView.currentBlock[2].x + preY - self.tetrisView.currentBlock[2].y
                    self.tetrisView.currentBlock[i].y = self.tetrisView.currentBlock[2].y + self.tetrisView.currentBlock[2].x - preX
                }
                
            }
            
            for i in 0  ..< self.tetrisView.currentBlock.count {
                let cur = self.tetrisView.currentBlock[i]
                self.tetrisView.updateCtx(rect: CGRect(x: CGFloat(cur.x * self.tetrisView.cellSize + 1.0),
                                                       y: CGFloat(cur.y * self.tetrisView.cellSize + 1.0),
                                                       width: CGFloat(self.tetrisView.cellSize - 1.0 * 2),
                                                       height: CGFloat(self.tetrisView.cellSize - 1.0 * 2)),
                                                        color: BLOCK_COLORS[cur.color])
            }
            self.tetrisView.updateImage()
        }
    }
}
