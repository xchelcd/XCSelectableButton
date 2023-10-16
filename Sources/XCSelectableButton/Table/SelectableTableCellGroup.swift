//
//  ChipTableCellGroup.swift
//  Switching Button
//
//  Created by Xchel Carranza on 29/12/22.
//

import UIKit

@available(iOS 15.0, *)
public class SelectableTableCellGroup: UITableViewCell {
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public var selectableButton: XCSelectableButton?
    
    func bindData<D>(type: XCSelectableButton.SelectableType, data: D.T?, delegate: D?, table: SelectableTableGroup<D>) where D: SelectableDelegate {
        guard let data = data as? SelectableNameProtocol else {
            return
        }
        let selectableButton = XCSelectableButton(type: type, title: data.toString(), currentState: false)
        contentView.addSubview(selectableButton)
        NSLayoutConstraint.activate([
            selectableButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            selectableButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            selectableButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            selectableButton.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -10),
        ])
        self.selectableButton = selectableButton
        selectableButton.onStateChangeListener = { selectableButton in
            if type == .radioButton {
                self.removeSelection(table)
            }
            delegate?.onSelected(data: data as! D.T, selectableButton: selectableButton)
        }
    }
    
    public override func prepareForReuse() {
        selectableButton?.removeFromSuperview()
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

@available(iOS 15.0, *)
extension SelectableTableCellGroup {
    func removeSelection<D>(_ table: SelectableTableGroup<D>) {
        let cellsChecked = table.allCells.filter({ $0.selectableButton?.isChecked() ?? false })
        if cellsChecked.count != 1 {
            let cellToUncheck = cellsChecked.first(where: { c in
                !(c.selectableButton?.isEqual(selectableButton))!
            })
            cellToUncheck?.selectableButton?.changeState()
        }
    }
}
