//
//  RestaurantPhoto+CoreDataProperties.swift
//  KyodaiGuideMapApp
//
//  Created by 丸谷 浩永 on 2016/10/08.
//  Copyright © 2016 丸谷 浩永. All rights reserved.
//

import Foundation
import CoreData

extension RestaurantPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RestaurantPhoto> {
        return NSFetchRequest<RestaurantPhoto>(entityName: "RestaurantPhoto");
    }

    @NSManaged public var photo: Data?
    @NSManaged public var relationship: NSManagedObject?

}
