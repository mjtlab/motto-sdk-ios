//
//  UIPickerView+.swift
//  mottoapp
//
//  Created by MHD on 2024/05/17.
//

import UIKit

extension UIPickerView {
    func slowSelectRow(_ row: Int, inComponent component: Int = 0) {
        let currentSelectedRow = selectedRow(inComponent: component)

        guard currentSelectedRow != row else {
            return
        }

        let diff = (currentSelectedRow > row) ? -1 : 1
        let newRow = currentSelectedRow + diff
        selectRow(newRow, inComponent: component, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.slowSelectRow(row, inComponent: component)
        }
    }
}
