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
    
    static func createSection(group: NSCollectionLayoutGroup, scrollBehavior:  UICollectionLayoutSectionOrthogonalScrollingBehavior, groupSpacing: CGFloat, leading: CGFloat, trailing: CGFloat, supplementary: [NSCollectionLayoutBoundarySupplementaryItem]) -> NSCollectionLayoutSection{
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = scrollBehavior
        section.interGroupSpacing = groupSpacing
        section.contentInsets = .init(top: 0, leading: leading, bottom: 0, trailing: trailing)
        section.supplementariesFollowContentInsets = false
        section.boundarySupplementaryItems = supplementary
        return section
    }
}


//    private func createCoctailDataSectionLayout() -> NSCollectionLayoutSection{
//        let item = CompositionLayout.createItem(width: .fractionalWidth(1), height: .fractionalHeight(1), spacing: 0)
//        let group = CompositionLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(0.9), height: .fractionalHeight(0.3), subitems: [item])
//        let section = NSCollectionLayoutSection(group: group)
//        section.orthogonalScrollingBehavior = .groupPaging
//        section.interGroupSpacing = 10
//        section.contentInsets = .init(top: 4, leading: 10, bottom: 0, trailing: 10)//top 4 for shadow in cell
//        section.supplementariesFollowContentInsets = false //заголовок игнорировал contentInsets секции
//        section.boundarySupplementaryItems = [createHeader()]
//        return section
//    }
