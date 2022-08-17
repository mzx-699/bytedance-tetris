//
//  Common.swift
//  BytedanceTetris
//
//  Created by 麻志翔 on 2022/8/9.
//

import Foundation
import UIKit
//MARK: - 屏幕
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
let SPACE = 10
let TOP_LEN = 44
let BTN_LEN = SCREEN_WIDTH * 0.3
//MARK: - 方块相关
// 行的个数
var ROW_COUNT = 22
// 列的个数
var COLUMN_COUNT = 15
// 没方块的状态
let NO_BLOCK_STATUS = 0

let BLOCKS = [
    // Z
    [
        Block(x: COLUMN_COUNT / 2 - 1 , y:0 , color:1),
        Block(x: COLUMN_COUNT / 2 , y:0 ,color:1),
        Block(x: COLUMN_COUNT / 2 , y:1 ,color:1),
        Block(x: COLUMN_COUNT / 2 + 1 , y:1 , color:1)
    ],
    // 反Z
    [
        Block(x: COLUMN_COUNT / 2 + 1 , y:0 , color:2),
        Block(x: COLUMN_COUNT / 2 , y:0 , color:2),
        Block(x: COLUMN_COUNT / 2 , y:1 , color:2),
        Block(x: COLUMN_COUNT / 2 - 1 , y:1 , color:2)
    ],
    // 田
    [
        Block(x: COLUMN_COUNT / 2 - 1 , y:0 , color:3),
        Block(x: COLUMN_COUNT / 2 , y:0 ,  color:3),
        Block(x: COLUMN_COUNT / 2 - 1 , y:1 , color:3),
        Block(x: COLUMN_COUNT / 2 , y:1 , color:3)
    ],
    // L
    [
        Block(x: COLUMN_COUNT / 2 - 1 , y:0 , color:4),
        Block(x: COLUMN_COUNT / 2 - 1, y:1 , color:4),
        Block(x: COLUMN_COUNT / 2 - 1 , y:2 , color:4),
        Block(x: COLUMN_COUNT / 2 , y:2 , color:4)
    ],
    // 反L
    [
        Block(x: COLUMN_COUNT / 2  , y:0 , color:5),
        Block(x: COLUMN_COUNT / 2 , y:1, color:5),
        Block(x: COLUMN_COUNT / 2  , y:2, color:5),
        Block(x: COLUMN_COUNT / 2 - 1, y:2, color:5)
    ],
    // |
    [
        Block(x: COLUMN_COUNT / 2 , y:0 , color:6),
        Block(x: COLUMN_COUNT / 2 , y:1 , color:6),
        Block(x: COLUMN_COUNT / 2 , y:2 , color:6),
        Block(x: COLUMN_COUNT / 2 , y:3 , color:6)
    ],
    // 反T
    [
        Block(x: COLUMN_COUNT / 2 , y:0 , color:7),
        Block(x: COLUMN_COUNT / 2 - 1 , y:1 , color:7),
        Block(x: COLUMN_COUNT / 2 , y:1 , color:7),
        Block(x: COLUMN_COUNT / 2 + 1, y:1 , color:7)
    ]
]
//定义方块的颜色
let BLOCK_COLORS = [UIColor.white.cgColor,
                    UIColor.red.cgColor,
                    UIColor.green.cgColor ,
                    UIColor.blue.cgColor ,
                    UIColor.orange.cgColor ,
                    UIColor.magenta.cgColor ,
                    UIColor.purple.cgColor ,
                    UIColor.brown.cgColor]


//MARK: - color
func colorRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
    return UIColor(red: red / 256, green: green / 256, blue: blue / 256, alpha: alpha)
}

//MARK: - 重载运算符
// 重载运算符 支持Int + Double运算
func + (left: Int , right:Double) -> Double
{
    return Double(left) + right
}
func - (left: Int , right: Double) -> Double
{
    return Double(left) - right
}
