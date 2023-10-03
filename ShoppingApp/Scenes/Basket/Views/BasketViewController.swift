//
//  BasketViewController.swift
//  ShoppingApp
//
//  Created by Mehmet Çevık on 30.09.2023.
//

import UIKit

protocol IBasketController {
    var viewModel: BasketViewModel { get }
    var navigator: Navigator { get }
    var products: [Product] { get set }
    var basketItems: Set<Int> { get set }
    
    func setProductsData(products: [Product])
    func setBasketData(basket: [Int])
    func setSummaryData(data: (Int?, Int?))
}

class BasketViewController: UIViewController, Navigatable {
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "Basket"
        label.font = .systemFont(ofSize: 24)
        label.textColor = .black
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(
            systemName: "chevron.backward")?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(.black), for: .normal)
        return button
    }()
    
    private let listTableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let summaryView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Buy All", for: .normal)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        return button
    }()
    
    private let totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "Total Price: 0"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black.withAlphaComponent(0.7)
        return label
    }()
    
    private let totalProductLabel: UILabel = {
        let label = UILabel()
        label.text = "Number of Products : 0"
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .black.withAlphaComponent(0.7)
        
        return label
    }()
    
    private let summaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Summary"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black.withAlphaComponent(0.5)
        return label
    }()
    
    private let summaryStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.distribution = .fill
        return stackView
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Your basket\n is empty"
        label.numberOfLines = .max
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 30)
        label.textColor = .black.withAlphaComponent(0.5)
    
        return label
    }()
    
    var viewModel: BasketViewModel
    var navigator: Navigator
    var products: [Product] = []
    var basketItems: Set<Int> = []
    
    init(viewModel: BasketViewModel, navigator: Navigator) {
        self.viewModel = viewModel
        self.navigator = navigator
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        configureConstraints()
        setupActions()
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        viewModel.setDelegate(controller: self)
        viewModel.saveBasketItems()
        viewModel.saveProductsData()
        viewModel.saveSummaryViewData()
    }
    
    func setupViews() {
        configureViews()
        
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        listTableView.register(BasketCell.self, forCellReuseIdentifier: BasketCell.CellIdentifier.identifier.rawValue)
    }
    
    func configureViews() {
        view.addSubview(emptyLabel)
        view.addSubview(backButton)
        view.addSubview(topLabel)
        view.addSubview(summaryView)
        
        summaryView.addSubview(buyButton)
        summaryView.addSubview(summaryStackView)
        summaryStackView.addArrangedSubview(summaryLabel)
        summaryStackView.addArrangedSubview(totalPriceLabel)
        summaryStackView.addArrangedSubview(totalProductLabel)
        
        view.addSubview(listTableView)
    }
    
    func setupActions() {
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
    }
    
    func configureConstraints() {
        makeEmptyLabelConstrains()
        
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.height.width.equalTo(40)
        }
        
        topLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(backButton)
        }
        
        summaryView.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        buyButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.trailing.equalToSuperview().offset(-50)
            make.leading.equalToSuperview().offset(50)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        summaryStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(0)
        }
        
        listTableView.snp.makeConstraints { make in
            make.top.equalTo(backButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(summaryView.snp.top).offset(-10)
        }
    }
    
    func makeEmptyLabelConstrains() {
        emptyLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    func updateSummaryData(data: (Int?, Int?)) {
        guard
            let price = data.0,
            let amount = data.1
        else { return }
        
        totalPriceLabel.text = "Total Price: " + AppConstants.Currency.currency.getPriceString(price: String(describing: price))
        totalProductLabel.text = "Number of Products : " + String(describing: amount)
    }
    
    @objc
    func backButtonTapped() {
        self.navigator.pop(sender: self)
    }
    
    @objc
    func buyButtonTapped() {
        if !self.basketItems.isEmpty {
            navigator.show(segue: .result(viewModel: ResultViewModel()), sender: self, transition: .navigation)
        }
    }

}

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell: BasketCell = tableView.dequeueReusableCell(
                withIdentifier: BasketCell.CellIdentifier.identifier.rawValue,
                for: indexPath) as? BasketCell
        else { return UITableViewCell() }
        
        let itemsArray = basketItems.map { $0 }.sorted()
        let id = itemsArray[indexPath.row]
        let item = products.filter {
            return $0.id == id
        }.first
        
        if let item = item {
            cell.setupCell()
            cell.setupConstraints()
            cell.setupItems(item: item)
            cell.fetchImages(item: item)
            cell.setupButtonActions()
            cell.updateMinusPlusButton(item: item)
            
            cell.didTappedPlusButton = { [weak self] in
                self?.viewModel.updateBasket(product: item, type: .plus)
                self?.viewModel.saveSummaryViewData()
            }
            
            cell.didTappedMinusButton = { [weak self] in
                self?.viewModel.updateBasket(product: item, type: .minus)
                self?.viewModel.saveSummaryViewData()
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension BasketViewController: IBasketController {
    
    func setSummaryData(data: (Int?, Int?)) {
        updateSummaryData(data: data)
    }
    
    func setProductsData(products: [Product]) {
        self.products = products
        listTableView.reloadData()
    }
    
    func setBasketData(basket: [Int]) {
        self.basketItems = Set(basket)
        listTableView.reloadData()
        
        if basket.isEmpty {
            view.addSubview(emptyLabel)
            makeEmptyLabelConstrains()
        } else {
            emptyLabel.removeFromSuperview()
        }
    }
    
}
