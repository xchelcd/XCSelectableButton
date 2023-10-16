//
//  ChipTableGroup.swift
//  Switching Button
//
//  Created by Xchel Carranza on 29/12/22.
//

import UIKit

@available(iOS 15.0, *)
public class XCSelectableTableGroup<D>: UITableView, UITableViewDelegate, UITableViewDataSource where D: SelectableDelegate {
    
    private weak var selectionDelegate: D?
    
    private var list: [D.T] = []
    private var type: XCSelectableButton.SelectableType = .checkbox
    
    var allCells: Set<SelectableTableCellGroup> = Set()
    
    public init(type: XCSelectableButton.SelectableType, list: [D.T], delegate: D?) where D: SelectableDelegate {
        super.init(frame: .zero, style: .plain)
        self.type = type
        self.list = list
        self.selectionDelegate = delegate
        setupTableView()
    }
   
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        list.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SelectableTableCellGroup else {
            return UITableViewCell()
        }
        
        if !allCells.contains(cell) { allCells.insert(cell) }
        
        let item = list[indexPath.item]
        cell.bindData(type: type, data: item, delegate: selectionDelegate, table: self)
        return cell
    }
    
    private func setupTableView() {
        self.delegate = self
        self.dataSource = self
        self.translatesAutoresizingMaskIntoConstraints = false
        self.register(SelectableTableCellGroup.self, forCellReuseIdentifier: "cell")
        self.separatorColor = .clear
        self.allowsSelection = false
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
        let estimatedHeight = CGFloat(45 * list.count)
        
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
    
    init(frame: CGRect) {
        super.init(frame: frame, style: UITableView.Style.plain)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }
    
}
