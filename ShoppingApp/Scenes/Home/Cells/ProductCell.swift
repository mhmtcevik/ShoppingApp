//
//  ProductCell.swift
//  ShoppingApp
//
//  Created by Mehmet Çevık on 29.09.2023.
//

import UIKit
import Kingfisher

class ProductCell: UITableViewCell {
    
    enum CellIdentifier: String {
        case identifier = "ProductCell"
    }
    
    let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 15
        stackView.backgroundColor = .clear
        return stackView
    }()
    
    let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    
    let buyingView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .gray
        return label
    }()
    
    let stockLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    let basketButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 5
        button.setTitle("Add to basket", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 11, weight: .semibold)
        return button
    }()
    
    var didTappedBasketButton: (() -> Void)?
    
    func setupCell() {
        self.selectionStyle = .none
        //ContainerStackView
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(productImageView)
        //TitleStackView
        containerStackView.addArrangedSubview(titleStackView)
        titleStackView.addArrangedSubview(nameLabel)
        titleStackView.addArrangedSubview(priceLabel)
        titleStackView.addArrangedSubview(stockLabel)
        //BuyingView
        containerStackView.addArrangedSubview(buyingView)
        buyingView.addSubview(basketButton)
    }
    
    func setupConstraints() {
        containerStackView.snp.makeConstraints { make in
            make.leading.equalTo(20)
            make.trailing.equalTo(-10)
            make.height.equalTo(60)
            make.centerY.equalToSuperview()
        }

        productImageView.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
    
        buyingView.snp.makeConstraints { make in
            make.width.equalTo(100)
        }

        basketButton.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(90)
            make.height.equalTo(30)
        }
    }
    
    func setupButtonActions() {
        basketButton.addTarget(self, action: #selector(basketButtonTapped(_ :)), for: .touchUpInside)
    }
    
    @objc 
    func basketButtonTapped(_ button: UIButton) {
        didTappedBasketButton?()
    }

    func setupItems(item: Product) {
        let price = AppConstants.Currency.currency.getPriceString(price: String(describing: item.price))
        priceLabel.text = price
        stockLabel.text = "Stock: \(item.quantity)" 
        nameLabel.text = item.title
    }
    
    func fetchImages(item: Product) {
        guard let imageURLString = item.images.first else { return }
        
        fetchImage(
            urlString: imageURLString,
            size: CGSize(width: 60, height: 60),
            imageView: productImageView)
        
        addButtonStateControl(item: item)
    }
    
    private func addButtonStateControl(item: Product) {
        basketButton.isUserInteractionEnabled = item.quantity > 0 ?  true : false
        basketButton.backgroundColor = item.quantity > 0 ?  UIColor.orange : UIColor.orange.withAlphaComponent(0.5)
    }
    
    private func fetchImage(urlString: String, size: CGSize, imageView: UIImageView) { 
        let url = URL(string: urlString)
        let processor = DownsamplingImageProcessor(size: size)
                     |> RoundCornerImageProcessor(cornerRadius: 7)
        imageView.kf.indicatorType = .activity
        
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage.gift,
            options: [
                .processor(processor),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
}
