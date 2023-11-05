//
//  ShoppingListTableViewCell.swift
//  1105hw
//
//  Created by 임승섭 on 2023/11/05.
//

import UIKit
import RxSwift
import RxCocoa


//checkmark.square  checkmark.square.fill  star star.fill

class ShoppingListTableViewCell: BaseTableViewCell {
    
    static func makeButton(_ imageName: String) -> UIButton {
        let view = UIButton()
        view.setImage(UIImage(systemName: imageName), for: .normal)
        return view
    }
    
    let checkButton = makeButton("checkmark.square")
    let starButton = makeButton("star")
    let nameLabel = UILabel()
    
    var disposeBag = DisposeBag()
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        contentView.addSubview(checkButton)
        contentView.addSubview(starButton)
        contentView.addSubview(nameLabel)
    }
    override func setConstraints() {
        super.setConstraints()
        
        checkButton.snp.makeConstraints { make in
            make.leading.verticalEdges.equalTo(contentView).inset(4)
            make.width.equalTo(50)
        }
        starButton.snp.makeConstraints { make in
            make.trailing.verticalEdges.equalTo(contentView).inset(4)
            make.width.equalTo(50)
        }
        nameLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView).inset(4)
            make.leading.equalTo(checkButton.snp.trailing).offset(4)
            make.trailing.equalTo(starButton.snp.leading).offset(-4)
        }
        
    }
    override func setting() {
        super.setting()
        contentView.backgroundColor = .lightGray.withAlphaComponent(0.3)
    }
    
    
    func designCell(_ sender: ShoppingContent) {
        
        nameLabel.text = sender.name
        
        checkButton.setImage(
            UIImage(systemName: sender.isChecked ? "checkmark.square.fill" : "checkmark.square"),
            for: .normal)
        
        starButton.setImage(
            UIImage(systemName: sender.isLiked ? "star.fill" : "star" ),
            for: .normal)
        
    }
}
