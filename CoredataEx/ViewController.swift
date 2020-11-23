//
//  ViewController.swift
//  CoredataEx
//
//  Created by 김종권 on 2020/11/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dataSource = [PersonModel]()
    let personUseCase = PersonRepository() // 실제로 사용할 땐 ViewModel에서 주입하는 형태로 사용

    @IBOutlet weak var tbl: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tbl.delegate = self
        tbl.dataSource = self
        tbl.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell")
//        tbl.register(UITableViewCell.self)
        // Do any additional setup after loading the view.
    }

    @IBAction func btnDelete(_ sender: Any) {
        personUseCase.removeLast()
        dataSource = personUseCase.getPersons()
        tbl.reloadData()
    }

    @IBAction func btnAdd(_ sender: Any) {
        let count = String(describing: personUseCase.count() ?? 0)
        personUseCase.add(id: count, name: count)
        dataSource = personUseCase.getPersons()
        tbl.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")! as UITableViewCell
        cell.textLabel?.text = dataSource[indexPath.row].id + ", " + dataSource[indexPath.row].name
        return cell
    }
}
