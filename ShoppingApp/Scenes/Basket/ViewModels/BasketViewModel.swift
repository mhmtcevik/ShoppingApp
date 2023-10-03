//
//  BasketViewModel.swift
//  ShoppingApp
//
//  Created by Mehmet Çevık on 30.09.2023.
//

import Foundation

enum SetType {
    case minus
    case plus
}

protocol IBasketViewModel {
    var outputController: BasketViewController? { get set}
    var contentService: ContentService { get set }
    
    func saveProductsData()
    func saveBasketItems()
    func setDelegate(controller: BasketViewController)
    func updateBasket(product: Product, type: SetType)
}

class BasketViewModel: IBasketViewModel {
    var contentService: ContentService
    var outputController: BasketViewController?
    
    init() {
        self.contentService = ContentService.shared
    }
    
    func saveProductsData() {
        outputController?.setProductsData(products: contentService.products)
    }
    
    func saveBasketItems() {
        outputController?.setBasketData(basket: contentService.basketItems)
    }
    
    func setDelegate(controller: BasketViewController) {
        self.outputController = controller
    }
    
    func saveSummaryViewData() {
        let basketItemsId = Set(contentService.basketItems)
        let basketArray = basketItemsId.map { $0 }
        
        var totalPrice: Int = 0
        var totalAmount: Int = 0
        
        basketArray.forEach { id in
            let item = contentService.products.filter { $0.id == id }
            
            if let item = item.first {
                let buyingAmount = AppConstants.defaultStockAmount - (item.quantity)
                let price = item.price * buyingAmount
                
                totalPrice += price
                totalAmount += buyingAmount
            }
        }
        
        self.outputController?.setSummaryData(data: (totalPrice, totalAmount))
    }
    
    func updateBasket(product: Product, type: SetType) {
        switch type {
        case .minus:
            contentService.products = self.contentService.products.map { item in
                var updatedProduct = item
                
                if updatedProduct.id == product.id && updatedProduct.quantity < AppConstants.defaultStockAmount {
                    updatedProduct.quantity += 1
                    
                    if let itemIndex = self.contentService.basketItems.firstIndex(of: product.id) {
                        self.contentService.basketItems.remove(at: itemIndex)
                    }
                }
                return updatedProduct
            }
            
        case .plus:
            contentService.products = self.contentService.products.map { item in
                var updatedProduct = item
                
                if updatedProduct.id == product.id && updatedProduct.quantity > 0 {
                    updatedProduct.quantity -= 1
                    
                    self.contentService.basketItems.append(product.id)
                }
                return updatedProduct
            }
        }
        self.outputController?.setProductsData(products: self.contentService.products)
        self.outputController?.setBasketData(basket: self.contentService.basketItems)
    }

}
