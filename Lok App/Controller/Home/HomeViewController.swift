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

class HomeViewController: UIViewController {
    
    @IBOutlet weak var menuButton: UIButton!
    
    fileprivate let disposeBag = DisposeBag()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.event()
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
