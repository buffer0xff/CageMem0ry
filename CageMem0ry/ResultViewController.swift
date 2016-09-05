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

    var type = ResultType.Success {
        didSet {
            if type == .Success {
                self.successDetail.hidden = false
                self.failedDetail.hidden = true
                titleLabel.text = "渗透成功"
            } else {
                self.successDetail.hidden = true
                self.failedDetail.hidden = false
                titleLabel.text = "渗透失败"
                self.failedDetail.text = "渗透失败，请再接再厉"
            }
        }
    }
    var time = 0 {
        didSet {
            if type == .Success {
                timeLabel.text = "渗透时间\(self.time)秒"
                rateLabel.text = "能力评价（\(self.getGift())）"
                giftLabel.text = "恭喜你获得小礼品一份"
            }
        }
    }
    
    private let titleLabel = UILabel()
    private let successDetail = UIView()
    private let timeLabel = UILabel()
    private let rateLabel = UILabel()
    private let giftLabel = UILabel()
    private let failedDetail = UILabel()
    
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
        let backButton = UIButton()
        successDetail.addSubview(timeLabel)
        successDetail.addSubview(rateLabel)
        successDetail.addSubview(giftLabel)
        self.view.addSubview(titleLabel)
        self.view.addSubview(successDetail)
        self.view.addSubview(failedDetail)
        self.view.addSubview(backButton)
        
        titleLabel.textAlignment = .Center
        timeLabel.textAlignment = .Center
        rateLabel.textAlignment = .Center
        giftLabel.textAlignment = .Center
        failedDetail.textAlignment = .Center
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
        giftLabel.snp_makeConstraints { (make) in
            make.top.equalTo(rateLabel.snp_bottom)
            make.left.right.equalTo(successDetail)
            make.height.equalTo(21)
        }
    }
    
    func onBackTapped() {
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
    
    private func getGift() -> String {
        switch self.time {
        case 0...10:
            return "传奇黑客"
        case 11...20:
            return "黑客大师"
        case 21...30:
            return "进阶黑客"
        case 31...40:
            return "普通黑客"
        case 41...50:
            return "黑客新手"
        default:
            return "黑客新手"
        }
    }

}
