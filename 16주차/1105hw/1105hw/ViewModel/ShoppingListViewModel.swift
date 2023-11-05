//
//  ShoppingListViewModel.swift
//  1105hw
//
//  Created by 임승섭 on 2023/11/05.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingListViewModel {
    
    var data: [ShoppingContent] = [
        ShoppingContent(isChecked: false, name: "aaskldjf;asldkfj;asldkfj;adslkj", isLiked: true),
        ShoppingContent(isChecked: true, name: "iafjoijeawoifjp", isLiked: false),
        ShoppingContent(isChecked: true, name: "aopidfjpaoifej", isLiked: false),
        ShoppingContent(isChecked: false, name: "apoiewjfpaoiwejf", isLiked: false),
        ShoppingContent(isChecked: true, name: "a;lskjdfa;oeiwfj", isLiked: false),
        ShoppingContent(isChecked: false, name: "apoiejfpoiaje", isLiked: true),
    ]
    
    lazy var rxData = BehaviorSubject(value: data)
    
    func toggleIsChecked(_ index: Int) {
        data[index].isChecked.toggle()
    }
    func toggleIsLiked(_ index: Int) {
        data[index].isLiked.toggle()
    }
    
    func updateRxData() {
        rxData.onNext(data)
    }
}
