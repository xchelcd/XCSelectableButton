//
//  ChipCollectionGroup.swift
//  Switching Button
//
//  Created by Xchel Carranza on 29/12/22.
//

import UIKit

@available(iOS 15.0, *)
public class XCSelectableCollectionGroup<D>: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout where D: SelectableDelegate {
    
    weak private var selectionDelegate: D?
    
    private var list: [D.T] = []
    private var type: XCSelectableButton.SelectableType = .chip
    
    public init(type: XCSelectableButton.SelectableType, list: [D.T], delegate: D?) where D: SelectableDelegate {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        self.type = type
        self.list = list
        self.selectionDelegate = delegate
        setupCollectionView()
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        list.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? SelectableCollectionCellGroup else {
            return UICollectionViewCell()
        }
        
        let item = list[indexPath.row]
        cell.bindData(type: type, data: item, delegate: selectionDelegate)
//        cell.backgroundColor = .cyan.withAlphaComponent(CGFloat(list.count - indexPath.item) / 10.0)
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = (list[indexPath.item] as! SelectableNameProtocol).toString()
        return CGSize(width: CGFloat(10 + title.count*10), height: CGFloat(45))
    }
    
    /// Setup bottom constraint
    ///
    /// - Parameter forBottom: constraint to bottom view. Example: mTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
    /// - Parameter safeArea: just in case it is anchor to the bottom of screen. Example: self.view.safeAreaLayoutGuide
    /// - Returns: Void
    /// - Throws: None
    func setupConstraint(forBottom bottomConstaint: NSLayoutConstraint/*, safeArea: UILayoutGuide*/) {
        let windows = UIApplication.shared.windows.first // safeArea.layoutFrame
//        let topSafeArea = windows?.safeAreaInsets.top
        let bottomSafeArea = windows?.safeAreaInsets.bottom ?? 0//windows.height
        let heihgt = UIScreen.main.bounds.height
        let allowedHeight = CGFloat(heihgt - bottomSafeArea)
        let estimatedHeight = CGFloat(35 * list.count / 2)
        
        if estimatedHeight < allowedHeight {
            bottomConstaint.isActive = false
            NSLayoutConstraint.activate([
                self.heightAnchor.constraint(equalToConstant: estimatedHeight)
            ])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
    
    public override var intrinsicContentSize: CGSize {
        return self.contentSize
    }
}

@available(iOS 15.0, *)
extension XCSelectableCollectionGroup {
    private func setupCollectionView() {
        self.delegate = self
        self.dataSource = self
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(SelectableCollectionCellGroup.self, forCellWithReuseIdentifier: "cell")
        self.allowsSelection = false
    }
}
