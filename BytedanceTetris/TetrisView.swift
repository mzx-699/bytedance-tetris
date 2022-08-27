//
//  TetrisView.swift
//  BytedanceTetris
//
//  Created by 麻志翔 on 2022/8/9.
//

import UIKit

class TetrisView: UIView {
    
    // 方格大小
    var cellSize :Int = 0
    
    
    // 绘图上下文
    var ctx: CGContext!
    // 内存中的图片
    var image: UIImage!
    
    

    // 当前出现下落的方块
    var currentBlock:[Block]!
    // 整个方格的状态
    var tetrisStatus : [[Int]] = {
        let row = Array(repeating: NO_BLOCK_STATUS, count: COLUMN_COUNT)
        let status = Array(repeating: row, count: ROW_COUNT)
        return status
    }()
    
    
    //当前的计时器
    var currentTimer: Timer!
    override func layoutSubviews() {
        super.layoutSubviews()
        // 一个小方格的宽度
        self.cellSize = (Int(SCREEN_WIDTH) - 2 * SPACE) / COLUMN_COUNT;
        // 实际的个数
        ROW_COUNT = (Int(SCREEN_WIDTH) - 2 * SPACE) / self.cellSize;
        // 开启绘图
        UIGraphicsBeginImageContext(self.bounds.size)
        self.ctx = UIGraphicsGetCurrentContext()
        // 填充背景色
        self.ctx.setFillColor(UIColor.white.cgColor)
        // 填充大小
        self.ctx.fill(self.bounds)
        // 绘制俄罗斯方块的网格
        createCells(rows: ROW_COUNT, cols:COLUMN_COUNT ,
                    cellWidth :cellSize, cellHeight:cellSize)
        self.image = UIGraphicsGetImageFromCurrentImageContext()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    // setNeedsDisplay时会被触发
    override func draw(_ rect: CGRect) {
        // 获取绘图上下文，才能绘制
        _ = UIGraphicsGetCurrentContext()
        // 将image图片绘制在该组件的左上角
        self.image.draw(at: .zero)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - 绘图
extension TetrisView {
    func createCells(rows:Int, cols:Int , cellWidth :Int, cellHeight:Int) {
        // 开始创建路径
        self.ctx.beginPath()
        // 绘制横向
        for  i in 0...rows {
            self.ctx.move(to: CGPoint(x: 0, y: CGFloat(i * self.cellSize)))
            ctx.addLine(to: CGPoint(x: CGFloat(cols * self.cellSize), y: CGFloat(i * self.cellSize)) )
        }
        
        // 绘制竖向
        for  i in 0...cols {
            self.ctx.move(to: CGPoint(x: CGFloat(i * self.cellSize), y: 0) )
            self.ctx.addLine(to: CGPoint(x: CGFloat(i * self.cellSize), y: CGFloat(rows * self.cellSize)) )
        }
        self.ctx.closePath()
        // 设置笔触颜色
        self.ctx.setStrokeColor(UIColor(red: 0.9,
                                   green: 0.9, blue: 0.9, alpha: 1).cgColor)
        // 设置线条粗细 线粗1.0
        self.ctx.setLineWidth(CGFloat(1.0))
        // 绘制线条
        self.ctx.strokePath()
    }
    
    // 绘制方块的状态
    func drawblock() {
        for i in 0..<ROW_COUNT {
            for j in 0..<COLUMN_COUNT {
                // 有方块的地方绘制颜色
                if self.tetrisStatus[i][j] != NO_BLOCK_STATUS
                {
                    
                    updateCtx(rect: CGRect(x: CGFloat(j * self.cellSize + 1.0) ,
                                           y: CGFloat(i * self.cellSize + 1.0),
                                           width: CGFloat(self.cellSize - 1.0 * 2) ,
                                           height: CGFloat(self.cellSize - 1.0 * 2)),
                                            color: BLOCK_COLORS[self.tetrisStatus[i][j]])
                }
                    // 没有方块的地方绘制白色
                else
                {
                    
                    updateCtx(rect: CGRect(x: CGFloat(j * self.cellSize + 1.0) ,
                                           y: CGFloat(i * self.cellSize + 1.0),
                                           width: CGFloat(self.cellSize - 1.0 * 2) ,
                                           height: CGFloat(self.cellSize - 1.0 * 2)),
                                            color: UIColor.white.cgColor)
                }
            }
        }
    }
    // 绘制
    func updateCtx(rect: CGRect, color: CGColor) {
        //设置填充颜色
        self.ctx.setFillColor(color)
        //绘制矩形
        self.ctx.fill(rect)
    }
    func updateImage() {
        // 获取缓冲区的图片
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        // 刷新视图
        self.setNeedsDisplay()
    }
}

//MARK: - 初始化
extension TetrisView {
    func initTetrisStatus() {
        let row = Array(repeating: NO_BLOCK_STATUS, count: COLUMN_COUNT)
        tetrisStatus = Array(repeating: row, count: ROW_COUNT)
    }
    
    // 随机生成一个下落的方块
    func initBlock() {
        // 随机下标
        let idx = Int(arc4random_uniform(UInt32(BLOCKS.count)))
        // 正在下掉的方块
        self.currentBlock = BLOCKS[idx]
    }
}
