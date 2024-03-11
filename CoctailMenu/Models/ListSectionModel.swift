//
//  ListSection.swift
//  CoctailMenu
//
//  Created by Polina on 11.03.2024.
//

import Foundation
enum ListSectionModel{
    case ingridients([Ingridiens])
    case coctailData([CoctailModel])
    
    var ingredients: [Ingridiens] {
          switch self {
          case .ingridients(let ingredients):
              return ingredients
          case .coctailData:
              return []
          }
      }

      var cocktailData: [CoctailModel] {
          switch self {
          case .ingridients:
              return []
          case .coctailData(let cocktailData):
              return cocktailData
          }
      }
    
    var countIngridient: Int{
        ingredients.count
    }
    
    var countCoctailData: Int{
        cocktailData.count
    }
    
    var title: String{
        switch self{
        case .ingridients(_):
            "Ingridients"
        case .coctailData(_):
            "Coctails"
        }
    }
}
