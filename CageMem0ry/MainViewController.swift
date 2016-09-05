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
        
        let startButton = UIButton()
        startButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        startButton.titleLabel?.font = UIFont.systemFontOfSize(21)
        startButton.setTitle("开始渗透", forState: .Normal)
        startButton.addTarget(self, action: #selector(MainViewController.onStartTapped), forControlEvents: .TouchUpInside)
        self.view.addSubview(startButton)
        startButton.snp_makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.width.equalTo(150)
            make.height.equalTo(58)
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
