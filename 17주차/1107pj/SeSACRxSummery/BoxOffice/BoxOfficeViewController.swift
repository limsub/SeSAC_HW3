//
//  ViewController.swift
//  SeSACRxSummery
//
//  Created by jack on 2023/11/06.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BoxOfficeViewController: UIViewController {
    
    let tableView = UITableView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout() )
    let searchBar = UISearchBar()
    
    let disposeBag = DisposeBag()
    
    let viewModel = BoxOfficeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
    
    func bind() {
        // asDriver 사용 시 매개변수가 있을 때(onErrorJustReturn)와 없을 때
        // relay : 에러가 나올 일이 없어 -> 예외처리 할 필요가 없음
        // subject : 모든 이벤트(next, complete, error)를 받을 수 있기 때문에 에러를 아예 처리하지 못하는 driver 입장에서, 그 전에 에러 처리를 해준다
        
        viewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: "MovieCell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element.movieNm) - \(element.openDt)"
            }
            .disposed(by: disposeBag)
        
        viewModel.recent
            .asDriver()
            .drive(collectionView.rx.items(cellIdentifier: "MovieCollectionCell", cellType: MovieCollectionViewCell.self)) { (row, element, cell) in
                cell.label.text = "\(element)"
            }
            .disposed(by: disposeBag)
        
        
        // debounce와 throttle의 차이
        // debounce : 기다렸다가 실행 (ex. 실시간 검색. 커서 멈추고 몇 초 후 네트워크 통신)
        // throttle : 실행되고 기다림 (ex. 연속으로 검색 버튼을 빠르게 누를 때. 클릭하고 나서 1초 동안 쿨타임)
        searchBar.rx.searchButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(searchBar.rx.text.orEmpty) { _, query in
                return query
            }
            .map { text -> Int in
                guard let newText = Int(text) else { return 20231106 }
                return newText
            }
            .flatMap {
                BoxOfficeNetwork.fetchBoxOfficeData(date: String($0))
            }
            .subscribe(with: self) { owner , value in
                let data = value.boxOfficeResult.dailyBoxOfficeList
                owner.viewModel.items.onNext(data)
            }
            .disposed(by: disposeBag)

        
        Observable.zip(tableView.rx.modelSelected(DailyBoxOfficeList.self), tableView.rx.itemSelected)
            .map { $0.0.movieNm }   // 실제로 사용할 건 얘밖에 없다
            .debug()
            .subscribe(with: self) { owner , value in
                
                // 데이터를 추가하는 방법
                // 1. owner.recent의 데이터를 가져와서 사용
                    // owner.recent.value()
                    // try 구문을 사용해야 한다는 단점
                // 2. relay 를 이용해
                    // complete, error를 받을 일이 없는 경우, 굳이 subject로 사용할 필요가 없다
                    // relay 사용 시 value() 써도 try 쓸 필요가 없다
                    // 사실 안으로 들어가보면 결국 내부적으로 try! 쓰고 있긴 함
                
                // 2 사용
                var data = owner.viewModel.recent.value
                data.insert(value , at: 0)
                owner.viewModel.recent.accept(data)
            }
            .disposed(by: disposeBag)
        
    }
    
    func configure() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        
        navigationItem.titleView = searchBar
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MovieCell")
        tableView.backgroundColor = .green
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: "MovieCollectionCell")
        collectionView.backgroundColor = .red
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
    }
     
    static func layout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 40)
        layout.scrollDirection = .horizontal
        return layout
    }
   
}
