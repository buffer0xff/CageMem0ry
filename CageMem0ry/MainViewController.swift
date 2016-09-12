//
//  MainViewController.swift
//  CageMem0ry
//
//  Created by sky on 9/5/16.
//  Copyright © 2016 Cagetest. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.navigationController?.navigationBarHidden = true
        
        let welcomeImageView = UIImageView()
        welcomeImageView.image = UIImage(named: "Welcome")
        self.view.addSubview(welcomeImageView)
        
        let startButton = UIButton()
        startButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        startButton.titleLabel?.font = UIFont.systemFontOfSize(21)
        startButton.setBackgroundImage(UIImage(named: "Start"), forState: .Normal)
        startButton.contentMode = .ScaleAspectFill
        startButton.addTarget(self, action: #selector(MainViewController.onStartTapped), forControlEvents: .TouchUpInside)
        self.view.addSubview(startButton)
        
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 2
        descriptionLabel.textColor = UIColor.lightGrayColor()
        descriptionLabel.text = "翻开两张牌，若这两张牌团相同则成功消除，若图案不\n同则被再次翻面。在30秒内将所有卡牌消除则渗透成功!"
        self.view.addSubview(descriptionLabel)
        
        welcomeImageView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).inset(150)
            make.left.right.equalTo(self.view)
            make.height.equalTo(483)
        }
        
        descriptionLabel.snp_makeConstraints { (make) in
            make.bottom.equalTo(self.view).inset(100)
            make.centerX.equalTo(self.view)
            make.height.equalTo(42)
            make.width.equalTo(421)
        }
        
        startButton.snp_makeConstraints { (make) in
            make.bottom.equalTo(descriptionLabel.snp_top).inset(-30)
            make.centerX.equalTo(self.view)
            make.width.equalTo(268)
            make.height.equalTo(78)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onStartTapped() {
        let gameVC = GameViewController()
        self.navigationController?.pushViewController(gameVC, animated: true)
    }

}
