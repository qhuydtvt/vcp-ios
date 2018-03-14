//
//  ComicRepository.swift
//  Lok App
//
//  Created by Vũ Kiên on 13/03/2018.
//  Copyright © 2018 LOK. All rights reserved.
//

import Foundation
import RxSwift
import Realm

protocol ComicRepository {
    func getAll() -> Observable<[Comic]>
    
    func get(id: Int) -> Observable<Comic>
    
    func save(comic: Comic) -> Observable<()>
    
    func save(comics: [Comic]) -> Observable<()>
    
    func delete(id: Int) -> Observable<()>
    
    func deleteAll() -> Observable<()>
}

class ComicRepositoryImplement: Database, ComicRepository {
    
    static let `default` = ComicRepositoryImplement()
    
    fileprivate override init() {
        super.init()
    }
    
    func getAll() -> Observable<[Comic]> {
        return Observable<[Comic]>
            .from(optional:
                self.realm?
                    .objects(ComicObject.self)
                    .flatMap({$0.asDomain()}
                )
        )
    }
    
    func get(id: Int) -> Observable<Comic> {
        return Observable<Comic>
            .from(optional:
                self.realm?
                    .objects(ComicObject.self)
                    .filter("id = %@", id)
                    .flatMap({$0.asDomain()})
                    .first
        )
    }
    
    func save(comic: Comic) -> Observable<()> {
        return Observable<()>.create { [weak self] (observer) -> Disposable in
            do {
                try self?.realm?.write { [weak self] in
                    self?.realm?.add(comic.asObject(), update: true)
                }
                observer.onNext(())
            } catch {
                observer.onError(error)
            }
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func save(comics: [Comic]) -> Observable<()> {
        return Observable<()>.create({ [weak self] (observer) -> Disposable in
            do {
                try self?.realm?.write { [weak self] in
                    self?.realm?.add(comics.flatMap({$0.asObject()}), update: true)
                }
                observer.onNext(())
            } catch {
                observer.onError(error)
            }
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    func delete(id: Int) -> Observable<()> {
        return self.get(id: id).flatMap({ [weak self] (comic) -> Observable<()> in
            return Observable<()>.create({ [weak self] (observer) -> Disposable in
                do {
                    try self?.realm?.write { [weak self] in
                        self?.realm?.delete(comic.asObject())
                    }
                    observer.onNext(())
                } catch {
                    observer.onError(error)
                }
                observer.onCompleted()
                return Disposables.create()
            })
        })
    }
    
    func deleteAll() -> Observable<()> {
        return self.getAll().flatMap({ (comics) -> Observable<()> in
            return Observable<()>.create({ [weak self] (observer) -> Disposable in
                do {
                    try self?.realm?.write { [weak self] in
                        self?.realm?.delete(comics.flatMap({$0.asObject()}))
                    }
                    observer.onNext(())
                } catch {
                    observer.onError(error)
                }
                observer.onCompleted()
                return Disposables.create()
            })
        })
    }
}
