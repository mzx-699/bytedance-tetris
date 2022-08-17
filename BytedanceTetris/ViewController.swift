//
//  ViewController.swift
//  BytedanceTetris
//
//  Created by 麻志翔 on 2022/8/5.
//

import UIKit
import AVFoundation
import SnapKit
class ViewController: UIViewController {

    
    var speedLabel : UILabel = {
        let label = UILabel()
        label.text = "当前速度: 0"
        label.font = .systemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    var scoreLabel : UILabel = {
        let label = UILabel()
        label.text = "当前分数: 0"
        label.font = .systemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
    var tetrisViewManager : TetrisViewManager!
    
    var bgMusicPlayer: AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        setupUI()
        self.tetrisViewManager = TetrisViewManager(tv: self.tetrisView)
        self.tetrisViewManager.delegate = self
        self.tetrisViewManager.startGame()
        
        
    }
    //MARK: - ui
    lazy var tetrisView = TetrisView()
    
    lazy var leftBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 20
        btn.setTitle("左", for: .normal)
        btn.setTitleColor(.black, for: UIControl.State())
        btn.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        btn.backgroundColor = colorRGB(red: 189, green: 214, blue: 255, alpha: 1)
        return btn
    }()
    
    lazy var rightBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 20
        btn.setTitle("右", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
        btn.backgroundColor = colorRGB(red: 189, green: 214, blue: 255, alpha: 1)
        return btn
    }()
    
    lazy var downBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 20
        btn.setTitle("下", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(downBtnClick), for: .touchUpInside)
        btn.backgroundColor = colorRGB(red: 189, green: 214, blue: 255, alpha: 1)
        return btn
    }()
    
    lazy var rotateBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 20
        btn.setTitle("旋转", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(rotateBtnClick), for: .touchUpInside)
        btn.backgroundColor = colorRGB(red: 189, green: 214, blue: 255, alpha: 1)
        return btn
    }()

}

//MARK: - TetrisDelegate
extension ViewController: TetrisDelegate {
    func updateScore(score: Int) {
        self.scoreLabel.text = "当前分数: " + String(score)
    }
    
    func updateSpeed(speed: Int) {
        self.speedLabel.text = "当前速度: " + String(speed)
    }
    
    func gameFail() {
        
    }
    
    
}

//MARK: - btn click
extension ViewController {
    //按钮点击事件
    @objc func leftBtnClick() {
        self.tetrisViewManager.moveLeft()
    }
    
    @objc func rightBtnClick() {
        self.tetrisViewManager.moveRight()
    }
    
    @objc func downBtnClick() {
        self.tetrisViewManager.blockMoveDown()
    }
    
    @objc func rotateBtnClick() {
        self.tetrisViewManager.blockRotate()
    }
}
//MARK: - UI
extension ViewController {
    func setupUI() {
        self.view.addSubview(self.speedLabel)
        self.view.addSubview(self.scoreLabel)
        self.view.addSubview(self.tetrisView)
        self.view.addSubview(self.rightBtn)
        self.view.addSubview(self.leftBtn)
        self.view.addSubview(self.downBtn)
        self.view.addSubview(self.rotateBtn)
        
        prepareScoreLabel()
        prepareSpeedLabel()
        prepareTetrisView()
        prepareRightBtn()
        prepareLeftBtn()
        prepareDownBtn()
        prepareRotateBtn()
    }
    func prepareRotateBtn() {
        self.rotateBtn.snp.makeConstraints { make in
            make.left.equalTo(self.downBtn.snp.right).offset(SPACE)
            make.centerY.equalTo(self.rightBtn.snp.centerY)
            make.height.equalTo(self.rightBtn.snp.width)
            make.width.equalTo(self.rightBtn.snp.width)
        }
    }
    func prepareDownBtn() {
        self.downBtn.snp.makeConstraints { make in
            make.left.equalTo(self.view.snp.centerX).offset(SPACE)
            make.centerY.equalTo(self.rightBtn.snp.centerY)
            make.height.equalTo(self.rightBtn.snp.width)
            make.width.equalTo(self.rightBtn.snp.width)
        }
    }
    func prepareLeftBtn() {
        self.leftBtn.snp.makeConstraints { make in
            make.right.equalTo(self.rightBtn.snp.left).offset(-SPACE)
            make.centerY.equalTo(self.rightBtn.snp.centerY)
            make.height.equalTo(self.rightBtn.snp.width)
            make.width.equalTo(self.rightBtn.snp.width)
        }
    }
    func prepareRightBtn() {
        self.rightBtn.snp.makeConstraints { make in
            make.right.equalTo(self.view.snp.centerX).offset(-SPACE)
            make.top.equalTo(self.tetrisView.snp.bottom).offset(3 * SPACE)
            make.height.equalTo(self.view.snp.width).multipliedBy(0.2)
            make.width.equalTo(self.view.snp.width).multipliedBy(0.2)
        }
    }
    func prepareTetrisView() {
        self.tetrisView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.scoreLabel.snp.bottom).offset(Double(SPACE) * 0.5)
            make.left.equalToSuperview().offset(SPACE)
            make.right.equalToSuperview().offset(SPACE)
            make.height.equalTo(self.view.snp.width).offset(-2 * SPACE)
        }
    }
    func prepareSpeedLabel() {
        self.speedLabel.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.left.equalTo(self.view.snp.centerX)
            make.centerY.equalTo(self.scoreLabel.snp.centerY)
            make.height.equalTo(TOP_LEN)
        }
    }
    func prepareScoreLabel() {
        self.scoreLabel.snp.makeConstraints { make in
            make.right.equalTo(self.view.snp.centerX)
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(2 * SPACE)
            make.height.equalTo(TOP_LEN)
        }
    }
    
    
}
