//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Роман Васильев on 23.05.2023.
//

import UIKit

protocol WeatherViewInput: AnyObject {
    var presenter: WeatherViewOutput? { get set }
    func showCities()
    func showErrorMessage(_ message: String)
    func endRefreshing()
   
}

class WeatherView: UIViewController, WeatherViewInput {
    var presenter: WeatherViewOutput?
    private let errorLabel = UILabel()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter?.viewDidLoad()
    }
    
    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.identifier)
        tableView.rowHeight = 60.0
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        view.backgroundColor = .systemGray6
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        view.addGestureRecognizer(tapGesture)

        let tableTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTableTap(_:)))
        tableTapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tableTapGesture)
        tableView.addSubview(errorLabel)
        errorLabel.isHidden = true
    }
    
    @objc private func handleRefresh(_ sender: Any) {
        presenter?.viewDidLoad()
    }

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        searchBar.resignFirstResponder()
    }
    
    @objc private func handleTableTap(_ gesture: UITapGestureRecognizer) {
          searchBar.resignFirstResponder()
      }

}

extension WeatherView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getCitiesCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.identifier) as? WeatherCell,
              let presenter = presenter else { return UITableViewCell() }
        let city = presenter.getCityName(at: indexPath)
        let temperature = presenter.getCityTemperature(at: indexPath)
        cell.configure(with: city, and: temperature)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectCity(indexPath)
    }
    
}

extension WeatherView: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let cityName = searchBar.text {
            presenter?.searchCities(cityName)
        }
        searchBar.resignFirstResponder()
    }
}

extension WeatherView {
    func showCities() {
        errorLabel.isHidden = true
        tableView.reloadData()
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    func showErrorMessage(_ message: String) {
        errorLabel.isHidden = false
        errorLabel.text = message
        errorLabel.textColor = .gray
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
}

