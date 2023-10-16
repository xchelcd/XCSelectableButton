//
//  SelectableButton.swift
//  Switching Button
//
//  Created by Xchel Carranza on 29/12/22.
//

import UIKit


@available(iOS 15.0, *)
@IBDesignable
public class XCSelectableButton: UIButton {
    
    let id = UUID()
    
    @IBInspectable var title: String {
        didSet {
            self.setTitle(title, for: .normal)
        }
    }
    
    @IBInspectable private var textColorSelected: UIColor = .label
    @IBInspectable private var textColorNormal: UIColor = .label.withAlphaComponent(0.9)
    
    @IBInspectable var borderColor: UIColor = .darkGray
    @IBInspectable private var borderRadius: CGFloat = CGFloat(12)
    @IBInspectable private var borderWidth: CGFloat = CGFloat(0.0)
    
    @IBInspectable private var backgroundColorSelected: UIColor = .systemBlue.withAlphaComponent(0.5)
    @IBInspectable private var backgroundColorNormal: UIColor = .systemBlue.withAlphaComponent(0.1)
    
    @IBInspectable private var iconSelected: UIImage? = nil
    @IBInspectable private var iconNormal: UIImage? = nil
    
    @IBInspectable private var paddingVertical: CGFloat = CGFloat(5)
    @IBInspectable private var paddingHorizontal: CGFloat = CGFloat(10)
    @IBInspectable private var imagePadding: CGFloat = CGFloat(4)
    
    @IBInspectable private var fontSize: CGFloat = CGFloat(15)
    
    @IBInspectable private var imageColor: UIColor = .label
    
    @IBInspectable private var typeAdapter: String = "checkbox" {
        didSet {
            if let type = SelectableType(rawValue: typeAdapter.lowercased()) {
                self.type = type
                switch type {
                case .radioButton, .checkbox:
                    defaultConfig()
                case .chip:
                    defaultChipConfig()
                    break
                case .custom:
                    break
                }
                configView()
            } else {
                fatalError("The SelectableButton has the next type: \(typeAdapter) and require '[checkbox],[radiobutton],[chip]' type")
            }
        }
    }
    
    public enum SelectableType: String {
        case radioButton = "radiobutton"
        case checkbox = "checkbox"
        case chip = "chip"
        case custom = "custom"
        
        var imageSelected: UIImage? {
            switch self {
            case .radioButton:
                return UIImage(systemName: "checkmark.circle.fill")
            case .checkbox:
                return UIImage(systemName: "checkmark.square.fill")
            case .chip:
                return nil
            case .custom:
                return nil
            }
        }
        var imageNormal: UIImage? {
            switch self {
            case .radioButton:
                return UIImage(systemName: "checkmark.circle")
            case .checkbox:
                return UIImage(systemName: "checkmark.square")
            case .chip:
                return nil
            case .custom:
                return nil
            }
        }
    }
    
    var onStateChangeListener: ((XCSelectableButton) -> Void) = { _ in }
    @IBInspectable private var currentState: Bool {
        didSet {
            if type == .radioButton && !currentState {
                return
            }
            if type == .chip || type == .custom {
                self.backgroundColor = currentState ? backgroundColorSelected : backgroundColorNormal
                self.configuration = config
            }
            onStateChangeListener(self)
        }
    }
    
    public func isChecked() -> Bool {
        currentState
    }
    
    private var type: XCSelectableButton.SelectableType = .checkbox
    
