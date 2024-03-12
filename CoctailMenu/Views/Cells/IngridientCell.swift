//
//  IngridientCell.swift
//  CoctailMenu
//
//  Created by Polina on 11.03.2024.
//

import UIKit
final class IngridientCell: UICollectionViewCell {
    static let resuseID = "IngridientCell"
    
    private let ingridientLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var ingridientBackImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 16
        image.backgroundColor = UIColor.clear
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstrains()
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        ingridientLabel.text = nil
    }
    
    private func applyGradient(){
        ingridientBackImage.bounds = self.contentView.bounds
        ingridientBackImage.applyGradientMask(colors: [#colorLiteral(red: 1, green: 0.3176470588, blue: 0.1843137255, alpha: 1), #colorLiteral(red: 0.8666666667, green: 0.1411764706, blue: 0.462745098, alpha: 1)], locations: [0.2, 1.0])
    }
}
//MARK: - Configure Cell UI Public Method
extension IngridientCell{
    func configCell(ingridientLabelText: String){
        ingridientLabel.text = ingridientLabelText
        applyGradient()
    }
}

//MARK: - Constrains
extension IngridientCell{
    private func setConstrains(){
        contentView.layer.cornerRadius = 16
        contentView.addSubview(ingridientBackImage)
        contentView.addSubview(ingridientLabel)
        
        NSLayoutConstraint.activate([
            ingridientBackImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ingridientBackImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ingridientBackImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            ingridientBackImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            ingridientLabel.centerXAnchor.constraint(equalTo: ingridientBackImage.centerXAnchor),
            ingridientLabel.centerYAnchor.constraint(equalTo: ingridientBackImage.centerYAnchor),
//            ingridientLabel.trailingAnchor.constraint(equalTo: ingridientBackImage.trailingAnchor , constant: -5),
//            ingridientLabel.bottomAnchor.constraint(equalTo: ingridientBackImage.bottomAnchor, constant: -5)
        ])
    }
}
