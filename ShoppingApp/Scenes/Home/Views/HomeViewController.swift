//
//  HomeController.swift
//  ShoppingApp
//
//  Created by Mehmet Çevık on 28.09.2023.
//

import UIKit

protocol HomeControllerOutput {
    var products: [Product] { get set }
    var categories: [Category] { get set }
    var basketItems: [Int] { get set }
    var basketViewModel: BasketViewModel? { get set }
    
    func loadingStatus(status: Bool)
    func saveProductData(result: [Product])
    func saveCategoriesData(result: [Category])
    func updateBasketData(basketData: [Int])
}

final class HomeViewController: UIViewController, Navigatable {

    private let topLabel: UILabel = {
        let label = UILabel()
        label.text = "Store"
        label.font = .systemFont(ofSize: 24)
        label.textColor = .black
        return label
    }()
    
    private let basketButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 5
        button.setImage(UIImage(systemName: "basket")?.withRenderingMode(.alwaysOriginal).withTintColor(.white), for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    private let basketView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var basketLabel: UILabel = { 
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textColor = .white
        label.text = String(describing: basketItems.count)
        return label
    }()
    
    private let listTableView = UITableView(frame: .zero, style: .plain)
    private lazy var indicatorView = UIActivityIndicatorView(style: .large)
    
    var products: [Product] = []
    var categories: [Category] = []
    var basketItems: [Int] = []

    var viewModel: HomeViewModel
    var navigator: Navigator
    var basketViewModel: BasketViewModel?
    
    init(viewModel: HomeViewModel, navigator: Navigator) {
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
        viewModel.categoriesLoadingStatus()
        viewModel.fetchProducts()
        viewModel.fetchCategories()
        
    }
    
    @objc func didTapped() {
        print(self.products)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.viewWillAppear()
    }
    
    func setupViews() {
        view.backgroundColor = .white
        self.navigationController?.isNavigationBarHidden = true
        
        configureViews()
        
        listTableView.register(ProductCell.self, forCellReuseIdentifier: ProductCell.CellIdentifier.identifier.rawValue)
        listTableView.backgroundColor = .clear
        
    }
    
    func setupActions() {
        basketButton.addTarget(self, action: #selector(goTo), for: .touchUpInside)
    }
    
    @objc func goTo() {
        viewModel.createBasketViewModel()
        
        guard let basketViewModel = basketViewModel else { return }
        self.navigator.show(segue: .basket(viewModel: basketViewModel), sender: self, transition: .navigation)
    }
    
    func configureViews() {
        view.addSubview(indicatorView)
        view.addSubview(basketButton)
        view.addSubview(basketView)
        basketView.addSubview(basketLabel)
        view.addSubview(topLabel)
        view.addSubview(listTableView)
    }
    
    func configureConstraints() {
        indicatorView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        basketButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-10)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.height.width.equalTo(40)
        }
        
        basketView.snp.makeConstraints { make in
            make.leading.equalTo(basketButton).offset(-5)
            make.top.equalTo(basketButton).offset(-5)
            make.height.width.equalTo(20)
        }
        
        basketLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        topLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(basketButton)
        }
        
        listTableView.snp.makeConstraints { make in
            make.top.equalTo(basketButton.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.filter { $0.category.id == categories[section].id }.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section].name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell: ProductCell = tableView.dequeueReusableCell(
                withIdentifier: ProductCell.CellIdentifier.identifier.rawValue,
                for: indexPath) as? ProductCell
        else { return UITableViewCell() }
        
        let products = products.filter { $0.category.id == categories[indexPath.section].id }
        let product = products[indexPath.row]
        
        cell.setupCell()
        cell.setupConstraints()
        cell.setupItems(item: product)
        cell.setupButtonActions()
        cell.fetchImages(item: product)
        cell.didTappedBasketButton = {
            self.viewModel.updateBasket(product: product)
        }
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

extension HomeViewController: HomeControllerOutput {
    
    func updateBasketData(basketData: [Int]) {
        self.basketItems = basketData
        basketLabel.text = String(describing: basketItems.count)
    }
    
    func saveCategoriesData(result: [Category]) {
        categories = result
        listTableView.reloadData()
    }
    
    func loadingStatus(status: Bool) {
        status ? indicatorView.startAnimating() : indicatorView.stopAnimating()
    }
    
    func saveProductData(result: [Product]) {
        products = result
        listTableView.reloadData()
    }
    
}
