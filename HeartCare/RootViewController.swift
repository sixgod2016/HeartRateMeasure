//
//  RootViewController.swift
//  HeartCare
//
//  Created by 222 on 2019/4/13.
//  Copyright © 2019 222. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    private lazy var maskView: UIView = {
        let view = UIView()
        view.frame = UIScreen.main.bounds
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        return view
    }()
    
    private lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.animationImages = [#imageLiteral(resourceName: "1"), #imageLiteral(resourceName: "2"), #imageLiteral(resourceName: "3")]
        imgView.animationDuration = 2
        imgView.animationRepeatCount = 0
        imgView.startAnimating()
        return imgView
    }()

    private lazy var heartLive: HeartLive = {
        let live = HeartLive()
        live.frame = CGRect(x: 10, y: 10 + NAVI_HEIGHT, width: SCREEN_WIDTH - 20, height: 150)
        return live
    }()
    
    private lazy var rateLabel: UILabel = {
        let label = UILabel()
        label.text = "No Data"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var dataView: DataView = {
        let view = DataView(frame: CGRect.zero)
        view.delegate = self
        return view
    }()
    
    private var dataArr = [Int]()
    
    private let operation = CoreDataOperation.instance
    
    private lazy var measureBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("start", for: .normal)
        btn.setTitle("stop", for: .selected)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor = UIColor.black
        btn.addTarget(self, action: #selector(measureBtnClick(_:)), for: .touchUpInside)
        btn.layer.cornerRadius = 50
        btn.layer.masksToBounds = true
        return btn
    }()
    
    override func loadView() {
        super.loadView()
        configureUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
		basicSetting()
        configureHeartBeat()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if getFirstTime() {
            configureAnimation()
            setFirstTime(false)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        makeConstraints()
    }
	
	private func basicSetting() {
        let rightImg = UIImage(named: "history")
        let rightBtn = UIBarButtonItem(image: rightImg, style: .plain, target: self, action: #selector(pushToHistory))
        navigationItem.rightBarButtonItem = rightBtn
	}
    
    private func configureHeartBeat() {
        HeartBeat.shareManager()!.delegate = self
    }
    
    private func configureUI() {
        view.addSubview(heartLive)
        view.addSubview(rateLabel)
        view.addSubview(dataView)
        view.addSubview(measureBtn)
    }
    
    private func configureAnimation() {
        let keyWindow = UIApplication.shared.windows.last
        keyWindow?.addSubview(maskView)
        maskView.addSubview(imgView)
        imgView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: SCREEN_WIDTH - 150, height: SCREEN_WIDTH - 150))
            make.center.equalToSuperview()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.5) {
            self.maskView.removeFromSuperview()
        }
    }
    
    private func makeConstraints() {
        rateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(heartLive.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        
        dataView.snp.makeConstraints { (make) in
            make.top.equalTo(rateLabel.snp.bottom).offset(25)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 30 * 10, height: 30))

        }
        
        measureBtn.snp.makeConstraints { (make) in
            make.top.equalTo(rateLabel.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
    }
    
    @objc private func pushToHistory() {
        let next = HistoryViewController()
        navigationController?.pushViewController(next, animated: true)
    }
    
    @objc private func measureBtnClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            dataView.clearSubViews()
            HeartBeat.shareManager()!.start()
        } else {
            HeartBeat.shareManager()!.stop()
        }
    }
}

extension RootViewController: HeartBeatPluginDelegate {
    func startHeartDelegateRatePoint(_ point: [AnyHashable : Any]!) {
        let val = point.values.first as! NSNumber
        heartLive.drawRate(withPoint: val)
    }
    
    func startHeartDelegateRateError(_ error: Error!) {
        print(error.debugDescription)
    }
    
    func startHeartDelegateRateFrequency(_ frequency: Int) {
//        print("瞬时心率：\(frequency)")
        DispatchQueue.main.async {
            self.dataView.dataVal = frequency
            self.rateLabel.text = "Real-time heart rate: \(frequency)"
            self.dataArr.append(frequency)
        }
    }
}

extension RootViewController: DataViewDelegate {
    func stopMeasure() {
        measureBtnClick(measureBtn)
        let result = dataArr.reduce(0) { (val1, val2) -> Int in
            return val1 + val2
        }
        DispatchQueue.main.async {
            self.rateLabel.text = "Average heart rate: \(result / 10)"
        }
        operation.insert(dataArr)
        dataArr.removeAll()
    }
}
