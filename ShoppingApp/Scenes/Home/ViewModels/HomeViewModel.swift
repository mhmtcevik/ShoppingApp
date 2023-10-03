//
//  HomeViewModel.swift
//  ShoppingApp
//
//  Created by Mehmet Çevık on 30.09.2023.
//

import Foundation

protocol IHomeViewModel {
    var storeService: IStoreService { get }
    var contentService: ContentService { get }
    var controllerOutput: HomeControllerOutput? { get }
    
    func setDelegate(controller: HomeControllerOutput)
    func fetchProducts()
    func fetchCategories()
    func categoriesLoadingStatus() ///if the value isLoading it continues.
    func updateBasket(product: Product)
    func createBasketViewModel()
    func viewWillAppear()
}

final class HomeViewModel: IHomeViewModel {
    
    var controllerOutput: HomeControllerOutput?
    var storeService: IStoreService
    var contentService: ContentService

    private var isLoading: Bool = false
    
    init() {
        storeService = StoreService()
        contentService = ContentService.shared
    }
    
    func fetchProducts() {
        storeService.fetchProductsData() { [weak self] products in
            self?.contentService.products = products ?? []
            self?.controllerOutput?.saveProductData(result: self?.contentService.products ?? [])
        }
    }
    
    func updateBasket(product: Product) {
        self.contentService.basketItems.append(product.id)
        
        self.contentService.products = self.contentService.products.map { item in
            var updatedProduct = item
            
            if updatedProduct.id == product.id && updatedProduct.quantity > 0 {
                updatedProduct.quantity -= 1
            }
            return updatedProduct
        }
        
        self.controllerOutput?.saveProductData(result: self.contentService.products)
        self.controllerOutput?.updateBasketData(basketData: self.contentService.basketItems)
    }
    
    func fetchCategories() {
        isLoading = true
        categoriesLoadingStatus()
        
        storeService.fetchCategoriesData() { [weak self] categories in
            self?.isLoading = false
            self?.categoriesLoadingStatus()
            self?.contentService.categories = categories ?? []
            self?.controllerOutput?.saveCategoriesData(result: self?.contentService.categories ?? [])
        }
    }
    
    
    func categoriesLoadingStatus() {
        controllerOutput?.loadingStatus(status: isLoading)
    }
    
    func setDelegate(controller: HomeControllerOutput) {
        controllerOutput = controller
    }
    
    func createBasketViewModel() {
        controllerOutput?.basketViewModel = BasketViewModel()
    }
    
    func viewWillAppear() {
        controllerOutput?.saveProductData(result: self.contentService.products)
        controllerOutput?.updateBasketData(basketData: self.contentService.basketItems)
    }
    
}
