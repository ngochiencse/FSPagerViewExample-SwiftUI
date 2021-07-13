//
//  FSPageControlSUI.swift
//  FSPagerViewExample-SwiftUI
//
//  Created by Hien Pham on 6/30/21.
//

import Foundation
import SwiftUI
import FSPagerView

public struct FSPageControlSUI: UIViewRepresentable {
    private var numberOfPages: Int = 0
    
    /// The current page, highlighted by the page control. Default is 0.
    @Binding public var currentPage: Int
    
    /// The spacing to use of page indicators in the page control.
    private var itemSpacing: CGFloat = 6
    
    /// The spacing to use between page indicators in the page control.
    private var interitemSpacing: CGFloat = 6
    
    /// The distance that the page indicators is inset from the enclosing page control.
    private var contentInsets: UIEdgeInsets = .zero
    
    /// The horizontal alignment of content within the control’s bounds. Default is center.
    private var contentHorizontalAlignment: UIControl.ContentHorizontalAlignment = .center
    
    /// Hide the indicator if there is only one page. default is NO
    private var hidesForSinglePage: Bool = false
    
    internal var strokeColors: [UIControl.State: UIColor?] = [:]
    internal var fillColors: [UIControl.State: UIColor?] = [:]
    internal var images: [UIControl.State: UIImage?] = [:]
    internal var alphas: [UIControl.State: CGFloat?] = [:]
    internal var paths: [UIControl.State: UIBezierPath?] = [:]

    
    init(currentPage: Binding<Int>) {
        _currentPage = currentPage
    }
        
    public func makeUIView(context: Context) -> FSPageControl {
        let pageControl = FSPageControl()
        updatePropertyValues(pageControl)
        pageControl.addTarget(context.coordinator,
                              action: #selector(Coordinator.updateCurrentPage(sender:)),
                              for: .valueChanged)
        return pageControl
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func updateUIView(_ pageControl: FSPageControl, context: Context) {
        updatePropertyValues(pageControl)
    }
    
    private func updatePropertyValues(_ pageControl: FSPageControl) {
        pageControl.currentPage = currentPage
        pageControl.numberOfPages = numberOfPages
        pageControl.itemSpacing = itemSpacing
        pageControl.interitemSpacing = interitemSpacing
        pageControl.contentInsets = contentInsets
        pageControl.contentHorizontalAlignment = contentHorizontalAlignment
        pageControl.hidesForSinglePage = hidesForSinglePage
        for (state, color) in strokeColors {
            pageControl.setStrokeColor(color, for: state)
        }
        for (state, color) in fillColors {
            pageControl.setFillColor(color, for: state)
        }
    }
    
    
    public class Coordinator: NSObject {
        var control: FSPageControlSUI

        init(_ control: FSPageControlSUI) {
            self.control = control
        }

        @objc
        func updateCurrentPage(sender: FSPageControl) {
            control.currentPage = sender.currentPage
        }
    }
}

// MARK: - Properties bridging
extension FSPageControlSUI {
    public func numberOfPages(_ newValue: Int) -> FSPageControlSUI {
        var modified = self
        modified.numberOfPages = newValue
        return modified
    }
    
    public func itemSpacing(_ newValue: CGFloat) -> FSPageControlSUI {
        var modified = self
        modified.itemSpacing = newValue
        return modified
    }
    
    public func interitemSpacing(_ newValue: CGFloat) -> FSPageControlSUI {
        var modified = self
        modified.interitemSpacing = newValue
        return modified
    }
    
    public func contentHorizontalAlignment(_ contentHorizontalAlignment: UIControl.ContentHorizontalAlignment) -> FSPageControlSUI {
        var modified = self
        modified.contentHorizontalAlignment = contentHorizontalAlignment
        return modified
    }
    
    public func contentInsets(_ newValue: UIEdgeInsets) -> FSPageControlSUI {
        var modified = self
        modified.contentInsets = newValue
        return modified
    }
    
    public func setStrokeColor(_ strokeColor: UIColor?, for state: UIControl.State) -> FSPageControlSUI {
        var modified = self
        guard self.strokeColors[state] != strokeColor else {
            return self
        }
        modified.strokeColors[state] = strokeColor
        return modified
    }
    
    public func setFillColor(_ fillColor: UIColor?, for state: UIControl.State) -> FSPageControlSUI {
        var modified = self
        guard self.fillColors[state] != fillColor else {
            return self
        }
        modified.fillColors[state] = fillColor
        return modified
    }
    
    public func setImage(_ image: UIImage?, for state: UIControl.State) -> FSPageControlSUI {
        var modified = self
        guard self.images[state] != image else {
            return self
        }
        modified.images[state] = image
        return modified
    }
    
    public func setAlpha(_ alpha: CGFloat, for state: UIControl.State) -> FSPageControlSUI {
        var modified = self
        guard self.alphas[state] != alpha else {
            return self
        }
        modified.alphas[state] = alpha
        return modified
    }
    
    
    public func setPath(_ path: UIBezierPath?, for state: UIControl.State) -> FSPageControlSUI {
        var modified = self
        guard self.paths[state] != path else {
            return self
        }
        modified.paths[state] = path
        return modified
    }
}
