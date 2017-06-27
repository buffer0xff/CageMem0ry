//
//  GameViewController.swift
//  CagetestMemory
//
//  Created by sky on 9/2/16.
//  Copyright © 2016 Cagetest. All rights reserved.
//

import UIKit
import SnapKit

class PokerCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    let coverView = UIImageView()
    var pokerId: UInt = 1 {
        didSet {
            self.imageView.image = UIImage(named: "\(pokerId)")
        }
    }
    var cleared: Bool = false {
        didSet {
            if cleared {
                let delayTime = DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                    self.imageView.isHidden = true
                    self.coverView.isHidden = true
                })
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.white
        
        self.imageView.contentMode = .scaleAspectFit
        self.imageView.backgroundColor = UIColor.white
        self.contentView.addSubview(self.imageView)
        self.imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        
        self.coverView.image = UIImage(named: "Cover")
        self.coverView.contentMode = .scaleAspectFill
        self.coverView.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(self.coverView)
        self.coverView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.isHidden = false
        self.coverView.isHidden = false
        self.pokerId = 1
        self.cleared = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ResultsDelegate {
    
    //  DEFINE GLOBAL VALUE
    fileprivate let BASETIME = 30 // change this value for adjust time
    
    fileprivate var gameBoard = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    fileprivate let screenWidth = UIScreen.main.bounds.size.width
    fileprivate let screenHeight = UIScreen.main.bounds.size.height
    fileprivate var itemSize = CGSize.zero
    fileprivate let timeLable = UILabel()
    fileprivate var timer: Timer?
    fileprivate var time = 30
    fileprivate var returnPokers = 0
    
    fileprivate let model = Model()
    fileprivate var pokers = [UInt]()
    fileprivate var lastIndex: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameBoard = UICollectionView(frame: CGRect(x: 0, y: 64, width: self.view.frame.size.width, height: self.view.frame.size.height), collectionViewLayout: UICollectionViewFlowLayout())
        self.gameBoard.showsVerticalScrollIndicator = false
        self.gameBoard.showsHorizontalScrollIndicator = false
        self.gameBoard.isScrollEnabled = false
        self.gameBoard.alwaysBounceVertical = false
        self.gameBoard.alwaysBounceHorizontal = false
        self.gameBoard.delegate = self
        self.gameBoard.dataSource = self
        self.gameBoard.register(PokerCell.self, forCellWithReuseIdentifier: "identifier")
        self.gameBoard.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(self.gameBoard)
        
        self.timeLable.text = "剩余时间\(self.time)秒"
        self.timeLable.textAlignment = .center
        self.timeLable.font = UIFont.boldSystemFont(ofSize: 21)
        self.view.addSubview(self.timeLable)
        self.timeLable.snp.makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view).inset(64)
            make.height.equalTo(21)
        }
        
        let restartButton = UIButton()
        restartButton.setTitle("重新开始", for: UIControlState())
        restartButton.setTitleColor(UIColor.black, for: UIControlState())
        restartButton.addTarget(self, action: #selector(GameViewController.backToWelcome), for: .touchUpInside)
        self.view.addSubview(restartButton)
        restartButton.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).inset(30)
            make.top.equalTo(self.view).inset(54)
            make.width.equalTo(100)
            make.height.equalTo(44)
        }
        
        let itemWidth = (self.screenWidth - 30*3 - 50*2)/4
        let itemHeight = (self.screenHeight - 64 - 30*3 - 50*2)/4
        self.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        self.startGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startGame() {
        self.pokers = self.model.getPokers()
        self.returnPokers = self.pokers.count
        print(self.pokers)
        self.lastIndex = nil
        self.gameBoard.reloadData()
        self.timer?.invalidate()
        self.timer = nil
        self.time = BASETIME
        self.startTimer()
    }
    
    fileprivate func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(resumeTimer), userInfo: nil, repeats: true)
        self.timeLable.text = "剩余时间\(self.time)秒"
    }
    
    func resumeTimer() {
        self.time -= 1
        self.timeLable.text = "剩余时间\(self.time)秒"
        if self.time == 0 {
            self.timer?.invalidate()
            self.timer = nil
            self.time = BASETIME

            let result = ResultsViewController()
            result.type = .failed
            result.delegate = self
            self.navigationController?.present(result, animated: false, completion: nil)
        }
    }
    
    fileprivate func showAllPokers() {
        for i in 0...(self.pokers.count - 1) {
            let cell = self.gameBoard.cellForItem(at: IndexPath(row: i, section: 0)) as! PokerCell
            cell.imageView.isHidden = false
            cell.coverView.isHidden = true
        }
    }
    
    // MARK: ResultsDelegate
    
    func backToWelcome() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pokers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath) as! PokerCell
        cell.backgroundColor = UIColor.gray
        cell.pokerId = self.pokers[indexPath.row]
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(50, 50, 50, 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.itemSize
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let currentCell = collectionView.cellForItem(at: indexPath) as! PokerCell
        if currentCell.cleared {
            return
        }
        currentCell.coverView.isHidden = true
        if self.lastIndex == nil || indexPath == self.lastIndex {
            self.lastIndex = indexPath
            return
        }
        let lastCell = collectionView.cellForItem(at: self.lastIndex!) as! PokerCell
        if currentCell.pokerId == lastCell.pokerId {
            currentCell.cleared = true
            lastCell.cleared = true
            self.returnPokers -= 2
            if self.returnPokers == 0 {
                self.timer?.invalidate()
                self.timer = nil

                let result = ResultsViewController()
                result.time = self.BASETIME - self.time
                result.type = .success
                result.delegate = self
                
                let delayTime = DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                    self.showAllPokers()
                })
                self.navigationController?.present(result, animated: false, completion: nil)
            }
        } else {
            let delayTime = DispatchTime.now() + Double(Int64(0.3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                currentCell.coverView.isHidden = false
                lastCell.coverView.isHidden = false
            })
        }
        self.lastIndex = nil
    }

}
