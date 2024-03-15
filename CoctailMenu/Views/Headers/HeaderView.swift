//
//  HeaderView.swift
//  CoctailMenu
//
//  Created by Polina on 12.03.2024.
//

import UIKit

class HeaderView: UICollectionReusableView {
    static let resuseID = "HeaderView"
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHeader(sectionTitle: String){
        headerLabel.text = sectionTitle
    }
    
    private func setConstrains(){
        addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            //headerLabel.heightAnchor.constraint(equalToConstant: 70),
        ])
    }
}
