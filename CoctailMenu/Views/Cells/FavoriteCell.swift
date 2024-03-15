//
//  FavoriteCell.swift
//  CoctailMenu
//
//  Created by Polina on 14.03.2024.
//


import UIKit

final class FavoriteCell: UITableViewCell {
    static let resuseID = "FavoriteCell"
    
    private let coctailNameLabel = UILabel()
    private let ingridientsLabel = UILabel()
    private let instructionLabel = UILabel()
    private let stack = UIStackView()
    private let color = #colorLiteral(red: 0.7176470588, green: 0.5176470588, blue: 0.7176470588, alpha: 1)
    
    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.8
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowColor =  #colorLiteral(red: 0.7176470588, green: 0.5176470588, blue: 0.7176470588, alpha: 1).cgColor
        view.layer.cornerRadius = 15
        view.clipsToBounds = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUIElements()
        setConstrains()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUIElements(){
        configLabel(label: coctailNameLabel, sizeText: 20, weithText: .bold, lines: 0, alignment: .center, color: color)
        configLabel(label: ingridientsLabel, sizeText: 16, weithText: .semibold, lines: 0, alignment: .left, color: .black)
        configLabel(label: instructionLabel, sizeText: 16, weithText: .regular, lines: 0, alignment: .left, color: .black)
        configStack(stack: stack)
    }
    
    private func configLabel(label: UILabel, sizeText: CGFloat, weithText: UIFont.Weight, lines: Int, alignment: NSTextAlignment, color: UIColor){
        label.textAlignment = alignment
        label.textColor = color
        label.numberOfLines = lines
        label.font = .systemFont(ofSize: sizeText, weight: weithText)
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configStack(stack: UIStackView){
        stack.alignment = .center
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.spacing = 5
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coctailNameLabel.text = nil
        ingridientsLabel.text = nil
        instructionLabel.text = nil
    }
}

//MARK: - Configure Cell UI
extension FavoriteCell{
    func configCell(coctailName: String, ingridients: String, instruction: String){
        configCoctailNameLabel(coctailName: coctailName)
        configIngridientsLabel(ingridients: ingridients)
        configInstructionLabel(instruction: instruction)
    }
    
    private func configCoctailNameLabel(coctailName: String){
        coctailNameLabel.text = coctailName
    }
    
    private func configIngridientsLabel(ingridients: String){
        ingridientsLabel.text = ingridients
    }
    
    private func configInstructionLabel(instruction: String){
        instructionLabel.text = instruction
    }
}

//MARK: - Constrains
extension FavoriteCell{
    private func setConstrains(){
        contentView.addSubview(backView)
        stack.addArrangedSubview(ingridientsLabel)
        stack.addArrangedSubview(instructionLabel)
        backView.addSubview(stack)
        backView.addSubview(coctailNameLabel)
        
        NSLayoutConstraint.activate([
            backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            
            coctailNameLabel.topAnchor.constraint(equalTo: backView.topAnchor, constant: 2),
            coctailNameLabel.centerXAnchor.constraint(equalTo: backView.centerXAnchor),
            
            stack.topAnchor.constraint(equalTo: coctailNameLabel.bottomAnchor, constant: 2),
            stack.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 4),
            stack.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -4),
            stack.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -2),
        ])
    }
}
