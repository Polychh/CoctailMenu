//
//  CompositionLayout.swift
//  CoctailMenu
//
//  Created by Polina on 11.03.2024.
//

import UIKit

enum CompositionGroupAlignment{
    case vertical
    case horizontal
}

struct CompositionLayout{
    static func createItem(width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, spacing: CGFloat) -> NSCollectionLayoutItem{
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height))
        item.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        return item
    }
    static func createGroup(alignment: CompositionGroupAlignment, width: NSCollectionLayoutDimension, height: NSCollectionLayoutDimension, subitems: [NSCollectionLayoutItem]) -> NSCollectionLayoutGroup{
        switch alignment{
        case .vertical:
            return NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height), subitems: subitems)
        case .horizontal:
            return NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: width, heightDimension: height), subitems: subitems)
        }
        
        
    }
}
