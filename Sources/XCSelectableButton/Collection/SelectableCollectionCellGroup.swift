//
//  SelectableCollectionCellGroup.swift
//  Switching Button
//
//  Created by Xchel Carranza on 30/12/22.
//

import UIKit

@available(iOS 15.0, *)
public class SelectableCollectionCellGroup: UICollectionViewCell {
    
    var selectableButton: XCSelectableButton?
    
    func bindData<D>(type: XCSelectableButton.SelectableType, data: D.T?, delegate: D?) where D: SelectableDelegate {
        guard let data = data as? SelectableNameProtocol else {
            return
        }
        let selectableButton = XCSelectableButton(type: type, title: data.toString(), currentState: false)
        selectableButton.contentHorizontalAlignment = .center
        selectableButton.contentVerticalAlignment = .center
        contentView.addSubview(selectableButton)
        NSLayoutConstraint.activate([
            selectableButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            selectableButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
//            selectableButton.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 5),
//            selectableButton.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor, constant: -5),
//            selectableButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 5),
//            selectableButton.trailingAnchor.constraint(lessThanOrEqualTo: self.contentView.trailingAnchor, constant: -5),
        ])
        self.selectableButton = selectableButton
        selectableButton.onStateChangeListener = { selectableButton in
            delegate?.onSelected(data: data as! D.T, selectableButton: selectableButton)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
