//
//  MYPTextParseViewController.swift
//  moviePro
//
//  Created by 王智刚 on 2018/10/26.
//  Copyright © 2018年 sankuai. All rights reserved.
//

import Foundation
import UIKit
import ReactiveSwift

final class MYPTextParserBox: Equatable {
    let text: String
    let index: Int
    var bgColor: UIColor {
        return isSymbol ? .gray : .lightGray
    }
    var font: UIFont = .Font(13)
    var selected: Bool = false {
        didSet {
            changeSelected?(selected)
        }
    }
    var changeSelected: ((Bool) -> Void)?
    var width: CGFloat {
        return text.size(font, size: CGSize(width: 1000, height: 20), lineBreadMode: .byCharWrapping).width + 15
    }
    var isSpecial: Bool {
        return text.containSpecial
    }
    var isSymbol: Bool {
        return text.containSymbol
    }
    var isEmoji: Bool {
        return text.containEmoji
    }
    
    init(text: String, index: Int) {
        self.text = text
        self.index = index
    }
    
    public static func == (lhs: MYPTextParserBox, rhs: MYPTextParserBox) -> Bool {
        return lhs.index == rhs.index
    }
}

final class MYPTextParseCell: UICollectionViewCell {
    private let contentLabel: UILabel = UILabel(frame: .zero, font: .Font(13), andTextColor: UIColor.x26282E.alpha(0.6))
    var box: MYPTextParserBox? {
        didSet {
            contentLabel.text = box?.text
            contentLabel.sizeToFit()
            self.backgroundColor = box?.bgColor
            self.backgroundColor = box?.selected ?? false ? .blue : self.box?.bgColor
            box?.changeSelected = { selected in
                self.backgroundColor = selected ? .blue : self.box?.bgColor
                self.contentLabel.textColor = self.box?.selected ?? false ? UIColor.white.withAlphaComponent(0.6) : UIColor.x26282E.withAlphaComponent(0.6)
            }
            self.contentLabel.textColor = box?.selected ?? false ? UIColor.white.withAlphaComponent(0.6) : UIColor.x26282E.withAlphaComponent(0.6)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(contentLabel)
        self.layer.cornerRadius = 5
        contentLabel.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentLabel.center = CGPoint(x: contentView.width * 0.5, y: height * 0.5)
    }
}

fileprivate let cellId = "MYPTextParseCell"

final class MYPTextParseViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: Porperty - Public
    
    var dataSource: [MYPTextParserBox] = []
    private(set) var selectedWords: [MYPTextParserBox] = []
    var wordsChangeClosure: (([MYPTextParserBox]) -> Void)?
    
    //MARK: Porperty - Private
    
    private enum PanDirection {
        case left
        case right
        case none
        
        static func direction(begin: IndexPath, current: IndexPath) -> PanDirection {
            return begin.item < current.item ? .right : .left
        }
    }
    private let layout = UICollectionViewFlowLayout()
    private var panGesture: UIPanGestureRecognizer?
    private var panIndexPaths: [IndexPath] = []
    private var beginIndexPath: IndexPath?
    private var lastIndexPath: IndexPath?
    private var lastDirection: PanDirection = .none
    private var firstSelected = false
    
    //MARK: LiftCycle
    
    init(words: [String]) {
        super.init(collectionViewLayout: layout)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 3
        dataSource = words.enumerated().map {
            MYPTextParserBox(text: $1, index: $0)
        }
        setupGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.collectionView?.register(MYPTextParseCell.self, forCellWithReuseIdentifier: cellId)
        self.view.backgroundColor = .clear
        self.collectionView?.backgroundColor = .clear
    }
    
    //MARK: Method - Privete
    
    private func handleBeginIndexPath(_ indexPath: IndexPath) {
        if !self.panIndexPaths.contains(indexPath) {
            self.panIndexPaths.append(indexPath)
            self.beginIndexPath = indexPath
            self.lastIndexPath = indexPath
            self.firstSelected = !dataSource[indexPath.item].selected
            dataSource[indexPath.item].selected = self.firstSelected
            self.selecedWordsHandleBox(indexPath: indexPath)
            self.reloadCollecntion()
        }
    }
    
