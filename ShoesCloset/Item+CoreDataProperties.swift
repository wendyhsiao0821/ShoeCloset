//
//  Item+CoreDataProperties.swift
//  ShoesCloset
//
//  Created by Wendy Hsiao on 2025/2/23.
//
//

import Foundation
import CoreData
import UIKit


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var id: UUID
    @NSManaged public var brand: String?
    @NSManaged public var colorway: String?
    @NSManaged public var purchaseDate: Date?
    @NSManaged public var series: String?
    @NSManaged public var shoeTitle: String?
    @NSManaged public var shoeImage: Data?
    @NSManaged public var logs: NSSet?

}

// MARK: Generated accessors for logs
extension Item {

    @objc(addLogsObject:)
    @NSManaged public func addToLogs(_ value: Log)

    @objc(removeLogsObject:)
    @NSManaged public func removeFromLogs(_ value: Log)

    @objc(addLogs:)
    @NSManaged public func addToLogs(_ values: NSSet)

    @objc(removeLogs:)
    @NSManaged public func removeFromLogs(_ values: NSSet)

}

extension Item : Identifiable {

}
