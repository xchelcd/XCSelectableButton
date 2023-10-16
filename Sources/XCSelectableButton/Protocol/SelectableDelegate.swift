//
//  SelectableDelegate.swift
//  Switching Button
//
//  Created by Xchel Carranza on 29/12/22.
//

@available(iOS 15.0, *)
public protocol SelectableDelegate: AnyObject {
    associatedtype T
    func onSelected(data: T, selectableButton: XCSelectableButton)
}
