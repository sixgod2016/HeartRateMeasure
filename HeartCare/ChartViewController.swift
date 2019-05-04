//
//  ChartViewController.swift
//  HeartCare
//
//  Created by 六神 on 2019/5/3.
//  Copyright © 2019 222. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {
    
    private lazy var chartView: LineChartView = {
        let chart = LineChartView()
        chart.delegate = self
        chart.chartDescription?.enabled = false
        chart.dragEnabled = true
        chart.setScaleEnabled(true)
        chart.pinchZoomEnabled = true
        chart.noDataText = "No Data"
        
        let l = chart.legend
        l.form = .line
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.textColor = MAIN_COLOR
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        
        let xAxis = chart.xAxis
        xAxis.labelFont = .systemFont(ofSize: 11)
        xAxis.labelTextColor = MAIN_COLOR
        xAxis.drawAxisLineEnabled = false
        
        let leftAxis = chart.leftAxis
        leftAxis.labelTextColor = MAIN_COLOR
        leftAxis.axisMaximum = 120
        leftAxis.axisMinimum = 40
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        
        let rightAxis = chart.rightAxis
        rightAxis.labelTextColor = MAIN_COLOR
        rightAxis.axisMaximum = 120
        rightAxis.axisMinimum = 40
        rightAxis.granularityEnabled = false
        
        let limitLine1 = ChartLimitLine(limit: 60, label: "Normal ↑")
        limitLine1.lineWidth = 1
        limitLine1.lineColor = UIColor.red
        limitLine1.lineDashLengths = [4, 2]
        let limitLine2 = ChartLimitLine(limit: 100, label: "Normal ↓")
        limitLine2.lineWidth = 1
        limitLine2.lineColor = UIColor.red
        limitLine2.lineDashLengths = [4, 2]
        chart.leftAxis.addLimitLine(limitLine1)
        chart.leftAxis.addLimitLine(limitLine2)
        return chart
    }()
    
    private let operation = CoreDataOperation.instance
    private var arr: [Record] = [] {
        didSet {
            if arr.count > 0 { setChartViewData() }
        }
    }
    
    override func loadView() {
        super.loadView()
        configureUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicSetting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureData()
        chartView.animate(xAxisDuration: 3)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        chartView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-100)
        }
    }
    
    private func basicSetting() {
        title = "Recent Data"
    }
    
    private func configureData() {
        arr = operation.selectAll()
    }
    
    private func setChartViewData() {
        let yVals = (0 ..< arr.count).map { (i) -> ChartDataEntry in
            let val = arr[i].arr.reduce(0.0, { (val1, val2) -> Double in
                return Double(val1) + Double(val2)
            }) / 10
            return ChartDataEntry(x: Double(i), y: val, data: arr[i].id)
//            return ChartDataEntry(x: Double(i), y: val)
        }
        let set = LineChartDataSet(entries: yVals, label: "Recent Data")
        set.setColor(MAIN_COLOR)
        set.setCircleColor(MAIN_COLOR)
        let data = LineChartData(dataSets: [set])
        chartView.data = data
    }
    
    private func configureUI() {
        view.addSubview(chartView)
    }
    
    
}

extension ChartViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        showMarkerView((entry.data as! Date).toString())
    }
    
    func showMarkerView(_ val: String) {
        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = self.chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        marker.setLabel(val)
        self.chartView.marker = marker
    }
}
