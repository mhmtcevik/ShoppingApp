//
//  BasketCell.swift
//  ShoppingApp
//
//  Created by Mehmet Çevık on 1.10.2023.
//

import UIKit

import UIKit
import Kingfisher

class BasketCell: UITableViewCell {
    
    enum CellIdentifier: String {
        case identifier = "BasketCell"
    }
    
    let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 15
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
    
    let nameLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    let priceLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .gray
        return label
    }()
    
    let stockLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    let buyingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 5
        return stackView
    }()
    
    let buyingAmountLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    let plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.setImage(UIImage(systemName: "plus")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
        button.addShadow(color: UIColor.shadow, alpha: 0.1)
        return button
    }()
    
    let minusButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.setImage(UIImage(systemName: "minus")?.withRenderingMode(.alwaysOriginal).withTintColor(.black), for: .normal)
        button.addShadow(color: UIColor.shadow, alpha: 0.1)
        return button
    }()
    
    var didTappedPlusButton: (() -> Void)?
    var didTappedMinusButton: (() -> Void)?
    
    func setupButtonActions() {
        minusButton.addTarget(self, action: #selector(minusButtonTapped(_ :)), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusButtonTapped(_ :)), for: .touchUpInside)
    }
    
    @objc
    func minusButtonTapped(_ button: UIButton) {
        didTappedMinusButton?()
    }
    
    @objc
    func plusButtonTapped(_ button: UIButton) {
        didTappedPlusButton?()
    }
    
    func setupCell() {
        self.selectionStyle = .none
        containerStackView.backgroundColor = .clear
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
        //Plus Minus Buttons
        buyingView.addSubview(buyingStackView)
        buyingStackView.addArrangedSubview(minusButton)
        buyingStackView.addArrangedSubview(buyingAmountLabel)
        buyingStackView.addArrangedSubview(plusButton)
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
        
        buyingStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        minusButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        plusButton.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 30, height: 30))
        }
    }

    func setupItems(item: Product) {
        let price = AppConstants.Currency.currency.getPriceString(price: String(describing: item.price))
        priceLabel.text = price
        stockLabel.text = "Stock: \(item.quantity)"
        nameLabel.text = item.title
        buyingAmountLabel.text = "\(AppConstants.defaultStockAmount - item.quantity)"
    }
    
    func updateMinusPlusButton(item: Product) {
        if item.quantity == 0 {
            minusButton.isUserInteractionEnabled = true
            plusButton.isUserInteractionEnabled = false
            
            minusButton.backgroundColor = .white
            plusButton.backgroundColor = .red
            
        } else if item.quantity == AppConstants.defaultStockAmount {
            minusButton.isUserInteractionEnabled = false
            plusButton.isUserInteractionEnabled = true
            
            minusButton.backgroundColor = .red
            plusButton.backgroundColor = .white
        } else {
            minusButton.isUserInteractionEnabled = true
            plusButton.isUserInteractionEnabled = true
            
            minusButton.backgroundColor = .white
            plusButton.backgroundColor = .white
        }
    }
    
    
    func fetchImages(item: Product) {
        guard let imageURLString = item.images.first else { return }
        
        fetchImage(
            urlString: imageURLString,
            size: CGSize(width: 60, height: 60),
            imageView: productImageView)
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
