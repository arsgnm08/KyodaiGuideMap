//
//  RestaurantBasic+CoreDataProperties.swift
//  KyodaiGuideMapApp
//
//  Created by 丸谷 浩永 on 9/18/16.
//  Copyright © 2016 丸谷 浩永. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension RestaurantBasic {

    @NSManaged var area: String?
    @NSManaged var genre: String?
    @NSManaged var introduction: String?
    @NSManaged var latitude: String?
    @NSManaged var longitude: String?
    @NSManaged var name: String?
    @NSManaged var number: String?
    @NSManaged var price: String?
    @NSManaged var hour: String?
    @NSManaged var closedDay: String?
    @NSManaged var reserve: String?
    @NSManaged var tel: String?
    @NSManaged var park: String?
    @NSManaged var seats: String?
    @NSManaged var menuFirst: String?
    @NSManaged var menuSecond: String?
    @NSManaged var menuThird: String?
    @NSManaged var valueFirst: String?
    @NSManaged var valueSecond: String?
    @NSManaged var valueThird: String?
    @NSManaged var favorite: NSNumber?
    @NSManaged var additionalData: RestaurantAdditional?
    @NSManaged var businessHours: RestaurantBusiness?
    @NSManaged var photo: NSManagedObject?

}
