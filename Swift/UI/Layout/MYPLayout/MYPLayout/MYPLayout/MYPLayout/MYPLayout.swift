//
//  MYPLayout.swift
//  MYPLayout
//
//  Created by 王智刚 on 2018/12/11.
//  Copyright © 2018 王智刚. All rights reserved.
//

import UIKit

extension UIView {
    var layout: MYPLayout {
        return .view(self, .empty)
    }
}

// MARK: - 更新子视图
extension UIView {
    func setSubviews<S: Sequence>(_ other: S) where S.Element == UIView {
        let others = Set(other)
        let sub = Set(self.subviews)
        for v in sub.subtracting(others) {
            v.removeFromSuperview()
        }
        
        for v in others.subtracting(sub) {
            self.addSubview(v)
        }
    }
}

/// 布局方式
///
/// - view: 单一view的普通布局
/// - space: 间隔布局
/// - box: 所有子视图都封装到一个视图中，类似于前端中布局的块处理
/// - newline: 从下行开始，类似于前端布局中的行处理
/// - choice: 异常态下的UI处理
/// - empty: 空处理
indirect enum MYPLayout {
    case view(UIView, MYPLayout)
    case space(MYPWidth, MYPLayout)
    case box(contents: MYPLayout, MYPWidth, wrapper: UIView?, MYPLayout)
    case newline(space: CGFloat, MYPLayout)
    case choice(MYPLayout, MYPLayout)
    case empty
}

extension MYPLayout {
    func or(_ other: MYPLayout) -> MYPLayout {
        return .choice(self, other)
    }
    
    func box(wrapper: UIView? = nil, width: MYPWidth = .basedOnContents) -> MYPLayout {
        return .box(contents: self, width, wrapper: wrapper, .empty)
    }
}

extension MYPLayout {
    var centered: MYPLayout {
        return [.space(.flexible(min: 0), .empty), self, .space(.flexible(min: 0), .empty)].horizontal()
    }
    
    func top(_ height: CGFloat) -> MYPLayout {
        return [.space(.flexible(min: 0), .empty), self].vertical(space: height)
    }
}

extension MYPLayout {
    func apply(containerWidth: CGFloat, containerHeight: CGFloat = 0) -> [UIView] {
        let lines = self.computeLines(containerWidth: containerWidth, currentX: 0)
        return lines.apply(containerWidth: containerWidth, startAt: .zero)
    }
}

extension MYPLayout {
    func computeLines(containerWidth: CGFloat, containerHeight: CGFloat = 0, currentX: CGFloat) -> [MYPLine] {
        var x = currentX
        var current: MYPLayout = self
        var lines: [MYPLine] = []
        var line: MYPLine = MYPLine(elements: [], space: 0)
        while true {
            switch current {
            case let .view(v, next):
                let availableWidth = containerWidth - x
                let size = v.sizeThatFits(CGSize(width: availableWidth, height: .greatestFiniteMagnitude))
                x += size.width
                line.elements.append(.view(v, size))
                current = next
            case let .space(w, next):
                x += w.min
                line.elements.append(.space(w))
                current = next
            case let .box(contents, w, wrapper, next):
                let margins = (wrapper?.layoutMargins).map { $0.left + $0.right } ?? 0
                let availableWidth = containerWidth - margins - x
                let lines = contents.computeLines(containerWidth: availableWidth, currentX: x)
                let result = MYPLine.Element.box(lines, w, wrapper: wrapper)
                x += result.minWidth
                line.elements.append(result)
                current = next
            case let .newline(space, next):
                x = 0
                lines.append(line)
                line = MYPLine(elements: [], space: space)
                current = next
            case let .choice(first, second):
                var firstLines = first.computeLines(containerWidth: containerWidth, currentX: x)
                firstLines[0].elements.insert(contentsOf: line.elements, at: 0)
                firstLines[0].space += line.space
                let tooWide = firstLines.contains { $0.minWidth > containerWidth }
                if tooWide {
                    current = second
                } else {
                    return lines + firstLines
                }
            case .empty:
                lines.append(line)
                return lines
            }
        }
        return lines
    }
}

/// 每个布局的宽度
///
/// - absolute: 直接使用宽度
/// - flexible: 多个块等分处理，min代表每个块的最小值
/// - basedOnContents: 取视图树中的最小宽度
enum MYPWidth: Equatable {
    case absolute(CGFloat)
    case flexible(min: CGFloat)
    case basedOnContents
    
    var isFlexible: Bool {
        switch self {
        case .absolute: return false
        case .flexible: return true
        case .basedOnContents: return false
        }
    }
    
    var min: CGFloat {
        switch self {
        case let .absolute(x): return x
        case let .flexible(x): return x
        case .basedOnContents:
            return 0
        }
    }
}

/// 每行UI的抽象逻辑封装
struct MYPLine {
    enum Element {
        case view(UIView, CGSize)
        case space(MYPWidth)
        case box([MYPLine], MYPWidth, wrapper: UIView?)
    }
    
    var elements: [Element]
    var space: CGFloat

    var minWidth: CGFloat {
        return elements.reduce(0) { $0 + $1.minWidth }
    }
    
    var numberOfFlexibleSpaces: Int {
        return elements.filter { $0.isFlexible }.count
    }
    
    var height: CGFloat {
        return elements.reduce(0) { $0 + $1.height }
    }
}

extension MYPLine.Element {
    var isFlexible: Bool {
        switch self {
        case .view: return false
        case let .space(width): return width.isFlexible
        case let .box(_, width, _): return width.isFlexible
        }
    }
    
