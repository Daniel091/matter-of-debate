//
//  SwipeView.swift
//  matterOfdebate
//
//  Created by Gregor Anzer on 02.01.18.
//  Copyright © 2018 Gruppe7. All rights reserved.
//

import Foundation

extension UIView {
    
    func copyView<T: UIView>() -> T {
        return NSKeyedUnarchiver.unarchiveObject(with: NSKeyedArchiver.archivedData(withRootObject: self)) as! T
    }
    
}
