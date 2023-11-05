//
//  ShoppingListViewController.swift
//  1105hw
//
//  Created by 임승섭 on 2023/11/05.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class ShoppingListViewController: BaseViewController {
    
    // view
    let addView = AddView()
    
    let tableView = {
        let view = UITableView()
        view.register(ShoppingListTableViewCell.self, forCellReuseIdentifier: ShoppingListTableViewCell.description())
        view.rowHeight = 200
        return view
    }()
    
    // viewModel
    let viewModel = ShoppingListViewModel()
    
    // disposeBag
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        bind()
    }
    
    override func setConfigure() {
        super.setConfigure()
        
        view.addSubview(addView)
        view.addSubview(tableView)
    }
    
    override func setConstraints() {
        super.setConstraints()
        
        addView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.horizontalEdges.equalTo(view).inset(8)
            make.height.equalTo(50)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(addView.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view).inset(8)
            make.bottom.equalTo(view)
        }
        
    }
    
    func bind() {
        viewModel.rxData
            .bind(to: tableView.rx.items(cellIdentifier: ShoppingListTableViewCell.description(), cellType: ShoppingListTableViewCell.self)) { (row, element, cell) in
                
                // 디자인 셀
                cell.designCell(element)
                
                // 버튼 클릭 이벤트
                cell.checkButton.rx.tap
                    .subscribe(with: self) { owner , _ in
                        owner.viewModel.toggleIsChecked(row)
                        owner.viewModel.updateRxData()
                        print("체크버튼 토글")
                    }
                    .disposed(by: cell.disposeBag)
                cell.starButton.rx.tap
                    .subscribe(with: self) { owner , _ in
                        owner.viewModel.toggleIsLiked(row)
                        owner.viewModel.updateRxData()
                        print("라잌버튼 토글")
                    }
                    .disposed(by: cell.disposeBag)
                    
                
            }
            .disposed(by: disposeBag)
    }
}
