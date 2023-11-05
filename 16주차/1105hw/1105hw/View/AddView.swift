//
//  AddView.swift
//  1105hw
//
//  Created by 임승섭 on 2023/11/05.
//

import UIKit
import SnapKit

class AddView: BaseView {
    
    
    let addTextField = {
        let view = UITextField()
        view.placeholder = "추가할 내용을 입력하세요"
        return view
    }()
    
    let addButton = {
        let view = UIButton()
        view.setTitle("추가", for: .normal)
        view.backgroundColor = .darkGray
        return view
    }()
    
    override func setConfigure() {
        super.setConfigure()
        
        self.addSubview(addTextField)
        self.addSubview(addButton)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        addTextField.snp.makeConstraints { make in
            make.leading.equalTo(self).inset(8)
            make.width.equalTo(self).multipliedBy(0.6)
            make.centerY.equalTo(self)
        }
        
        addButton.snp.makeConstraints { make in
            make.trailing.equalTo(self).inset(8)
            make.width.equalTo(40)
            make.centerY.equalTo(self)
        }
    }
    
    override func setting() {
        super.setting()
        
        self.backgroundColor = .lightGray
    }
    
}
