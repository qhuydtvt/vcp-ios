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
    
    fileprivate let menuOptions = BehaviorRelay<[(UIImage, String)]>(value: [
        (Lok.Image.Menu.HOME, Lok.Text.Menu.HOME),
        (Lok.Image.Menu.SERIES, Lok.Text.Menu.SERIES),
        (Lok.Image.Menu.VIDEO, Lok.Text.Menu.VIDEO),
        (Lok.Image.Menu.COMIC, Lok.Text.Menu.COMIC),
        (Lok.Image.Menu.PROJECTS, Lok.Text.Menu.PROJECTS),
        (Lok.Image.Menu.ABOUT, Lok.Text.Menu.ABOUT)
        ])
    fileprivate let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setupUI()
        self.event()
    }
    
    //MARK: - UI
    fileprivate func setupUI() {
        self.menuOptions
            .asDriver()
            .drive(self.tableView.rx.items(cellIdentifier: Lok.CellIdentifier.MENU))
            { (index, option, cell) in
                cell.textLabel?.text = option.1
                cell.imageView?.image = option.0
            }
            .disposed(by: self.disposeBag)
    }
    
    //MARK: - Event
    fileprivate func event() {
        self.tableView
            .rx
            .modelSelected((UIImage, String).self)
            .asDriver()
            .drive(onNext: { [weak self] (image, text) in
                let mainStoryboard = UIStoryboard(name: Lok.Storyboard.MAIN, bundle: nil)
                let mainVC = mainStoryboard.instantiateViewController(withIdentifier: Lok.ViewController.HOME_NAVIGATION)
                self?.slideMenuController()?.changeMainViewController(mainVC, close: true)
            })
            .disposed(by: self.disposeBag)
    }

}
