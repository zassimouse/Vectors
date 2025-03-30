//
//  CoreDataManager.swift
//  Vectors
//
//  Created by Denis Haritonenko on 30.03.25.
//

import CoreData
import UIKit

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "VectorsModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save Core Data: \(error)")
            }
        }
    }
    
    
    
    
    func saveVector(_ vector: Vector) {
        let context = CoreDataManager.shared.context
        _ = vector.toEntity(in: context)
        CoreDataManager.shared.saveContext()
    }

    func fetchVectors() -> [Vector] {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<VectorEntity> = VectorEntity.fetchRequest()

        do {
            let entities = try context.fetch(request)
            return entities.map { Vector(entity: $0) }
        } catch {
            print("Failed to fetch vectors: \(error)")
            return []
        }
    }
    
    func deleteVector(_ vector: Vector) {
        let context = CoreDataManager.shared.context
        let request: NSFetchRequest<VectorEntity> = VectorEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", vector.id)

        do {
            if let entity = try context.fetch(request).first {
                context.delete(entity)
                CoreDataManager.shared.saveContext()
            }
        } catch {
            print("Failed to delete vector: \(error)")
        }
    }


}

extension Vector {
    convenience init(entity: VectorEntity) {
        let start = CGPoint(x: entity.startX, y: entity.startY)
        let end = CGPoint(x: entity.endX, y: entity.endY)
        let color = UIColor(data: entity.color ?? Data()) ?? .black
        self.init(start: start, end: end, color: color)
        self.id = Int(entity.id)
    }

    func toEntity(in context: NSManagedObjectContext) -> VectorEntity {
        let entity = VectorEntity(context: context)
        entity.id = Int64(id)
        entity.startX = Double(start.x)
        entity.startY = Double(start.y)
        entity.endX = Double(end.x)
        entity.endY = Double(end.y)
        entity.color = color.toData()
        return entity
    }
}



// MARK: - UIColor Encoding & Decoding


extension UIColor {
    func toData() -> Data? {
        try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: true)
    }

    convenience init?(data: Data) {
        guard let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else {
            return nil
        }
        self.init(cgColor: color.cgColor)
    }
}

