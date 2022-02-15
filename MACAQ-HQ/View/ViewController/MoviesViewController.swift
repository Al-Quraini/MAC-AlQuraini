//
//  MoviesViewController.swift
//  MACAQ-HQ
//
//  Created by Mohammed Al-Quraini on 2/11/22.
//

import UIKit
import Combine

class MoviesViewController: UIViewController {
    
    let name : String
    
    init(name: String) {
            self.name = name
            super.init(nibName: nil, bundle: nil)
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - properties
    
    var selectedSegment : Int = 0
    
    // combine
    private let viewModelCombine = ViewModelCombine.shared
    private var subscribers = Set<AnyCancellable>()
    
    // movies array
    private var movies : [Movie] = []
    private var favouriteIds : [Int] = []
    private var favouriteMovies: [Movie] {
        return movies.filter({favouriteIds.contains($0.id)})
    }
    
    // stack view
    private lazy var stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .leading
        
        return stackView
    }()
    
    // welcome label
    private lazy var welcomeLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = false
        label.font = label.font.withSize(25)
        label.text = "Hello, \(name)"
        
        return label
    }()
    
    // edit icon
    private lazy var editButton : UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        button.imageView?.tintColor = .systemBlue
        button.addTarget(self, action: #selector(editName), for: .touchUpInside)
        
        return button
    }()
    
    // segment control
    private lazy var segmentedControl : UISegmentedControl = {
        let segmentedControlItems = [
            "Movies List", "Favourites"]
        let segmentedControl = UISegmentedControl(items: segmentedControlItems)
        segmentedControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor: UIColor.darkText], for: .selected)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(onSegmentChanged(_:)), for: .valueChanged)
    
        return segmentedControl
    }()
    
    // search text field
    private lazy var searchTextField : UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.leftViewMode = .always
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 10
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.masksToBounds = true
        textField.textColor = .black
        textField.tintColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.image = UIImage(systemName: "magnifyingglass")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 40))
        imageContainerView.addSubview(imageView)
        textField.leftViewMode = .always
        textField.font = UIFont.systemFont(ofSize: 12)
        textField.leftView = imageContainerView
        
        return textField
        
    }()
    
    // table view
    private lazy var tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MoviewTableViewCell.self, forCellReuseIdentifier: MoviewTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 150
        
        return tableView
    }()

    //MARK: - main
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // add subviews
        addSubviews()
        
        // set up binding
        setUpBinding()
        
    }
    
    // layout subviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // safe area
        let safeArea = view.safeAreaLayoutGuide
        
        // stack view constraints
        stackView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15).isActive = true
        stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: -15).isActive = true
        
        // segment control constraints
        segmentedControl.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 10).isActive = true
        segmentedControl.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10).isActive = true
        segmentedControl.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10).isActive = true
        
        // search text field constraints
        searchTextField.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 15).isActive = true
        searchTextField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 5).isActive = true
        searchTextField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -5).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // table view constraints
        tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 20).isActive = true
        tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
    }
    
    //MARK: - Functions
    // add subviews
    private func addSubviews(){
        view.addSubview(stackView)
        stackView.addArrangedSubview(welcomeLabel)
        stackView.addArrangedSubview(editButton)
        view.addSubview(segmentedControl)
        view.addSubview(searchTextField)
        view.addSubview(tableView)
    }
    
    // binding
    private func setUpBinding() {
        
        // fetch data from url binding
        viewModelCombine
            .$movies
            .receive(on: RunLoop.main)
            .sink(receiveValue: {  myMovies in
                self.movies = myMovies
                self.tableView.reloadData()
            })
            .store(in: &subscribers)
        
        // fetch data
        viewModelCombine.getMovies()
        
        // fetch data from local storage
        viewModelCombine
            .$movieIds
            .receive(on: RunLoop.main)
            .sink(receiveValue: { favourites in
                self.favouriteIds = favourites
                self.tableView.reloadData()
                print(favourites.count)
            })
            .store(in: &subscribers)
        
        viewModelCombine.fetchCoreData()
    }
    
    // navigate to next page
    private func navigateToDetail(movie : Movie){
        let detailVC = MovieDetailViewController(movie: movie)
        detailVC.modalPresentationStyle = .fullScreen
        detailVC.modalTransitionStyle = .partialCurl
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    // edit name
    @objc private func editName(){
        let initialViewController = InitialViewController()
        initialViewController.modalPresentationStyle = .fullScreen
        initialViewController.modalTransitionStyle = .partialCurl
        self.subscribers.cancelAll()
        navigationController?.setViewControllers([initialViewController], animated: true)
    }
    
    // segment change triggered
    @objc private func onSegmentChanged(_ sender : UISegmentedControl){
              selectedSegment = sender.selectedSegmentIndex
            tableView.reloadData()
      }
    
    

}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension MoviesViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MoviewTableViewCell.identifier, for: indexPath) as! MoviewTableViewCell
        let model = selectedSegment == 0 ? movies[indexPath.row] : favouriteMovies[indexPath.row]
        cell.cofigureCell(with: model, isFavourite: favouriteIds.contains(model.id))
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = selectedSegment == 0 ? movies.count : favouriteMovies.count
        return count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = selectedSegment == 0 ? movies[indexPath.row] : favouriteMovies[indexPath.row]
        navigateToDetail(movie: model)
    }
    
    
}

//MARK: - UITextFieldDelegate
extension MoviesViewController : UITextFieldDelegate {
    
}
