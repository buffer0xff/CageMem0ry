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
                let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
                dispatch_after(delayTime, dispatch_get_main_queue(), {
                    self.imageView.hidden = true
                    self.coverView.hidden = true
                })
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.whiteColor()
        
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(self.imageView)
        self.imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        
        self.coverView.image = UIImage(named: "Cover")
        self.coverView.contentMode = .ScaleAspectFill
        self.coverView.backgroundColor = UIColor.lightGrayColor()
        self.contentView.addSubview(self.coverView)
        self.coverView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.hidden = false
        self.coverView.hidden = false
        self.pokerId = 1
        self.cleared = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //  DEFINE GLOBAL VALUE
    private let BASETIME = 60 // change this value for adjust time
    
    private var gameBoard = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    private let screenWidth = UIScreen.mainScreen().bounds.size.width
    private let screenHeight = UIScreen.mainScreen().bounds.size.height
    private var itemSize = CGSizeZero
    private let timeLable = UILabel()
    private var timer: NSTimer?
    private var time = 60
    private var returnPokers = 0
    
    private let model = Model()
    private var pokers = [UInt]()
    private var lastIndex: NSIndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameBoard = UICollectionView(frame: CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height), collectionViewLayout: UICollectionViewFlowLayout())
        self.gameBoard.showsVerticalScrollIndicator = false
        self.gameBoard.showsHorizontalScrollIndicator = false
        self.gameBoard.scrollEnabled = false
        self.gameBoard.alwaysBounceVertical = false
        self.gameBoard.alwaysBounceHorizontal = false
        self.gameBoard.delegate = self
        self.gameBoard.dataSource = self
        self.gameBoard.registerClass(PokerCell.self, forCellWithReuseIdentifier: "identifier")
        self.gameBoard.backgroundColor = UIColor.whiteColor()
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.gameBoard)
        
        self.timeLable.text = "剩余时间\(self.time)秒"
        self.timeLable.textAlignment = .Center
        self.timeLable.font = UIFont.systemFontOfSize(21)
        self.view.addSubview(self.timeLable)
        self.timeLable.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.view)
            make.top.equalTo(self.view).inset(44)
            make.height.equalTo(21)
        }
        
        let itemWidth = (self.screenWidth - 30*3 - 50*2)/4
        let itemHeight = (self.screenHeight - 64 - 30*3 - 50*2)/4
        self.itemSize = CGSizeMake(itemWidth, itemHeight)
        
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
        self.time = BASETIME
        self.startTimer()
    }
    
    private func startTimer() {
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(resumeTimer), userInfo: nil, repeats: true)
        self.timeLable.text = "剩余时间\(self.time)秒"
    }
    
    func resumeTimer() {
        self.time -= 1
        self.timeLable.text = "剩余时间\(self.time)秒"
        if self.time == 0 {
            self.timer?.invalidate()
            self.timer = nil
            self.time = BASETIME

            let result = ResultViewController()
            result.type = .Failed
            self.navigationController?.pushViewController(result, animated: true)
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pokers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("identifier", forIndexPath: indexPath) as! PokerCell
        cell.backgroundColor = UIColor.grayColor()
        cell.pokerId = self.pokers[indexPath.row]
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(50, 50, 50, 50)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 30
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.itemSize
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let currentCell = collectionView.cellForItemAtIndexPath(indexPath) as! PokerCell
        if currentCell.cleared {
            return
        }
        currentCell.coverView.hidden = true
        if self.lastIndex == nil || indexPath == self.lastIndex {
            self.lastIndex = indexPath
            return
        }
        let lastCell = collectionView.cellForItemAtIndexPath(self.lastIndex!) as! PokerCell
        if currentCell.pokerId == lastCell.pokerId {
            currentCell.cleared = true
            lastCell.cleared = true
            self.returnPokers -= 2
            if self.returnPokers == 0 {
                self.timer?.invalidate()
                self.timer = nil

                let result = ResultViewController()
                result.time = 60-self.time
                result.type = .Success
                self.navigationController?.pushViewController(result, animated: true)
            }
        } else {
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.3 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue(), {
                currentCell.coverView.hidden = false
                lastCell.coverView.hidden = false
            })
        }
        self.lastIndex = nil
    }

}
