//
//  BoxOfficeViewModel.swift
//  SeSACRxSummery
//
//  Created by 임승섭 on 2023/11/07.
//

import Foundation
import RxSwift
import RxCocoa

class BoxOfficeViewModel {
    
    let disposeBag = DisposeBag()
    
    let items = PublishSubject<[DailyBoxOfficeList]>()
    let recent = BehaviorRelay(value: Array<String>())
    
    
    
}

