//
//  CoctailName.swift
//  CoctailMenu
//
//  Created by Polina on 11.03.2024.
//

import Foundation
// MARK: - CoctailNames
struct CoctailModel: Decodable, Hashable {
    let ingredients: [String]
    let instructions, name: String
}

typealias CoctailData = [CoctailModel]
