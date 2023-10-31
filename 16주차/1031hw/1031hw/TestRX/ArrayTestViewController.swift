//
//  ArrayTestViewController.swift
//  1031hw
//
//  Created by 임승섭 on 2023/10/31.
//

import UIKit
import RxSwift
import RxCocoa

class ArrayTestViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sample1()
    }
    
    
    func sample1() {
        let item = [1, 2, 3, 4, 5, 100]
        let item2 = [11, 12, 14, 15]
        
        // 데이터를 전달하는 "Observable" - "이벤트 전달"
        
        // 1. just
        // 2. of : 여러 배열을 전달하고 싶다 -> 배열 개수만큼 next 실행되고, complete, dispose
        // 3. from : 배열의 원소를 각각 전달하고 싶다 (반복문 대체)
        // 4. repeatElement + take : 몇 개만 방출하도록 제한 걸어둠
        Observable.just(item)
            .subscribe { value in
                print("subscribe - \(value)")
            } onError: { error in
                print("error - \(error)")
            } onCompleted: {
                print("onCompleted")
            } onDisposed: {
                print("onDisposed")     // 리소스가 정리될 때, 확인 가능
            }
            .disposed(by: disposeBag)
        
        // 일반적으로 dispose가 될 뗴 : 클래스가 deinit될 때.
        // 여기서는 바로 dipose가 되는 이유
        // just는 가지고 있는 데이터를 그대로 보내주는 operator이다.
        // 즉, item을 보내기만 하면 더 이상 보낼 데이터가 없기 때문에 "할 일을 다 했다" 치고 complete가 실행된다
        // complete가 실행되었다는 건 굳이 메모리에 계속 올려둘 필요가 없기 때문에 dispose가 된다
    }
    
    
}
