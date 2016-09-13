//
//  ResultsViewController.swift
//  CageMem0ry
//
//  Created by sky on 9/12/16.
//  Copyright © 2016 Cagetest. All rights reserved.
//

import UIKit

protocol ResultsDelegate: NSObjectProtocol {
    func backToWelcome()
}

enum ResultType {
    case Success
    case Failed
}

class ResultsViewController: UIViewController {
    
    weak var delegate: ResultsDelegate?
    
    var type = ResultType.Success
    var time = 0

    var inAnimationDuration = 0.3
    var outAnimationDuration = 0.2
    private var first = true
    
    let decorationView = UIImageView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.modalTransitionStyle = .CrossDissolve
        self.modalPresentationStyle = .OverFullScreen
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(animated: Bool) {
        if first {
            self.first = false
            self.view.userInteractionEnabled = false
            self.view.backgroundColor = UIColor.clearColor()
            UIView.animateWithDuration(self.inAnimationDuration, animations: { () -> Void in
                
                self.view.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.8)
                }, completion: { _ in
                    self.view.userInteractionEnabled = true
            })
            self.prepareResultsView()
        }
    }
    
    func prepareResultsView() {
        let alertView = UIView()
        let banner = UIImageView()
        let timeLabel = UILabel()
        let successDetailLabel = UILabel()
        let failedDetailLabel = UILabel()
        let backButton = UIButton()
        
        alertView.backgroundColor = UIColor.whiteColor()
        timeLabel.textAlignment = .Center
        timeLabel.font = UIFont.boldSystemFontOfSize(24)
        successDetailLabel.textAlignment = .Center
        successDetailLabel.numberOfLines = 0
        successDetailLabel.font = UIFont.boldSystemFontOfSize(32)
        failedDetailLabel.textAlignment = .Center
        failedDetailLabel.font = UIFont.boldSystemFontOfSize(32)
        failedDetailLabel.text = "渗透失败，请再接再厉"
        backButton.setBackgroundImage(UIImage(named: "Back"), forState: .Normal)
        backButton.addTarget(self, action: #selector(ResultsViewController.onBackTapped), forControlEvents: .TouchUpInside)
        decorationView.image = UIImage(named: "Decoration")
        decorationView.frame = CGRectMake(66, 0, 634, 564)
        
        if self.type == .Success {
            failedDetailLabel.hidden = true
            banner.image = UIImage(named: "SuccessBanner")
            timeLabel.text = "花费时间\(self.time)秒"
            successDetailLabel.text = "恭喜你获得称号\n［\(self.getGift())］\n及精美礼品一份"
        } else {
            banner.image = UIImage(named: "FailedBanner")
            timeLabel.hidden = true
            successDetailLabel.hidden = true
            decorationView.hidden = true
        }

        alertView.addSubview(banner)
        alertView.addSubview(timeLabel)
        alertView.addSubview(successDetailLabel)
        alertView.addSubview(failedDetailLabel)
        alertView.addSubview(backButton)
        self.view.addSubview(alertView)
        self.view.addSubview(decorationView)
        
        alertView.snp_makeConstraints { (make) in
            make.top.equalTo(self.view).inset(218)
            make.centerX.equalTo(self.view)
            make.width.height.equalTo(480)
        }
        banner.snp_makeConstraints { (make) in
            make.top.equalTo(alertView).inset(29)
            make.left.right.equalTo(alertView).inset(-46)
            make.height.equalTo(123)
        }
        timeLabel.snp_makeConstraints { (make) in
            make.left.right.equalTo(alertView)
            make.height.equalTo(24)
            make.top.equalTo(banner.snp_bottom).inset(-7)
        }
        successDetailLabel.snp_makeConstraints { (make) in
            make.top.equalTo(banner.snp_bottom).inset(-45)
            make.height.equalTo(135)
            make.left.right.equalTo(alertView)
        }
        failedDetailLabel.snp_makeConstraints { (make) in
            make.top.equalTo(banner.snp_bottom).inset(-80)
            make.height.equalTo(32)
            make.left.right.equalTo(alertView)
        }
        backButton.snp_makeConstraints { (make) in
            make.width.equalTo(340)
            make.height.equalTo(87)
            make.centerX.equalTo(alertView)
            make.bottom.equalTo(alertView).inset(36)
        }
        if self.type == .Success {
            self.animateDecoration()
        }
    }
    
    func cleanUpResultsView() {
        
    }
    
    override func dismissViewControllerAnimated(flag: Bool, completion: (() -> Void)?) {
        self.view.userInteractionEnabled = false
        UIView.animateWithDuration(self.outAnimationDuration, animations: { () -> Void in
            self.view.backgroundColor = UIColor.clearColor()
            }, completion: { (complete) -> Void in
                super.dismissViewControllerAnimated(false) { () -> Void in
                    if let c = completion {
                        c()
                    }
                }
        })
        self.cleanUpResultsView()
        
    }
    
    func onBackTapped() {
        self.dismissViewControllerAnimated(false) { 
            self.delegate?.backToWelcome()
        }
    }
    
    private func animateDecoration() {
        self.addBadassParticle()
        self.decorationView.transform = CGAffineTransformMakeScale(0.3, 0.3)
        UIView.animateWithDuration(0.3, delay: 0.25, options: .CurveEaseIn, animations: { () -> Void in
            self.decorationView.alpha = 1
            }, completion: nil)
        UIView.animateWithDuration(0.5, delay: 0.4, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .CurveEaseIn, animations: { () -> Void in
            self.decorationView.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: nil)
    }
    
    private func getGift() -> String {
        switch self.time {
        case 0...10:
            return "传奇黑客"
        case 11...15:
            return "黑客大师"
        case 16...20:
            return "进阶黑客"
        default:
            return "黑客新手"
        }
    }
    
    private func addBadassParticle() {
        let particleEmitter = CAEmitterLayer()
        
        particleEmitter.emitterPosition = CGPoint(x: view.center.x, y: -96)
        particleEmitter.emitterShape = kCAEmitterLayerLine
        particleEmitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)
        
        let cell = CAEmitterCell()
        cell.name = "cell"
        cell.birthRate = 0
        cell.lifetime = 7.0
        cell.lifetimeRange = 0
        cell.velocity = 350
        cell.velocityRange = 100
        cell.emissionLongitude = CGFloat(M_PI)
        cell.emissionRange = CGFloat(M_PI_4)
        cell.spin = 2
        cell.spinRange = 3
        cell.scaleRange = 0.5
        cell.contents = UIImage(named: "Particle1")?.CGImage
        let cell1 = CAEmitterCell()
        cell1.name = "cell1"
        cell1.birthRate = 0
        cell1.lifetime = 7.0
        cell1.lifetimeRange = 0
        cell1.velocity = 350
        cell1.velocityRange = 100
        cell1.emissionLongitude = CGFloat(M_PI)
        cell1.emissionRange = CGFloat(M_PI_4)
        cell1.spin = 2
        cell1.spinRange = 3
        cell1.scale = 0.5
        cell1.contents = UIImage(named: "Particle4")?.CGImage
        let cell2 = CAEmitterCell()
        cell2.name = "cell2"
        cell2.birthRate = 0
        cell2.lifetime = 7.0
        cell2.lifetimeRange = 0
        cell2.velocity = 350
        cell2.velocityRange = 100
        cell2.emissionLongitude = CGFloat(M_PI)
        cell2.emissionRange = CGFloat(M_PI_4)
        cell2.spin = 2
        cell2.spinRange = 3
        cell2.scale = 0.5
        cell2.contents = UIImage(named: "Particle5")?.CGImage
        
        particleEmitter.emitterCells = [cell,cell1,cell2]
        self.view.layer.addSublayer(particleEmitter)
        particleEmitter.beginTime = CACurrentMediaTime()
        particleEmitter.setValue(15, forKeyPath: "emitterCells.cell.birthRate")
        particleEmitter.setValue(10, forKeyPath: "emitterCells.cell1.birthRate")
        particleEmitter.setValue(10, forKeyPath: "emitterCells.cell2.birthRate")
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue(), {
            particleEmitter.setValue(200, forKeyPath: "emitterCells.cell.velocity")
            particleEmitter.setValue(200, forKeyPath: "emitterCells.cell1.velocity")
            particleEmitter.setValue(200, forKeyPath: "emitterCells.cell2.velocity")
            particleEmitter.setValue(8, forKeyPath: "emitterCells.cell.birthRate")
            particleEmitter.setValue(3, forKeyPath: "emitterCells.cell1.birthRate")
            particleEmitter.setValue(3, forKeyPath: "emitterCells.cell2.birthRate")
        })
    }

    
}

