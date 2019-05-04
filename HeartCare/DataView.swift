//
//  DataView.swift
//  HeartCare
//
//  Created by 六神 on 2019/5/3.
//  Copyright © 2019 222. All rights reserved.
//

import UIKit

protocol DataViewDelegate {
    func stopMeasure()
}

class DataView: UIView {

    var dataVal: Int = 0 { didSet { showData() } }
    private var index: Int = 0 {
        didSet {
            if index == 10 {
                index = 0
                delegate?.stopMeasure()
            }
        }
    }
    var delegate: DataViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        basicSetting()
    }
    
    private func basicSetting() {
//        backgroundColor = UIColor.brown
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func showData() {
        if dataVal != 0, index != 10 {
            let bg = getBgView()
            addSubview(bg)
            bg.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(index * 30)
                make.width.height.equalTo(30)
                index += 1
            }
            let la = getDataLabel()
            la.text = "\(dataVal)"
            addSubview(la)
            la.snp.makeConstraints { (make) in
                make.center.equalTo(bg)
            }
        }
    }
    
    private func getBgView() -> UIImageView {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "data_bg")
        imgView.alpha = 0
        UIView.animate(withDuration: 0.3) {
            imgView.alpha = 1
        }
        return imgView
    }
    
    private func getDataLabel() -> UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.sizeToFit()
        label.alpha = 0
        UIView.animate(withDuration: 0.4) {
            label.alpha = 1
        }
        return label
    }
    
    func clearSubViews() {
        for subView in subviews {
            if subView.isKind(of: UIImageView.self) {
                UIView.animate(withDuration: 0.3, animations: {
                    subView.alpha = 0
                }) { (_) in
                    subView.removeFromSuperview()
                }
            }
            if subView.isKind(of: UILabel.self) {
                UIView.animate(withDuration: 0.4, animations: {
                    subView.alpha = 0
                }) { (_) in
                    subView.removeFromSuperview()
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
