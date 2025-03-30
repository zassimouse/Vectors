//
//  MenuViewController.swift
//  Vectors
//
//  Created by Denis Haritonenko on 30.03.25.
//

import UIKit

class MenuController: UIViewController {
    
    var tableView: UITableView!
    
    var vectors: [Vector] = [Vector(start: CGPoint(x: 0, y: 0), end: CGPoint(x: 20, y: 100))]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    

    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemBackground
        
        tableView.register(VectorTableViewCell.self, forCellReuseIdentifier: VectorTableViewCell.identifier)
        tableView.frame = view.bounds
        view.addSubview(tableView)
        
    }

}

extension MenuController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VectorTableViewCell.identifier, for: indexPath) as! VectorTableViewCell
        cell.configure(with: vectors[0], color: .random)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                // Уведомление или удаление элемента
            }
            return UIMenu(title: "", children: [deleteAction])
        }
    }

}
