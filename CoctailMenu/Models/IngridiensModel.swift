//
//  IngridiensModel.swift
//  CoctailMenu
//
//  Created by Polina on 11.03.2024.
//

import Foundation
struct IngridiensModel{
    let ingridient: [Ingridiens]
}
struct Ingridiens{
    let title: String
}
extension IngridiensModel{
    static func getIngridients() -> [Ingridiens]{
        IngridiensModel(ingridient: [Ingridiens(title: "Vodka"), Ingridiens(title: "Lemon juice"),Ingridiens(title: "Hot sauce"),Ingridiens(title: "Whiskey"),Ingridiens(title: "Rum"),Ingridiens(title: "Honey"),Ingridiens(title: "Gin"),Ingridiens(title: "Tequila"),Ingridiens(title: "Black pepper"),Ingridiens(title: "Salt")]).ingridient
    }
}