    var minWidth: CGFloat {
        switch self {
        case let .view(_, size): return size.width
        case let .space(width): return width.min
        case let .box(lines, width, wrapper):
            guard width == .basedOnContents else { return width.min }
            let margins = (wrapper?.layoutMargins).map { $0.left + $0.right} ?? 0
            return lines.map { $0.minWidth }.max() ?? 0 + margins
        }
    }
    
    var width: MYPWidth {
        switch self {
        case let .view(_, size): return MYPWidth.absolute(size.width)
        case let .space(width): return width
        case let .box(_, width, _): return width
        }
    }
    
    func absoluteWidth(flexiableSpace: CGFloat) -> CGFloat {
        switch width {
        case let .absolute(w): return w
        case let .flexible(min): return min + flexiableSpace
        case .basedOnContents: return minWidth
        }
    }
    
    var height: CGFloat {
        switch self {
        case let .view(_, size): return size.height
        case .space(_): return 0
        case let .box(lines, _, _): return lines.flatMap { $0.elements }.map { $0.height }.max() ?? 0
        }
    }
}

extension Array where Element == MYPLine {
    
    var height: CGFloat {
        return self.reduce(0) { $0 + $1.height }
    }
    
    /// 抽象布局逻辑转化为具体视图
    ///
    /// - Parameters:
    ///   - containerWidth: 容器大小
    ///   - startAt: 起始位置
    /// - Returns: 包括嵌套的视图树
    func apply(containerWidth: CGFloat, containerHeight: CGFloat = 0, startAt: CGPoint) -> [UIView] {
        var result: [UIView] = []
        var origin = startAt
        for line in self {
            origin.x = startAt.x
            origin.y += line.space
            let availableWidth = containerWidth - line.minWidth
            let flexibleSpace = availableWidth / CGFloat(line.numberOfFlexibleSpaces)
            var lineHeight: CGFloat = 0
            var elementsHeight: CGFloat = 0
            for element in line.elements {
                elementsHeight += element.height
                switch element {
                case let .view(v, size):
                    result.append(v)
                    v.frame = CGRect(origin: origin, size: size)
                    origin.x += size.width
                    lineHeight = Swift.max(lineHeight, size.height)
                case .space(_):
                    origin.x += element.absoluteWidth(flexiableSpace: flexibleSpace)
                case let .box(contents, _, nil):
                    let width = element.absoluteWidth(flexiableSpace: flexibleSpace)
                    let views = contents.apply(containerWidth: width, startAt: origin)
                    origin.x += width
                    let height = (views.map { $0.frame.maxY }.max() ?? 0) - origin.y
                    lineHeight = Swift.max(height, lineHeight)
                    result.append(contentsOf: views)
                case let .box(contents, _, wrapper?):
                    let width = element.absoluteWidth(flexiableSpace: flexibleSpace)
                    let margins = wrapper.layoutMargins.left + wrapper.layoutMargins.right
                    let start = CGPoint(x: wrapper.layoutMargins.left, y: wrapper.layoutMargins.top)
                    let subviews = contents.apply(containerWidth: width - margins, startAt: start)
                    wrapper.setSubviews(subviews)
                    let contentMaxY = subviews.map { $0.frame.maxY }.max() ?? wrapper.layoutMargins.top
                    let size = CGSize(width: width, height: contentMaxY + wrapper.layoutMargins.bottom)
                    wrapper.frame = CGRect(origin: origin, size: size)
                    origin.x += size.width
                    lineHeight = Swift.max(lineHeight, size.height)
                    result.append(wrapper)
                 }
            }
            origin.y += lineHeight
        }
        return result
    }
}

func +(lhs: MYPLayout, rhs: MYPLayout) -> MYPLayout {
    switch lhs {
    case let .view(v, remainder):
        return .view(v, remainder + rhs)
    case let .space(w, r):
        return .space(w, r + rhs)
    case let .box(contents, w, wrapper, remainder):
        return .box(contents: contents, w, wrapper: wrapper, remainder + rhs)
    case let .newline(space, r):
        return .newline(space: space, r + rhs)
    case let .choice(l, r):
        return .choice(l + rhs, r + rhs)
    case .empty: return rhs
    }
}

extension BidirectionalCollection where Element == MYPLayout {

    /// 多个块水平布局
    ///
    /// - Parameter space: 间距
    /// - Returns: 水平布局后的布局逻辑树
    func horizontal(space: MYPWidth? = nil) -> MYPLayout {
        guard var result = last else { return .empty }
        for l in self.dropLast().reversed() {
            if let width = space {
                result = .space(width, result)
            }
            result = l + result
        }
        return result
    }
    
    /// 多个块垂直布局
    ///
    /// - Parameter space: 间距
    /// - Returns: 垂直布局后的布局逻辑树
    func vertical(space: CGFloat = 0) -> MYPLayout {
        guard var result = last else { return .empty }
        for l in self.dropLast().reversed() {
            result = l + .newline(space: space, result)
        }
        return result
    }
}

final class MYPLayoutContainer: UIView {
    private let _layout: MYPLayout
    init(_ layout: MYPLayout) {
        self._layout = layout
        super.init(frame: .zero)
        NotificationCenter.default.addObserver(self, selector: #selector(setNeedsLayout), name: UIContentSizeCategory.didChangeNotification, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let views = self._layout.apply(containerWidth: bounds.width)
        setSubviews(views)
    }
}
