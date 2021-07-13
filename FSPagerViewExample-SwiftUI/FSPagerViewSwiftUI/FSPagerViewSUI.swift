//
//  FSPagerViewSUIContainer.swift
//  FSPagerViewExample-SwiftUI
//
//  Created by Hien Pham on 7/3/21.
//

import Foundation
import SwiftUI
import FSPagerView

public struct FSPagerViewSUI<Data: Identifiable, Cell: View>: View {
    private let content: (Data) -> Cell
    private let data: [Data]
    public var currentIndex: Binding<Int>?
    public var animateChangeCurrentIndex: Binding<Bool>?
    @State var currentPageDefault: Int = 0
    @State var animateChangeCurrentIndexDefault: Bool = false
    private var scrollDirection: FSPagerView.ScrollDirection = .horizontal
    private var automaticSlidingInterval: CGFloat = 0.0
    private var isInfinite: Bool = false
    private var interitemSpacing: CGFloat = 0
    private var itemSize: CGSize = FSPagerView.automaticSize
    private var decelerationDistance: UInt = 0
    private var isScrollEnabled: Bool = true
    private var bounces: Bool = true
    private var alwaysBounceHorizontal: Bool = false
    private var alwaysBounceVertical: Bool = false
    private var removesInfiniteLoopForSingleItem: Bool = false
    private var backgroundView: AnyView?
    private var transformer: FSPagerViewTransformer?
    private var didSelect: ((Int) -> Void)?
    
    init(_ data: [Data], _ content: @escaping (Data) -> Cell) {
        self.init(nil, nil, data, content)
    }

    init(_ currentIndex: Binding<Int>,
         _ data: [Data], _ content: @escaping (Data) -> Cell) {
        self.init(.some(currentIndex), nil, data, content)
    }

    init(_ currentIndex: Binding<Int>,
         _ animateChangeCurrentIndex: Binding<Bool>,
         _ data: [Data], _ content: @escaping (Data) -> Cell) {
        self.init(.some(currentIndex), .some(animateChangeCurrentIndex), data, content)
    }
    
    private init(_ currentIndex: Binding<Int>? = nil,
                 _ animateChangeCurrentIndex: Binding<Bool>? = nil,
                 _ data: [Data], _ content: @escaping (Data) -> Cell) {
        self.currentIndex = currentIndex
        self.animateChangeCurrentIndex = animateChangeCurrentIndex
        self.data = data
        self.content = content
    }

    public var body: some View {
        FSPagerViewSUIOrigin(currentIndex ?? $currentPageDefault,
                             animateChangeCurrentIndex ?? $animateChangeCurrentIndexDefault,
                             data, content)
            .scrollDirection(scrollDirection)
            .automaticSlidingInterval(automaticSlidingInterval)
            .isInfinite(isInfinite)
            .interitemSpacing(interitemSpacing)
            .itemSize(itemSize)
            .decelerationDistance(decelerationDistance)
            .isScrollEnabled(isScrollEnabled)
            .bounces(bounces)
            .alwaysBounceHorizontal(alwaysBounceHorizontal)
            .removesInfiniteLoopForSingleItem(removesInfiniteLoopForSingleItem)
            .backgroundView(backgroundView)
            .transformer(transformer)
            .didSelect(didSelect)
    }
}

// MARK: - Properties bridging
extension FSPagerViewSUI {
    public func scrollDirection(_ newValue: FSPagerView.ScrollDirection) -> FSPagerViewSUI {
        var modified = self
        modified.scrollDirection = newValue
        return modified
    }

    public func automaticSlidingInterval(_ newValue: CGFloat) -> FSPagerViewSUI {
        var modified = self
        modified.automaticSlidingInterval = newValue
        return modified
    }
    
    public func isInfinite(_ newValue: Bool) -> FSPagerViewSUI {
        var modified = self
        modified.isInfinite = newValue
        return modified
    }
    
    public func interitemSpacing(_ newValue: CGFloat) -> FSPagerViewSUI {
        var modified = self
        modified.interitemSpacing = newValue
        return modified
    }
    
    public func itemSize(_ newValue: CGSize) -> FSPagerViewSUI {
        var modified = self
        modified.itemSize = newValue
        return modified
    }

    public func decelerationDistance(_ newValue: UInt) -> FSPagerViewSUI {
        var modified = self
        modified.decelerationDistance = newValue
        return modified
    }

    public func isScrollEnabled(_ newValue: Bool) -> FSPagerViewSUI {
        var modified = self
        modified.isScrollEnabled = newValue
        return modified
    }

    public func bounces(_ newValue: Bool) -> FSPagerViewSUI {
        var modified = self
        modified.bounces = newValue
        return modified
    }

    public func alwaysBounceHorizontal(_ newValue: Bool) -> FSPagerViewSUI {
        var modified = self
        modified.alwaysBounceHorizontal = newValue
        return modified
    }

    public func alwaysBounceVertical(_ newValue: Bool) -> FSPagerViewSUI {
        var modified = self
        modified.alwaysBounceVertical = newValue
        return modified
    }

    public func removesInfiniteLoopForSingleItem(_ newValue: Bool) -> FSPagerViewSUI {
        var modified = self
        modified.removesInfiniteLoopForSingleItem = newValue
        return modified
    }
    
    public func backgroundView<Background>(_ background: Background) -> FSPagerViewSUI where Background : View {
        var modified = self
        modified.backgroundView = AnyView(background)
        return modified
    }
    
    public func transformer(_ newValue: FSPagerViewTransformer?) -> FSPagerViewSUI {
        var modified = self
        modified.transformer = newValue
        return modified
    }
    
    public func didSelect(_ newValue: ((Int) -> Void)?) -> FSPagerViewSUI {
        var modified = self
        modified.didSelect = newValue
        return modified
    }
}
