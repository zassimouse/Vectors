//
//  MenuViewController.swift
//  Vectors
//
//  Created by Denis Haritonenko on 30.03.25.
//

import UIKit

protocol MenuControllerDeledate: AnyObject {
    func deleteVector(_ vector: Vector)
}

class MenuController: UIViewController {
    
    weak var delegate: MenuControllerDeledate?
    
    var tableView: UITableView!
    
    var vectors: [Vector] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        vectors = CoreDataManager.shared.fetchVectors()
    }
    
    func addVector(_ vector: Vector) {
        vectors.append(vector)
        tableView.reloadData()
    }
    
    func editVector(_ vector: Vector) {
        if let index = vectors.firstIndex(where: { $0.id == vector.id }) {
            vectors[index] = vector
            tableView.reloadData()
        }
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
    
    func deleteVector(at index: Int) {
        CoreDataManager.shared.deleteVector(vectors[index])
        delegate?.deleteVector(vectors[index])
        vectors.remove(at: index)
        tableView.reloadData()
    }

}

extension MenuController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vectors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: VectorTableViewCell.identifier, for: indexPath) as! VectorTableViewCell
        cell.configure(with: vectors[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        65
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in
                self.deleteVector(at: indexPath.row)
            }
            return UIMenu(title: "", children: [deleteAction])
        }
    }

}
