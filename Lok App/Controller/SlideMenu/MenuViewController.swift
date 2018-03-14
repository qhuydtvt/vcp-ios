//
//  MenuViewController.swift
//  Lok App
//
//  Created by Vũ Kiên on 14/03/2018.
//  Copyright © 2018 LOK. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let menuOptions = BehaviorRelay<[Int]>(value: [0, 1, 2, 3, 4, 5, 6])
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.menuOptions.asDriver().drive(self.tableView.rx.items(cellIdentifier: "Cell")) { (index, number, cell) in
            cell.textLabel?.text = "\(number)"
        }.disposed(by: self.disposeBag)
    }

}
