//
//  Database.swift
//  Lok App
//
//  Created by Vũ Kiên on 13/03/2018.
//  Copyright © 2018 LOK. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

class Repository<T: ObjectConvertable, V: Object & ModelConvertable> where T.Object == V, V.Model == T  {
    
    fileprivate var realm: Realm?
    
    static var shared: Repository<T, V> {
        return Repository<T, V>()
    }
    
    fileprivate init() {
        do {
            self.realm = try Realm()
        } catch {
            print("error: \(error.localizedDescription)")
        }
        print(Realm.Configuration.defaultConfiguration.fileURL?.path ?? "")
    }
    
    func get(predicateFormat: String = "", args: Any...) -> Observable<[T]> {
        return Observable<[T]>.just(
            self.realm?
                .objects(V.self)
                .filter(predicateFormat, args)
                .flatMap{ $0.asDomain() } ?? []
        )
    }
    
    func get(id: Int) -> Observable<T?> {
        return self.get(predicateFormat: "id = %@", args: [id])
            .flatMap { Observable<T?>.just($0.first) }
    }
    
    func getAll() -> Observable<[T]> {
        return self.get(args: [])
    }
    
    func save(object: T) -> Observable<()> {
        return Observable<()>.create({ [weak self] (observer) -> Disposable in
            do {
                try self?.realm?.write { [weak self] in
                    self?.realm?.add(object.asObject(), update: true)
                }
                observer.onNext(())
            } catch {
                observer.onError(error)
            }
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    func save(objects: [T]) -> Observable<()> {
        return Observable<()>.create({ [weak self] (observer) -> Disposable in
            do {
                try self?.realm?.write { [weak self] in
                    self?.realm?.add(objects.flatMap { $0.asObject() }, update: true)
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
        return self.get(id: id).flatMap({ [weak self] (domain) -> Observable<()> in
            return Observable<()>.create({ [weak self] (observer) -> Disposable in
                if let domain = domain {
                    do {
                        try self?.realm?.write { [weak self] in
                            self?.realm?.delete(domain.asObject())
                        }
                        observer.onNext(())
                    } catch {
                        observer.onError(error)
                    }
                }
                observer.onCompleted()
                return Disposables.create()
            })
        })
    }
    
    func delete(object: T) -> Observable<()> {
        return Observable<()>.create({ [weak self] (observer) -> Disposable in
            do {
                try self?.realm?.write { [weak self] in
                    self?.realm?.delete(object.asObject())
                }
                observer.onNext(())
            } catch {
                observer.onError(error)
            }
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    func delete(objects: [T]) -> Observable<()> {
        return Observable<()>.create({ [weak self] (observer) -> Disposable in
            do {
                try self?.realm?.write { [weak self] in
                    self?.realm?.delete(objects.flatMap { $0.asObject() })
                }
                observer.onNext(())
            } catch {
                observer.onError(error)
            }
            observer.onCompleted()
            return Disposables.create()
        })
    }
    
    func deleteAll() -> Observable<()> {
        return self.getAll().flatMap({ [weak self] (domains) -> Observable<()> in
            return Observable<()>.create({ [weak self] (observer) -> Disposable in
                do {
                    try self?.realm?.write { [weak self] in
                        self?.realm?.delete(domains.flatMap { $0.asObject() })
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














