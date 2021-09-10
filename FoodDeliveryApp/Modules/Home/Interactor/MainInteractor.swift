//
//  MainInteractor.swift
//  FoodDeliveryApp
//
//  Created by Evan Beh on 09/09/2021.
//

import UIKit
import Moya
import RxSwift
import ObjectMapper
import RxCocoa


class MainInteractor {
    
    private var provider:MoyaProvider<MenuService>
    
    
    init(provider: MoyaProvider<MenuService> = MoyaProvider<MenuService>() ) {
        
        self.provider = provider
        
        
    }
    
    func fetchFilters() -> Observable<[String]> {
        
        let observer = Observable<[String]>.create { (observe) -> Disposable in
            
            self.provider.request(.getFilter) { result in
                
                
                switch result {
                case let .success(response):
                    do {
                        
                        let value = try response.map([String].self)
                        observe.on(.next(value))
                        return
                        
                    } catch {
                        observe.on(.error(NSError(domain: "Network Error", code: 0, userInfo: nil)))
                        
                        return
                    }
                case .failure(_):
                    observe.on(.error(NSError(domain: "Network Error", code: 0, userInfo: nil)))
                    return
                    
                }
            }
            return Disposables.create()
            
        }
        
        return observer
    }
    
    func fetchCategory() -> Observable<[String]> {
        
        
        let observer = Observable<[String]>.create { (observe) -> Disposable in
            
            self.provider.request(.getCategory) { result in
                
                
                switch result {
                case let .success(response):
                    do {
                        
                        let value = try response.map([String].self)
                        observe.on(.next(value))
                        return
                        
                    } catch {
                        observe.on(.error(NSError(domain: "Network Error", code: 0, userInfo: nil)))
                        
                        return
                    }
                case .failure(_):
                    observe.on(.error(NSError(domain: "Network Error", code: 0, userInfo: nil)))
                    return
                    
                }
            }
            
            return Disposables.create()
        }
        
        return observer
    }
    
    func fetchAds() -> Observable<[String]> {
        
        
        let observer = Observable<[String]>.create { (observe) -> Disposable in
            
            self.provider.request(.getAds) { result in
                
                
                switch result {
                case let .success(response):
                    do {
                        
                        let value = try response.map([String].self)
                        observe.on(.next(value))
                        return
                        
                    } catch {
                        observe.on(.error(NSError(domain: "Network Error", code: 0, userInfo: nil)))
                        
                        return
                    }
                case .failure(_):
                    observe.on(.error(NSError(domain: "Network Error", code: 0, userInfo: nil)))
                    return
                    
                }
            }
            
            return Disposables.create()
            
        }
        
        return observer
    }
    
    func fetchMenus() -> Observable<[MenuModel]> {
        
        let observer = Observable<[MenuModel]>.create { (observe) -> Disposable in
            
            self.provider.request(.getMenu) { result in
                
                
                switch result {
                case let .success(response):
                    do {
                        
                        let value = try response.map([MenuModel].self)
                        observe.on(.next(value))
                        return
                        
                    } catch {
                        observe.on(.error(NSError(domain: "Network Error", code: 0, userInfo: nil)))
                        
                        return
                    }
                case .failure(_):
                    observe.on(.error(NSError(domain: "Network Error", code: 0, userInfo: nil)))
                    return
                    
                }
            }
            
            return Disposables.create()
            
        }
        
        
        return observer
    }
}



