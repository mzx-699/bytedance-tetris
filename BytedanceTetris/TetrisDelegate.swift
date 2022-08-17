//
//  TetrisDelegate.swift
//  BytedanceTetris
//
//  Created by 麻志翔 on 2022/8/9.
//

import Foundation


protocol TetrisDelegate {
    func updateScore(score: Int)
    func updateSpeed(speed: Int)
    func gameFail()
}