    private func configView() {
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.config = UIButton.Configuration.plain()
        self.config.contentInsets = NSDirectionalEdgeInsets(top: paddingVertical, leading: paddingHorizontal, bottom: paddingVertical, trailing: paddingHorizontal)
        self.config.imagePadding = imagePadding
        self.config.image?.withTintColor(.black)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(textColorNormal, for: .normal)
        self.setTitleColor(textColorSelected, for: .selected)
        
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = borderRadius

        if type == .custom || type == .chip {
            self.backgroundColor = currentState ? backgroundColorSelected : backgroundColorNormal
            config.baseBackgroundColor = currentState ? backgroundColorSelected : backgroundColorNormal
        } else {
            self.backgroundColor = .clear
            config.baseBackgroundColor = .clear
        }
        
        self.layer.borderColor = borderColor.cgColor
        
        self.setImage(iconNormal, for: .normal)
        self.setImage(iconSelected, for: .selected)
        
        self.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        
//        MARK: no description and padding for title and subtitle
//        self.config.subtitle = "Hi this is a subtitle and i don't know what could happen, but I will still writing to check it out\nThis is a new line"
//        self.config.titlePadding = 1.0
    
        self.isSelected = currentState
        
        self.addTarget(self, action: #selector(changeState), for: .touchUpInside)
        self.configuration = config
        
        self.tintColor = imageColor
    }
    
    init(type: XCSelectableButton.SelectableType,
         title: String,
         currentState: Bool) {
        self.type = type
        self.title = title
        self.currentState = currentState
        
        super.init(frame: .zero)
        
        switch type {
        case .radioButton, .checkbox:
            defaultConfig()
        case .chip:
            defaultChipConfig()
            break
        case .custom:
            break
        }
        configView()
    }
    
    private var testTag = ""
    
    init(forRadioButtonTitle title: String,
         currentState: Bool,
         textColorSelected: UIColor,
         textColorNormal: UIColor,
         paddingVertical: CGFloat,
         paddingHorizontal: CGFloat,
         imagePadding: CGFloat,
         fontSize: CGFloat) {
        
        self.title = title
        self.currentState = currentState
        self.type = .radioButton
        self.textColorSelected = textColorSelected
        self.textColorNormal = textColorNormal
        self.borderColor = .clear
        self.borderRadius = 0
        self.backgroundColorSelected = .clear
        self.backgroundColorNormal = .clear
        self.iconSelected = type.imageSelected
        self.iconNormal = type.imageNormal
        self.paddingVertical = paddingVertical
        self.paddingHorizontal = paddingHorizontal
        self.imagePadding = imagePadding
        self.fontSize = fontSize
        self.borderWidth = CGFloat(0.0)
        
        self.config = UIButton.Configuration.plain()
        super.init(frame: .zero)
        configView()
    }
    
    init(forCheckboxTitle title: String,
         currentState: Bool,
         textColorSelected: UIColor,
         textColorNormal: UIColor,
         paddingVertical: CGFloat,
         paddingHorizontal: CGFloat,
         imagePadding: CGFloat,
         fontSize: CGFloat) {
        self.title = title
        self.currentState = currentState
        self.type = .checkbox
        self.textColorSelected = textColorSelected
        self.textColorNormal = textColorNormal
        self.borderColor = .clear
        self.borderRadius = 0
        self.backgroundColorSelected = .clear
        self.backgroundColorNormal = .clear
        self.iconSelected = type.imageSelected
        self.iconNormal = type.imageNormal
        self.paddingVertical = paddingVertical
        self.paddingHorizontal = paddingHorizontal
        self.imagePadding = imagePadding
        self.fontSize = fontSize
        self.borderWidth = CGFloat(0.0)
        
        self.config = UIButton.Configuration.plain()
        super.init(frame: .zero)
        configView()
    }
    
    init(forChipTitle title: String,
         currentState: Bool,
         textColorSelected: UIColor,
         textColorNormal: UIColor,
         paddingVertical: CGFloat,
         paddingHorizontal: CGFloat,
         imagePadding: CGFloat,
         borderColor: UIColor,
         borderWidth: CGFloat,
         backgroundColorSelected: UIColor,
         backgroundColorNormal: UIColor,
         borderRadius: CGFloat?,
         fontSize: CGFloat) {
        self.title = title
        self.currentState = currentState
        self.type = .chip
        self.textColorSelected = textColorSelected
        self.textColorNormal = textColorNormal
        self.borderColor = borderColor
        self.borderRadius = borderRadius ?? CGFloat(12)
        self.borderWidth = borderWidth
        self.backgroundColorSelected = backgroundColorSelected
        self.backgroundColorNormal = backgroundColorNormal
        self.iconSelected = type.imageSelected
        self.iconNormal = type.imageNormal
        self.paddingVertical = paddingVertical
        self.paddingHorizontal = paddingHorizontal
        self.imagePadding = imagePadding
        self.fontSize = fontSize
        
        self.config = UIButton.Configuration.plain()
        super.init(frame: .zero)
        configView()
    }
    
    init(forCustomTitle title: String,
         type: SelectableType,
         currentState: Bool,
         textColorSelected: UIColor,
         textColorNormal: UIColor,
         borderColor: UIColor,
         borderRadius: CGFloat,
         borderWidth: CGFloat,
         imageColor: UIColor,
         backgroundColorSelected: UIColor,
         backgroundColorNormal: UIColor,
         iconSelected: UIImage?,
         iconNormal: UIImage?,
         paddingVertical: CGFloat,
         paddingHorizontal: CGFloat,
         imagePadding: CGFloat,
         fontSize: CGFloat) {
        if type != .custom {
            fatalError("The [type] require to be .custom")
        }
        self.title = title
        self.currentState = currentState
        self.type = type
        self.textColorSelected = textColorSelected
        self.textColorNormal = textColorNormal
        self.borderColor = borderColor
        self.borderRadius = borderRadius
        self.borderWidth = borderWidth
        self.backgroundColorSelected = backgroundColorSelected
        self.backgroundColorNormal = backgroundColorNormal
        self.imageColor = imageColor
        self.iconSelected = iconSelected
        self.iconNormal = iconNormal
        self.paddingVertical = paddingVertical
        self.paddingHorizontal = paddingHorizontal
        self.imagePadding = imagePadding
        self.fontSize = fontSize
        self.config = UIButton.Configuration.plain()
        super.init(frame: .zero)
        configView()
    }

    private func defaultConfig() {
        iconSelected = type.imageSelected
        iconNormal = type.imageNormal
    }
    
    private func defaultChipConfig() {
        self.borderWidth = 1.0
    }
    
    private var config: UIButton.Configuration!
    
    @objc func changeState() {
        self.currentState.toggle()
        self.isSelected = currentState
    }
    
    public func toString() -> String {
        "[buttonId: \(id)] [title: \(title)] [state: \(currentState)]"
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
        super.init(coder: coder)
    }
}

@available(iOS 15.0, *)
extension XCSelectableButton {
    
    /// For radio button deselect the previus button for stay with single selection
    /// This method is now deprecated, it stay at SelectableTableCellGroup and does it automatically
    /// - Parameters:
    ///   - table: current table
    ///   - selectableButton: new selection
    func removeSelection<D>(_ table: XCSelectableTableGroup<D>, selectableButton: XCSelectableButton) {
        let cellsChecked = table.allCells.filter({ $0.selectableButton?.isChecked() ?? false })
        if cellsChecked.count != 1 {
            let cellToUncheck = cellsChecked.first(where: { c in
                !(c.selectableButton?.isEqual(selectableButton))!
            })
            cellToUncheck?.selectableButton?.changeState()
        }
    }
}
