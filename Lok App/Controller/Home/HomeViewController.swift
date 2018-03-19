//
//  HomeViewController.swift
//  Lok App
//
//  Created by Vũ Kiên on 13/03/2018.
//  Copyright © 2018 LOK. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

class HomeViewController: UIViewController {
    
    //MARK: - Outlet
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var homeTabView: HomeTabBarView!
    
    //MARK: - Properties
    fileprivate let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    //MARK: - View State
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        self.setupUI()
        self.event()
    }
    
    //MARK: - UI
    fileprivate func setupUI() {
        self.setupMenuBar()
    }
    
    fileprivate func setupMenuBar() {
        self.menuButton.setImage(self.menuButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.menuButton.tintColor = Lok.Color.Home.MENU_TINT
    }
    
    //MARK: - Event
    fileprivate func event() {
        self.menuEvent()
    }
    
    fileprivate func menuEvent() {
        self.menuButton.rx.controlEvent(.touchUpInside).asDriver().drive(onNext: { [weak self] (_) in
            self?.slideMenuController()?.openLeft()
        }).disposed(by: self.disposeBag)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
