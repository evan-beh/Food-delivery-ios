//
//  MenuModel.swift
//  FoodDeliveryApp
//
//  Created by Evan Beh on 09/09/2021.
//

import UIKit
//import ObjectMapper
import Moya

struct MenuModel: Codable {
    let menuName: String?
    let MenuDesc: String?
    let menuContent: String?
    let menuPrice: String?
    let menuImageUrl: String?
    let menuThumnailImageUrl:String?
}


//
//struct MenuModel: Mappable {
//
//
//    var menuName: String?
//    var MenuDesc: String?
//    var menuContent: String?
//    var menuPrice: String?
//    var menuImageUrl: String?
//
//    init?(map: Map) { }
//
//
//       mutating func mapping(map: Map) {
//
//       }
//
//}
//
