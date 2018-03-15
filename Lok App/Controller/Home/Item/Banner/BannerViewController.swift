//
//  BannerViewController.swift
//  Lok App
//
//  Created by Vũ Kiên on 15/03/2018.
//  Copyright © 2018 LOK. All rights reserved.
//

import UIKit
import RxSwift
import RxGesture

class BannerViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate let images = BehaviorSubject<[UIImage]>(value: [#imageLiteral(resourceName: "lok_logo"), #imageLiteral(resourceName: "fullsizeoutput_90"), #imageLiteral(resourceName: "27540024_1823764614583644_4375797569109935535_n"), #imageLiteral(resourceName: "28468111_795544373982604_3528749798351931596_n"), #imageLiteral(resourceName: "yb9T3524Resize1")])
    fileprivate let disposeBag = DisposeBag()
    fileprivate let index = BehaviorSubject<Int>(value: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.event()
    }
    
    //MARK: - UI
    fileprivate func setupUI() {
        self.view.layoutIfNeeded()
        self.setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        self.collectionView.delegate = self
        self.images
            .asDriver(onErrorJustReturn: [])
            .drive(self.collectionView.rx.items(cellIdentifier: Lok.CellIdentifier.IMAGE, cellType: BannerCollectionViewCell.self))
            { (index, image, cell) in
                cell.imageView.image = image
            }
            .disposed(by: self.disposeBag)
    }
    
    //MARK: - Event
    fileprivate func event() {
        self.autoScrollCollection()
        self.indexChanged()
        self.panGesture()
    }
    
    fileprivate func autoScrollCollection() {
        Observable<Timer>.create { (observer) -> Disposable in
            let timer = Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true, block: { (timer) in
                observer.onNext(timer)
            })
            return Disposables.create {
                timer.invalidate()
            }
            }
            .flatMap { _ in Observable<(Int, [UIImage])>.combineLatest(Observable<Int>.just(try! self.index.value()), self.images.asObserver(), resultSelector: {($0, $1)})}
            .flatMap { (index, images) in Observable<Int>.just( index < images.count - 1 ? index + 1 : 0) }
            .subscribe(self.index)
            .disposed(by: self.disposeBag)
    }
    
    fileprivate func indexChanged() {
        self.index.bind { [weak self] (index) in
            let indexPath = IndexPath(row: index, section: 0)
            self?.collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
            }.disposed(by: self.disposeBag)
    }
    
    fileprivate func panGesture() {
        self.collectionView
            .rx
            .panGesture()
            .when(.ended)
            .asLocation(in: .this(self.collectionView))
            .flatMap { _ in Observable<UICollectionView>.just(self.collectionView) }
            .flatMap { (collectionView) -> Observable<IndexPath> in
                let rect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
                guard let indexPath = collectionView.indexPathForItem(at: CGPoint(x: rect.midX, y: rect.midY)) else {
                    return Observable.empty()
                }
                return Observable<IndexPath>.just(indexPath)
            }
            .flatMap { indexPath in Observable<Int>.just(indexPath.row) }
            .subscribe(self.index)
            .disposed(by: self.disposeBag)
    }
}

extension BannerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    }
}
