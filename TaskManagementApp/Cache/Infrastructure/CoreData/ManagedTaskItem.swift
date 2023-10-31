//
//  ManagedTaskItem.swift
//  TaskManagementApp
//
//  Created by hamedpouramiri on 10/31/23.
//

import CoreData

@objc(ManagedTaskItem)
class ManagedTaskItem: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var title: String?
    @NSManaged var taskDescription: String?
    @NSManaged var isCompleted: Bool
}

extension ManagedTaskItem {

    static func allTasks(in context: NSManagedObjectContext) throws -> [ManagedTaskItem]? {
        let request = NSFetchRequest<ManagedTaskItem>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        return try context.fetch(request)
    }

    static func findTask(byID id: UUID, in context: NSManagedObjectContext) throws -> ManagedTaskItem? {
        let request = NSFetchRequest<ManagedTaskItem>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedTaskItem.id), id])
        request.returnsObjectsAsFaults = false
        return try context.fetch(request).first
    }
    
    static func deleteTask(byID id: UUID, in context: NSManagedObjectContext) throws {
        try findTask(byID: id, in: context).map(context.delete).map(context.save)
    }

    static func newTask(from localTaskItem: LocalTaskItem, in context: NSManagedObjectContext) -> ManagedTaskItem {
        let managed = ManagedTaskItem(context: context)
        managed.id = localTaskItem.id
        managed.title = localTaskItem.title
        managed.taskDescription = localTaskItem.description
        managed.isCompleted = localTaskItem.isCompleted
        return managed
    }

    var local: LocalTaskItem {
        return LocalTaskItem(id: id, title: title, description: taskDescription, isCompleted: isCompleted)
    }
}

