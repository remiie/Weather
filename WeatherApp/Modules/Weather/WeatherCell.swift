//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Роман Васильев on 24.05.2023.
//

import UIKit

final class WeatherCell: UITableViewCell {
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    private let temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .darkGray
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.systemGray4.cgColor
        view.layer.cornerRadius = 20
        return view
    }()
    
    static let identifier: String = "WeatherCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        backgroundColor = .systemGray6
        addSubview(containerView)
        containerView.addSubview(cityLabel)
        containerView.addSubview(temperatureLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
        
        NSLayoutConstraint.activate([
            cityLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            cityLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 26),
            cityLabel.trailingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            temperatureLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            temperatureLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -26),
        ])
    }
    
    func configure(with city: String, and temperature: Int ) {
        cityLabel.text = city
        temperatureLabel.text = "\(temperature) °C"
        selectionStyle = .none
    }
}
