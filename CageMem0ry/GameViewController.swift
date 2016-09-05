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
                    self.contentView.backgroundColor = UIColor.blackColor()
                })
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView.contentMode = .ScaleAspectFit
        self.imageView.backgroundColor = UIColor.whiteColor()
        self.contentView.addSubview(self.imageView)
        self.imageView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        
        self.coverView.image = UIImage(named: "Cover")
        self.coverView.contentMode = .Center
        self.coverView.backgroundColor = UIColor.darkGrayColor()
        self.contentView.addSubview(self.coverView)
        self.coverView.snp_makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class GameViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var gameBoard = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    let screenHeight = UIScreen.mainScreen().bounds.size.height
    let itemRatio = 0.75  // item width/height
    var itemSize = CGSizeZero
    
    let model = Model()
    var pokers = [UInt]()
    var lastIndex: NSIndexPath?
//    var currentIndex: NSIndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameBoard = UICollectionView(frame: self.view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        self.gameBoard.showsVerticalScrollIndicator = false
        self.gameBoard.showsHorizontalScrollIndicator = false
        self.gameBoard.scrollEnabled = false
        self.gameBoard.alwaysBounceVertical = false
        self.gameBoard.alwaysBounceHorizontal = false
        self.gameBoard.delegate = self
        self.gameBoard.dataSource = self
        self.gameBoard.registerClass(PokerCell.self, forCellWithReuseIdentifier: "identifier")
        self.view.addSubview(self.gameBoard)
        
        let itemWidth = (self.screenWidth - 30*3 - 50*2)/4
        let itemHeight = (self.screenHeight - 30*3 - 50*2)/4
        self.itemSize = CGSizeMake(itemWidth, itemHeight)
        
        self.pokers = self.model.getPokers()
        print(self.pokers)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
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
