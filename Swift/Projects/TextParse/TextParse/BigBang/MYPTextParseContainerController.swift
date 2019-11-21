//
//  MYPTextParseContainerController.swift
//  moviePro
//
//  Created by 王智刚 on 2018/10/29.
//  Copyright © 2018年 sankuai. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift
import enum Result.NoError

fileprivate extension UIButton {
    static func textOperateBtn(title: String) -> UIButton {
        let result = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 30))
        result.setTitle(title, for: .normal)
        result.setTitleColor(.white, for: .normal)
        result.titleLabel?.font = .Font(13)
        result.backgroundColor = .black
        result.layer.cornerRadius = 5
        return result
    }
}

final class MYPTextParseFooterView: UIView {
    private var cancelBtn: UIButton!
    var cancelClosure: (() -> Void)?
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: CGFloat.screenWidth, height: 60))
        cancelBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 44, height: 30))
        cancelBtn.setImage(UIImage(named: "may_upstairs_close"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(cacel), for: .touchUpInside)
        self.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(44)
            make.height.equalTo(30)
        }
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cacel() {
        self.cancelClosure?()
    }
}

final class MYPTextParseHeaderView: UIView {
    private var shareBtn: UIButton!
    private var searchBtn: UIButton!
    var shareClosure: (() -> Void)?
    var searchClosure: (() -> Void)?
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: CGFloat.screenWidth, height: 60))
        shareBtn = UIButton.textOperateBtn(title: "分享")
        shareBtn.addTarget(self, action: #selector(share), for: .touchUpInside)
        searchBtn = UIButton.textOperateBtn(title: "查询")
        searchBtn.addTarget(self, action: #selector(search), for: .touchUpInside)
        self.addSubview(shareBtn)
        self.addSubview(searchBtn)
        shareBtn.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(self).offset(-10)
            make.centerY.equalTo(self)
            make.width.equalTo(44)
            make.height.equalTo(30)
        }
        searchBtn.snp.makeConstraints { (make) -> Void in
            make.right.equalTo(shareBtn.snp.left).offset(-10)
            make.centerY.equalTo(self)
            make.width.equalTo(44)
            make.height.equalTo(30)
        }
        self.backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func search() {
        self.searchClosure?()
    }
    
    @objc func share() {
        self.shareClosure?()
    }
}

final class MYPTextParseContainerController: UIViewController {
    
    //MARK: Porperty - Public
    
    @objc var lastVC: UIViewController?
    
    //MARK: Porperty - Private

    private let headerView = MYPTextParseHeaderView().then {
        $0.isHidden = true
    }
    private let footerView = MYPTextParseFooterView()
    private var textParseResultVC: MYPTextParseViewController!
    
    //MARK: LiftCycle
    
    @objc init(word: String) {
        super.init(nibName: nil, bundle: nil)
        let words = word.parseByWords() ?? []
        textParseResultVC = MYPTextParseViewController(words: words)
        self.addChildViewController(textParseResultVC)
        bindAction()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .mainThemeBackground
        self.view.addSubview(headerView)
        self.view.addSubview(textParseResultVC.view)
        self.view.addSubview(footerView)
        headerView.top = 84
        textParseResultVC.view.top = headerView.bottom
        textParseResultVC.view.height = 200
        footerView.top = textParseResultVC.view.bottom + 10
    }
    
    //MARK: Method - Privete
    
    fileprivate func bindAction() {
        headerView.shareClosure = { [weak self] in
            guard let `self` = self else { return }
            let selectedWord = self.textParseResultVC.selectedWords.map { $0.text }.joined()
            print(selectedWord)
        }
        headerView.searchClosure = { [weak self] in
            guard let `self` = self else { return }
            SAKModalRepresentation.sharedInstance().hide(animated: false)
            let selectedWord = self.textParseResultVC.selectedWords.map { $0.text }.joined()
            let searchVC = MAYMovieSearchViewController()
            self.lastVC?.navigationController?.pushViewController(searchVC, animated: true)
            searchVC.rac_signal(for: #selector(UIViewController.viewDidAppear(_:))).subscribeNext {_ in 
                searchVC.searchBar.text = selectedWord
                searchVC.searchBarInternal(searchVC.searchBar, textDidChange: selectedWord, suggestionFlag: false)
            }
        }
        footerView.cancelClosure = { [weak self] in
            guard let `self` = self else { return }
            if self.textParseResultVC.selectedWords.count > 0 {
                self.textParseResultVC.clear()
            } else {
                SAKModalRepresentation.sharedInstance().hide(animated: false)
            }
        }
        textParseResultVC?.wordsChangeClosure = { [weak self] words in
            guard let `self` = self else { return }
            self.headerView.isHidden = !(words.count > 0)
        }
    }
}
