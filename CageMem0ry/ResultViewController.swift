//
//  ResultViewController.swift
//  CageMem0ry
//
//  Created by sky on 9/5/16.
//  Copyright © 2016 Cagetest. All rights reserved.
//

import UIKit

enum ResultType {
    case Success
    case Failed
}

class ResultViewController: UIViewController {

    var type = ResultType.Success
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.setupView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    private func setupView() {
        let titleLabel = UILabel()
        let successDetail = UIView()
        let timeLabel = UILabel()
        let rateLabel = UILabel()
        let rewardLabel = UILabel()
        let failedDetail = UILabel()
        let backButton = UIButton()
        successDetail.addSubview(timeLabel)
        successDetail.addSubview(rateLabel)
        successDetail.addSubview(rewardLabel)
        self.view.addSubview(titleLabel)
        self.view.addSubview(successDetail)
        self.view.addSubview(failedDetail)
        self.view.addSubview(backButton)
        
        titleLabel.text = "渗透成功"
        timeLabel.text = "渗透时间28秒"
        rateLabel.text = "能力评价（进阶黑客）"
        rewardLabel.text = "恭喜你获得小礼品一份"
        backButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        backButton.setTitle("返回首页", forState: .Normal)
        backButton.addTarget(self, action: #selector(ResultViewController.onBackTapped), forControlEvents: .TouchUpInside)
        
        titleLabel.snp_makeConstraints { (make) in
            make.centerY.equalTo(self.view).inset(200)
            make.left.right.equalTo(self.view)
            make.height.equalTo(21)
        }
        successDetail.snp_makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp_bottom)
            make.left.right.equalTo(self.view)
            make.height.equalTo(80)
        }
        failedDetail.snp_makeConstraints { (make) in
            make.height.equalTo(21)
            make.left.right.equalTo(self.view)
            make.center.equalTo(successDetail)
        }
        backButton.snp_makeConstraints { (make) in
            make.top.equalTo(successDetail.snp_bottom)
            make.centerX.equalTo(self.view)
            make.width.equalTo(300)
            make.height.equalTo(58)
        }
        timeLabel.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(successDetail)
            make.height.equalTo(21)
        }
        rateLabel.snp_makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp_bottom)
            make.left.right.equalTo(successDetail)
            make.height.equalTo(21)
        }
        rewardLabel.snp_makeConstraints { (make) in
            make.top.equalTo(rateLabel.snp_bottom)
            make.left.right.equalTo(successDetail)
            make.height.equalTo(21)
        }
    }
    
    func onBackTapped() {
        self.navigationController?.popToRootViewControllerAnimated(false)
    }

}
