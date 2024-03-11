//
//  CoctailIngridient.swift
//  CoctailMenu
//
//  Created by Polina on 11.03.2024.
//

import Foundation
// MARK: - CoctailIngridients
struct CoctailIngridient: Codable {
    let ingredients: [String]
    let instructions, name: String
}

typealias CoctailIngridients = [CoctailIngridient]
