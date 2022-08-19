//
//  ViewController.swift
//  BytedanceTetris
//
//  Created by 麻志翔 on 2022/8/5.
//

import UIKit
import AVFoundation
import SnapKit
import SVProgressHUD
class TetrisViewController: UIViewController {

    
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
        btn.setImage(UIImage(named: "left"), for: .normal)
        btn.setTitleColor(.black, for: UIControl.State())
        btn.addTarget(self, action: #selector(leftBtnClick), for: .touchUpInside)
        //btn.backgroundColor = colorRGB(red: 189, green: 214, blue: 255, alpha: 1)
        return btn
    }()
    
    lazy var rightBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 20
        btn.setImage(UIImage(named: "right"), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(rightBtnClick), for: .touchUpInside)
        //btn.backgroundColor = colorRGB(red: 189, green: 214, blue: 255, alpha: 1)
        return btn
    }()
    
    lazy var downBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 20
        btn.setImage(UIImage(named: "down"), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(downBtnClick), for: .touchUpInside)
        //btn.backgroundColor = colorRGB(red: 189, green: 214, blue: 255, alpha: 1)
        return btn
    }()
    
    lazy var rotateBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 20
        btn.setImage(UIImage(named: "rotate"), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(rotateBtnClick), for: .touchUpInside)
        //btn.backgroundColor = colorRGB(red: 189, green: 214, blue: 255, alpha: 1)
        return btn
    }()
    
    lazy var speedUpBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 20
        btn.setImage(UIImage(named: "speedup"), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(speedUpBtnClick), for: .touchUpInside)
        //btn.backgroundColor = colorRGB(red: 189, green: 214, blue: 255, alpha: 1)
        return btn
    }()
    
    lazy var restartBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 20
        btn.setImage(UIImage(named: "restart"), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(restartBtnClick), for: .touchUpInside)
        //btn.backgroundColor = colorRGB(red: 189, green: 214, blue: 255, alpha: 1)
        return btn
    }()
    
    lazy var stopBtn: UIButton = {
        let btn = UIButton()
        btn.layer.cornerRadius = 20
        btn.setImage(UIImage(named: "stop"), for: .normal)
        btn.setImage(UIImage(named: "start"), for: .selected)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(stopBtnClick(sender:)), for: .touchUpInside)
        //btn.backgroundColor = colorRGB(red: 189, green: 214, blue: 255, alpha: 1)
        return btn
    }()

}

//MARK: - TetrisDelegate
extension TetrisViewController: TetrisDelegate {
    func updateScore(score: Int) {
        self.scoreLabel.text = "当前分数: " + String(score)
    }
    
    func updateSpeed(speed: Int) {
        self.speedLabel.text = "当前速度: " + String(speed)
    }
    
    func gameFail() {
        //显示提示框
        let alert = UIAlertController(title: "游戏结束", message: "点击重新开始", preferredStyle:UIAlertController.Style.alert )
        let done = UIAlertAction(title: "重新开始", style: UIAlertAction.Style.default, handler: { (UIAlertAction) -> Void in
            self.tetrisViewManager.startGame()
        })
        alert.addAction(done)
        self.present(alert, animated: false, completion: nil)
    }
    
    
}

//MARK: - btn click
extension TetrisViewController {
    //按钮点击事件
    @objc func leftBtnClick() {
        self.tetrisViewManager.blockMoveLeft()
    }
    
    @objc func rightBtnClick() {
        self.tetrisViewManager.blockMoveRight()
    }
    
    @objc func downBtnClick() {
        self.tetrisViewManager.blockMoveDown()
    }
    
    @objc func rotateBtnClick() {
        self.tetrisViewManager.blockRotate()
    }
    @objc func speedUpBtnClick() {
        self.tetrisViewManager.speedUp()
    }
    @objc func stopBtnClick(sender: UIButton) {
        if sender.isSelected {
            sender.isSelected = false
            self.tetrisViewManager.continueGame()
        } else {
            
            sender.isSelected = true
            self.tetrisViewManager.stopGame()
        }
    }
    
    @objc func restartBtnClick() {
        self.tetrisViewManager.startGame()
    }
}
//MARK: - UI
extension TetrisViewController {
    func setupUI() {
        self.view.addSubview(self.speedLabel)
        self.view.addSubview(self.scoreLabel)
        self.view.addSubview(self.tetrisView)
        self.view.addSubview(self.rightBtn)
        self.view.addSubview(self.leftBtn)
        self.view.addSubview(self.downBtn)
        self.view.addSubview(self.rotateBtn)
        self.view.addSubview(self.restartBtn)
        self.view.addSubview(self.stopBtn)
        self.view.addSubview(self.speedUpBtn)
        
        prepareScoreLabel()
        prepareSpeedLabel()
        prepareTetrisView()
        prepareRightBtn()
        prepareLeftBtn()
        prepareDownBtn()
        prepareRotateBtn()
        prepareRestartBtn()
        prepareStopBtn()
        prepareSpeedUpBtn()
    }
    func prepareSpeedUpBtn() {
        self.speedUpBtn.snp.makeConstraints { make in
            make.centerX.equalTo(self.rightBtn.snp.centerX)
            make.centerY.equalTo(self.restartBtn.snp.centerY)
            make.height.equalTo(self.restartBtn.snp.width)
            make.width.equalTo(self.restartBtn.snp.width)
        }
    }
    func prepareStopBtn() {
        self.stopBtn.snp.makeConstraints { make in
            make.centerY.equalTo(self.restartBtn.snp.centerY)
            make.centerX.equalTo(self.rotateBtn.snp.centerX)
            make.height.equalTo(self.restartBtn.snp.width)
            make.width.equalTo(self.restartBtn.snp.width)
        }
    }
    func prepareRestartBtn() {
        self.restartBtn.snp.makeConstraints { make in
            make.centerX.equalTo(self.downBtn.snp.centerX)
            make.top.equalTo(self.rotateBtn.snp.bottom).offset(2 * SPACE)
            make.height.equalTo(self.rightBtn.snp.width).multipliedBy(0.8)
            make.width.equalTo(self.rightBtn.snp.width).multipliedBy(0.8)
        }
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
