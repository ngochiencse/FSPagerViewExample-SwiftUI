//
//  PagerList.swift
//  FSPagerViewExample-SwiftUI
//
//  Created by Hien Pham on 5/28/21.
//

import Foundation
import SwiftUI
import FSPagerView

public struct FSPagerViewSUIOrigin<Data: Identifiable, Cell: View>: UIViewRepresentable {

    private let content: (Data) -> Cell
    private let data: [Data]
    @Binding public var currentIndex: Int
    @Binding public var animateChangeCurrentIndex: Bool
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
    
    init(_ currentIndex: Binding<Int>,
         _ animateChangeCurrentIndex: Binding<Bool>,
         _ data: [Data], _ content: @escaping (Data) -> Cell) {
        self.data = data
        self.content = content
        _currentIndex = currentIndex
        _animateChangeCurrentIndex = animateChangeCurrentIndex
    }
    
    public func makeUIView(context: Context) -> FSPagerView {
        let pagerView = FSPagerView()
        updatePropertyValues(pagerView)
        pagerView.register(HostingCell<Cell>.self, forCellWithReuseIdentifier: "Cell")
        pagerView.delegate = context.coordinator
        pagerView.dataSource = context.coordinator
        context.coordinator.data = data
        pagerView.layoutIfNeeded()
        DispatchQueue.main.async {
            self.updateCurrentPage(pagerView, context.coordinator)
        }
        return pagerView
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(data, content, self)
    }

    public func updateUIView(_ pagerView: FSPagerView, context: Context) {
        updatePropertyValues(pagerView)
        let oldIdList = context.coordinator.data.map { ele in
            ele.id
        }
        let newIdList = data.map { ele in
            ele.id
        }
        if oldIdList != newIdList {
            context.coordinator.data = data
            pagerView.reloadData()
        }
        updateCurrentPage(pagerView, context.coordinator)
    }
    
    private func updatePropertyValues(_ pagerView: FSPagerView) {
        if pagerView.scrollDirection != scrollDirection {
            pagerView.scrollDirection = scrollDirection
        }
        if pagerView.automaticSlidingInterval != automaticSlidingInterval {
            pagerView.automaticSlidingInterval = automaticSlidingInterval
        }
        if pagerView.isInfinite != isInfinite {
            pagerView.isInfinite = isInfinite
        }
        if pagerView.interitemSpacing != interitemSpacing {
            pagerView.interitemSpacing = interitemSpacing
        }
        if pagerView.itemSize != itemSize {
            pagerView.itemSize = itemSize
        }
        if pagerView.decelerationDistance != decelerationDistance {
            pagerView.decelerationDistance = decelerationDistance
        }
        if let backgroundView = backgroundView {
            pagerView.backgroundView = UIHostingController(rootView: backgroundView).view
        } else {
            pagerView.backgroundView = nil
        }
    }
    
    private func updateCurrentPage(_ pagerView: FSPagerView, _ coordinator: Coordinator) {
        if pagerView.currentIndex != currentIndex && pagerView.isTracking == false &&
            currentIndex < data.count {
            coordinator.lock = true
            pagerView.scrollToItem(at: currentIndex, animated: animateChangeCurrentIndex)
        }
    }
    
    func callDidSelect(at index: Int) {
        didSelect?(index)
    }

    public class Coordinator: NSObject, FSPagerViewDataSource, FSPagerViewDelegate {
        private let content: (Data) -> Cell
        var data: [Data]
        var lock: Bool = false
        let pagerSUI: FSPagerViewSUIOrigin

        init(_ data: [Data], _ content: @escaping (Data) -> Cell,
             _ pagerSUI: FSPagerViewSUIOrigin) {
            self.data = data
            self.content = content
            self.pagerSUI = pagerSUI
        }

        public func numberOfItems(in pagerView: FSPagerView) -> Int {
            data.count
        }
        
        public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
            guard let pagerCell = pagerView.dequeueReusableCell(withReuseIdentifier: "Cell", at: index) as? HostingCell<Cell> else {
                return FSPagerViewCell()
            }
            let data = self.data[index]
            let view = content(data)
            pagerCell.setup(with: view)
            return pagerCell
        }
        
        public func pagerViewDidScroll(_ pagerView: FSPagerView) {
            if lock == false {
                pagerSUI.currentIndex = pagerView.currentIndex
            } else {
                if pagerView.currentIndex == pagerSUI.currentIndex {
                    lock = false
                }
            }
        }
        
        public func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
            pagerSUI.callDidSelect(at: index)
        }
    }
}

private class HostingCell<Content: View>: FSPagerViewCell {
    var host: UIHostingController<Content>?

    func setup(with view: Content) {
        contentView.layer.shadowOpacity = 0

        if host == nil {
            let controller = UIHostingController(rootView: view)
            host = controller

            guard let content = controller.view else { return }
            content.backgroundColor = .clear
            content.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(content)

            content.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            content.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            content.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
            content.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        } else {
            host?.rootView = view
        }

        setNeedsLayout()
    }
}

// MARK: - Properties bridging
extension FSPagerViewSUIOrigin {
    public func scrollDirection(_ newValue: FSPagerView.ScrollDirection) -> FSPagerViewSUIOrigin {
        var modified = self
        modified.scrollDirection = newValue
        return modified
    }

    public func automaticSlidingInterval(_ newValue: CGFloat) -> FSPagerViewSUIOrigin {
        var modified = self
        modified.automaticSlidingInterval = newValue
        return modified
    }
    
    public func isInfinite(_ newValue: Bool) -> FSPagerViewSUIOrigin {
        var modified = self
        modified.isInfinite = newValue
        return modified
    }
    
    public func interitemSpacing(_ newValue: CGFloat) -> FSPagerViewSUIOrigin {
        var modified = self
        modified.interitemSpacing = newValue
        return modified
    }
    
    public func itemSize(_ newValue: CGSize) -> FSPagerViewSUIOrigin {
        var modified = self
        modified.itemSize = newValue
        return modified
    }

    public func decelerationDistance(_ newValue: UInt) -> FSPagerViewSUIOrigin {
        var modified = self
        modified.decelerationDistance = newValue
        return modified
    }

    public func isScrollEnabled(_ newValue: Bool) -> FSPagerViewSUIOrigin {
        var modified = self
        modified.isScrollEnabled = newValue
        return modified
    }

    public func bounces(_ newValue: Bool) -> FSPagerViewSUIOrigin {
        var modified = self
        modified.bounces = newValue
        return modified
    }

    public func alwaysBounceHorizontal(_ newValue: Bool) -> FSPagerViewSUIOrigin {
        var modified = self
        modified.alwaysBounceHorizontal = newValue
        return modified
    }

    public func alwaysBounceVertical(_ newValue: Bool) -> FSPagerViewSUIOrigin {
        var modified = self
        modified.alwaysBounceVertical = newValue
        return modified
    }

    public func removesInfiniteLoopForSingleItem(_ newValue: Bool) -> FSPagerViewSUIOrigin {
        var modified = self
        modified.removesInfiniteLoopForSingleItem = newValue
        return modified
    }
    
    public func backgroundView<Background>(_ background: Background) -> FSPagerViewSUIOrigin where Background : View {
        var modified = self
        modified.backgroundView = AnyView(background)
        return modified
    }
    
    public func transformer(_ newValue: FSPagerViewTransformer?) -> FSPagerViewSUIOrigin {
        var modified = self
        modified.transformer = newValue
        return modified
    }
    
    public func didSelect(_ newValue: ((Int) -> Void)?) -> FSPagerViewSUIOrigin {
        var modified = self
        modified.didSelect = newValue
        return modified
    }
}
