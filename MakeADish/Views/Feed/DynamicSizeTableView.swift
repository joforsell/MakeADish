//
//  DynamicSizeTableView.swift
//  MakeADish
//
//  Created by Johan Forsell on 2022-05-06.
//

import UIKit

class DynamicSizeTableView: UITableView {

    override public func layoutSubviews() {
        super.layoutSubviews()
        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }

    override public var intrinsicContentSize: CGSize {
        return contentSize
    }
}
