//
//  ResultViewModel.swift
//  ShoppingApp
//
//  Created by Mehmet Çevık on 30.09.2023.
//

import Foundation

protocol IResultViewModel {
    var outputController: ResultViewController? { get set }
    var storeService: IStoreService { get }
    var contentService: ContentService { get }
    
    func viewDidLoad()
    func controllerDelegate(controller: ResultViewController)
    func resetSaveData(completion: @escaping ()-> Void)
}

class ResultViewModel: IResultViewModel {
    
    var storeService: IStoreService
    var contentService: ContentService
    var outputController: ResultViewController?
    
    init() {
        storeService = StoreService()
        contentService = ContentService.shared
    }
    
    func controllerDelegate(controller: ResultViewController) {
        outputController = controller
    }
    
    func viewDidLoad() {
        outputController?.goRoot()
    }
    
    func resetSaveData(completion: @escaping ()-> Void) {
        self.storeService.fetchProductsData() { [weak self] products in
            self?.contentService.products = products ?? []
            self?.contentService.basketItems = []
            completion()
        }
    }
    
}
