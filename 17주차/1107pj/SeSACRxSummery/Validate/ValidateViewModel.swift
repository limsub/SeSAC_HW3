//
//  ValidateViewModel.swift
//  SeSACRxSummery
//
//  Created by 임승섭 on 2023/11/07.
//

import Foundation
import RxSwift
import RxCocoa

class ValidateViewModel {
    
    let disposeBag = DisposeBag()
    
    /* 로직 */
    // 1. 텍스트필드의 글자 카운트가 8 이상이면 버튼 활성화, 레이블 숨김
    // 2. 버튼 클릭 시 단순 print
    
    // ControlProperty, ControlEvent : RxCocoa에서 제공하는 Trait
    
    struct Input {
        let text: ControlProperty<String?>  // 버튼 클릭
        let tap: ControlEvent<Void>         // 텍스트필드의 텍스트
    }
    
    struct Output {
        let tap: ControlEvent<Void>         // 버튼 클릭 그대로 전달
        let text: Driver<String>            // 레이블에 보여줄 텍스트
        let validataion: Observable<Bool>   // 8글자 넘었는지 여부
    }
    
    func transform(input: Input) -> Output {
        let validation = input.text
            .orEmpty
            .map { $0.count >= 8 }
        
        let validText = Observable.of("닉네임은 8자 이상").asDriver(onErrorJustReturn: "")
        
        return Output(
            tap: input.tap,
            text: validText,
            validataion: validation
        )
    }
    
    
    
    
}
