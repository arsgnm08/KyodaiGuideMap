//
//  RestaurantBusiness+CoreDataProperties.swift
//  京大周辺マップiPhone
//
//  Created by 丸谷 浩永 on 8/27/16.
//  Copyright © 2016 丸谷 浩永. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension RestaurantBusiness {

    @NSManaged var friday: String?
    @NSManaged var monday: String?
    @NSManaged var number: String?
    @NSManaged var saturday: String?
    @NSManaged var sunday: String?
    @NSManaged var thursday: String?
    @NSManaged var tuesday: String?
    @NSManaged var wednesday: String?
    @NSManaged var restaurant: NSManagedObject?
    @NSManaged var closed : String?

}
