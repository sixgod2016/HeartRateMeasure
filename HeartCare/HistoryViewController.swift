//
//  HistoryViewController.swift
//  HeartCare
//
//  Created by 六神 on 2019/5/4.
//  Copyright © 2019 222. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    private let cellName = "HistoryTableViewCell"
    private lazy var mainTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = UIColor.clear
        table.dataSource = self
        table.delegate = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: cellName)
        return table
    }()
    
    private let operation = CoreDataOperation.instance
    private var arr: [Record] = [] {
        didSet { mainTable.reloadData() }
    }
    
    override func loadView() {
        super.loadView()
        configureUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicSetting()
        configureData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainTable.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func basicSetting() {
        title = "History"
    }
    
    private func configureData() {
         arr = operation.selectAll()
    }
    
    private func configureUI() {
        view.addSubview(mainTable)
    }

}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return arr[section].id.toString()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName, for: indexPath)
        cell.textLabel?.text = "\(arr[indexPath.section].arr)"
        return cell
    }
    
}
