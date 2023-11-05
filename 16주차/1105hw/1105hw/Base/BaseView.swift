//
//  BaseView.swift
//  1105hw
//
//  Created by 임승섭 on 2023/11/05.
//

import UIKit
import SnapKit


class BaseView: UIView {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        
        setConfigure()
        setConstraints()
        setting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setConfigure() { }
    func setConstraints() { }
    func setting() { }
    
}
