//
//  HomeTabBarView.swift
//  Lok App
//
//  Created by Vũ Kiên on 15/03/2018.
//  Copyright © 2018 LOK. All rights reserved.
//

import UIKit
import RxSwift

class HomeTabBarView: UIView {
    
    @IBOutlet weak var videoTabView: UIView!
    @IBOutlet weak var videoLabel: UILabel!
    @IBOutlet weak var comicTabView: UIView!
    @IBOutlet weak var comicLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var leadingSelectedConstraint: NSLayoutConstraint!
    
    fileprivate let disposeBag = DisposeBag()
    fileprivate var CONSTANT_CENTER_INDICATOR: CGFloat = 0.0
    fileprivate var contentOffsetX: CGFloat = 0.0

    override func awakeFromNib() {
        super.awakeFromNib()
        self.event()
    }
    
    //MARK: - UI
    func indicator(scrollView: UIScrollView) {
        self.layoutIfNeeded()
        let translation = scrollView.contentOffset.x - self.frame.width
        if translation == 0.0 {
            self.CONSTANT_CENTER_INDICATOR = self.contentOffsetX
        } else {
            self.contentOffsetX = scrollView.contentOffset.x - self.frame.width + self.CONSTANT_CENTER_INDICATOR
        }
        self.leadingSelectedConstraint.constant = self.CONSTANT_CENTER_INDICATOR / 2.0 + translation / 2.0
    }
    
    fileprivate func selected(index: Int) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.leadingSelectedConstraint.constant = CGFloat(index) * (self?.frame.width ?? 0) / 2.0
            self?.videoLabel.textColor = index == 0 ? Lok.Color.Home.TabBar.SELECTED : Lok.Color.Home.TabBar.DESELECTED
            self?.comicLabel.textColor = index == 1 ? Lok.Color.Home.TabBar.SELECTED : Lok.Color.Home.TabBar.DESELECTED
            self?.layoutIfNeeded()
        }
    }
    
    //MARK: - Event
    fileprivate func event() {
        self.videoSelected()
        self.comicSelected()
    }
    
    fileprivate func videoSelected() {
        self.videoTabView.rx.tapGesture().when(.recognized).asObservable().bind { [weak self] (_) in
            self?.selected(index: 0)
        }.disposed(by: self.disposeBag)
    }
    
    fileprivate func comicSelected() {
        self.comicTabView.rx.tapGesture().when(.recognized).asObservable().bind { [weak self] (_) in
            self?.selected(index: 1)
        }.disposed(by: self.disposeBag)
    }

}
