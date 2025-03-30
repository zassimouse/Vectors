//
//  VectorTableViewCell.swift
//  Vectors
//
//  Created by Denis Haritonenko on 30.03.25.
//

import UIKit

class VectorTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: VectorTableViewCell.self)
    
    private let colorDot: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    private let startCoordinateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    private let endCoordinateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        return label
    }()
    
    private let lengthLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 11, weight: .medium)
        label.textColor = .gray
        return label
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .systemBackground
        
        colorDot.translatesAutoresizingMaskIntoConstraints = false
        startCoordinateLabel.translatesAutoresizingMaskIntoConstraints = false
        endCoordinateLabel.translatesAutoresizingMaskIntoConstraints = false
        lengthLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(startCoordinateLabel)
        stackView.addArrangedSubview(endCoordinateLabel)
        stackView.addArrangedSubview(lengthLabel)
        
        contentView.addSubview(colorDot)
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            colorDot.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            colorDot.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            colorDot.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            colorDot.heightAnchor.constraint(equalToConstant: 4),
        ])
    }
    
    func configure(with vector: Vector, color: UIColor) {
        colorDot.backgroundColor = color
        startCoordinateLabel.text = "(\(vector.start.x); \(vector.start.y))"
        endCoordinateLabel.text = "(\(vector.end.x); \(vector.end.y))"
        lengthLabel.text = "\(vector.length)"
    }
    
}
