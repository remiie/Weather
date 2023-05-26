//
//  CityView.swift
//  WeatherApp
//
//  Created by Роман Васильев on 23.05.2023.
//

import UIKit

protocol CityViewInput: AnyObject {
    var presenter: CityViewOutput? { get set }
    func showWeather()
    func updateTitle(_ title: String)
    func updateButton(_ with: ActionState)
    func showErrorMessage(_ message: String)
}

final class CityView: UIViewController {
    
    var presenter: CityViewOutput?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var actionButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        presenter?.viewDidLoad()
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        navigationController?.navigationBar.prefersLargeTitles = true
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.dataSource = self
        tableView.rowHeight = 80.0
        tableView.separatorStyle = .none
        tableView.register(CityCell.self, forCellReuseIdentifier: CityCell.identifier)
    }
    
    @objc func actionButtonTapped() {
        presenter?.actionButtonTapped()
    }
    
    func updateButton(_ with: ActionState) {
        switch with {
        case .add:
            actionButton = UIBarButtonItem(barButtonSystemItem: .add, target: self,
                                           action: #selector(actionButtonTapped))
        case .remove:
            actionButton = UIBarButtonItem(barButtonSystemItem: .stop, target: self,
                                           action: #selector(actionButtonTapped))
        }
        navigationItem.rightBarButtonItem = actionButton
    }

}

extension CityView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return presenter?.getNumberOfSections() ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter?.getNumberOfRowsInSection(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.identifier, for: indexPath) as? CityCell,
        let presenter = presenter else { return UITableViewCell() }
        let title = presenter.getTitleForCell(at: indexPath)
        let temperature = presenter.getTemperatureForCell(at: indexPath)
        cell.configure(with: title, temperature: temperature)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return presenter?.getTitleForSection(section)
    }
    
    
}

extension CityView: CityViewInput {
    func showErrorMessage(_ message: String) {
        let label = UILabel()
        label.text = message
        label.textColor = .gray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    
    func showWeather() {
        tableView.reloadData()
    }
    
    func updateTitle(_ title: String) {
        self.title = title
    }
}