    @objc private func handlePan(pan: UIPanGestureRecognizer) {
        let point = pan.location(in: self.collectionView)
        guard let indexPath = self.collectionView?.indexPathForItem(at: point) else { return }
        guard indexPath.item < self.dataSource.count, indexPath.item > 0 else { return }
        switch pan.state {
        case .began:
            self.handleBeginIndexPath(indexPath)
        case .changed:
            guard let beginIndexPath = self.beginIndexPath else {
                self.handleBeginIndexPath(indexPath)
                return
            }
            guard self.lastIndexPath?.item != indexPath.item else { return }
            self.lastIndexPath = indexPath
            let direction = PanDirection.direction(begin: beginIndexPath, current: indexPath)
            self.lastDirection = self.lastDirection != .none ? self.lastDirection : direction
            if self.lastDirection != direction {
                self.lastDirection = direction
                self.handleDataSource(with: beginIndexPath)
            }
            self.handleBoxBetween(begin: beginIndexPath, current: indexPath)
            self.beginIndexPath = indexPath
            self.reloadCollecntion()
        case .ended, .cancelled, .possible, .failed:
            self.resetPanInfo()
        }
    }
    
    private func setupGesture() {
        panGesture = UIPanGestureRecognizer()
        if let panGesture = self.panGesture {
            self.view.addGestureRecognizer(panGesture)
        }
        panGesture?.addTarget(self, action: #selector(handlePan))
    }
    
    private func handleBoxBetween(begin: IndexPath, current: IndexPath) {
        let count = labs(current.item - begin.item)
        if count > 1 {
            for index in 1...count {
                let sIndexPath = begin.item < current.item ? IndexPath(item: begin.item + index, section: 0) : IndexPath(item: begin.item - index, section: 0)
                self.handleDataSource(with: sIndexPath)
            }
        } else if count == 1 {
            self.handleDataSource(with: current)
        }
    }
    
    private func handleDataSource(with indexPath: IndexPath) {
        self.dataSource[indexPath.item].selected = self.panIndexPaths.contains(indexPath) ? !self.dataSource[indexPath.item].selected : firstSelected
        if !self.panIndexPaths.contains(indexPath) {
            self.panIndexPaths.append(indexPath)
        }
        self.selecedWordsHandleBox(indexPath: indexPath)
    }
    
    private func resetPanInfo() {
        self.panIndexPaths.removeAll()
        self.beginIndexPath = nil
        self.lastIndexPath = nil
        self.lastDirection = .none
    }
    
    private func reloadCollecntion() {
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.collectionView?.performBatchUpdates({ [weak self] in
            guard let `self` = self else { return }
            self.collectionView?.reloadItems(at: self.panIndexPaths)
        }, completion: nil)
        CATransaction.commit()
    }
    
    //MARK: Method - Public
    
    func clear() {
        self.selectedWords = []
        resetPanInfo()
        dataSource.forEach { word in
            word.selected = false
        }
        collectionView?.reloadData()
        wordsChangeClosure?(selectedWords)
    }
}

extension MYPTextParseViewController {
    
    //MARK: Protocol - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: dataSource[indexPath.row].width, height: 30)
    }
    
    //MARK: Protocol - UICollectionViewDelegate, UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MYPTextParseCell
        cell.box = dataSource[indexPath.row]
        return cell
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dataSource[indexPath.item].selected.negate()
        selecedWordsHandleBox(indexPath: indexPath)
    }
    
    fileprivate func selecedWordsHandleBox(indexPath: IndexPath) {
        let box = dataSource[indexPath.item]
        if box.selected {
            if !selectedWords.contains(box) {
                selectedWords.append(box)
            }
        } else {
            if selectedWords.contains(box) {
                selectedWords.remove(box)
            }
        }
        wordsChangeClosure?(selectedWords)
    }
}

