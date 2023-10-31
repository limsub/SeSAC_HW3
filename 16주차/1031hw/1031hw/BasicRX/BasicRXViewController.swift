//
//  BasicRXViewController.swift
//  1031hw
//
//  Created by 임승섭 on 2023/10/31.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BasicRXViewController: UIViewController {
    
    /* 기본 인스턴스 생성 */
    let tableView = UITableView()
    let basicLabel = UILabel()
    let basicTextField = UITextField()
    let basicButton = UIButton()
    
    func setConfigure() {
        view.addSubview(tableView)
        view.addSubview(basicLabel)
        view.addSubview(basicTextField)
        view.addSubview(basicButton)
    }
    func setConstraints() {
        basicLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.horizontalEdges.equalTo(view)
            make.height.equalTo(50)
        }
        basicTextField.snp.makeConstraints { make in
            make.top.equalTo(basicLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view)
            make.height.equalTo(50)
        }
        basicButton.snp.makeConstraints { make in
            make.top.equalTo(basicTextField.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(view)
            make.height.equalTo(50)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(basicButton.snp.bottom).offset(10)
            make.horizontalEdges.bottom.equalTo(view)
            
        }
        
        
    }
    func setBackgroundColor() {
        basicLabel.backgroundColor = .blue
        basicTextField.backgroundColor = .red
        basicButton.backgroundColor = .green
        tableView.backgroundColor = .yellow
    }
    
    /* rx */
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setConfigure()
        setConstraints()
        setBackgroundColor()
        
        basicTableView()
//        basicButtonClickedBySubscribe()
//        basicButtonClickedByBind()
//        basicButtonClickedByBindAndRX()
        basicButtonClikcedByBindAndShare()
    }
    
    func basicTableView() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just(["first", "second", "third"])
        
        items.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
        
        
        // 셀 선택 시
        tableView.rx
            .modelSelected(String.self) // String으로 타입 변경
            .map { data in  // map으로 또 변경
                "\(data)를 클릭했어요"
            }
            .bind(to: basicLabel.rx.text)
            .disposed(by: disposeBag)
        
    }
    
    // 버튼 클릭 : observable (이벤트 전달)
    // 레이블, 텍스트필드에 표시 : observer (이벤트 처리)
    // 항상 1대 1은 아닐 수 있다
    
    // subscribe와 bind 대표적인 차이점
    // (1). subscribe에서는 error complete를 내가 안썼고, bind에서는 못쓰고
    // (2). bind는 주로 UI 작업을 하기 때문에 메인 쓰레드에서 동작하는 것을 보장한다 subscribe에서는 이게 안되기 때문에 .observe(MainScheduler.instance) 를 써준다
    // 1. subscribe로 해보기
    func basicButtonClickedBySubscribe() {
        basicButton.rx.tap
            .observe(on: MainScheduler.instance)    // 메인 쓰레드에서 돌아갈 수 있도록 보장 (UI작업)
            .subscribe { _ in
                // addTarget 내용을 안에 적어준다
                // rx 기반으로 작성해도 되고, 안해도 된다. onNext의 타입은 void -> void 클로저
                print("클릭되었다")
                self.basicLabel.text = "클릭클릭"
                self.basicTextField.text = "클클릭릭"
            } onDisposed: {
                print("디즈포오즈")
            }
            .disposed(by: disposeBag)
    }
    
    // 2. bind로 해보기
    func basicButtonClickedByBind() {
        basicButton.rx.tap
            .bind { value in
                print("클리리리리리릭 \(value)")
                self.basicLabel.text = "크으으으을릭"
                self.basicTextField.text = "크아아아아아아아"
            }
            .disposed(by: disposeBag)
    }
    
    // 3. bind + rx로 써보기
    func basicButtonClickedByBindAndRX() {
        basicButton.rx.tap
            .map { "클릭이다아아아아" }   // 바로 바인드하고 싶을 땐, 타입 변환을 해주어야 한다
            .bind(to: basicLabel.rx.text, basicTextField.rx.placeholder)
            .disposed(by: disposeBag)
    }
    
    // 4. bind + share 해보기
    func basicButtonClikcedByBindAndShare() {
        // 나중에 drive : bind의 특성 + 스트림 공유(share까지)
        let sample = basicButton.rx.tap
            .map { "하이하이 \(Int.random(in: 1...100))" }
            .share()
        
        sample.bind(to: basicLabel.rx.text)
            .disposed(by: disposeBag)
        
        sample.bind(to: basicTextField.rx.text)
            .disposed(by: disposeBag)
        
        sample.bind(to: basicButton.rx.title())
            .disposed(by: disposeBag)
        
    }
    
    
}
