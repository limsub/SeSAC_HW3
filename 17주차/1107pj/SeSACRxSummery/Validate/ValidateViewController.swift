//
//  ValidateViewController.swift
//  SeSACRxSummery
//
//  Created by 임승섭 on 2023/11/07.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ValidateViewController: UIViewController {
    
    let nameTextField = UITextField()
    let validationLabel = UILabel()
    let nextButton = UIButton()
    
    let disposeBag = DisposeBag()
    
    let viewModel = ValidateViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setting()
        
        bind()
    }
    
    func bind() {
        
        let input = ValidateViewModel.Input(
            text: nameTextField.rx.text,
            tap: nextButton.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.text
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.validataion
            .bind(to: nextButton.rx.isEnabled, validationLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.tap
            .bind(with: self) { owner , _ in
                print("tap")
            }
            .disposed(by: disposeBag)
        
        
    }
    
    func setting() {
        view.addSubview(nameTextField)
        view.addSubview(validationLabel)
        view.addSubview(nextButton)
        
        nameTextField.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(50)
        }
        validationLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(50)
        }
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(validationLabel.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(50)
        }
        
        [nameTextField, validationLabel, nextButton].forEach { item in
            item.backgroundColor = .lightGray
        }
    }
}
