//
//  ShoppingCart+CoreDataProperties.swift
//  
//
//  Created by shachar on 2024/8/1.
//
//

import Foundation
import CoreData


extension ShoppingCart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingCart> {
        return NSFetchRequest<ShoppingCart>(entityName: "ShoppingCart")
    }

    @NSManaged public var productName: String?
    @NSManaged public var productColor: String?
    @NSManaged public var productSize: String?
    @NSManaged public var productCount: Int16
    @NSManaged public var productImage: String?
    @NSManaged public var productPrice: Int64

}
