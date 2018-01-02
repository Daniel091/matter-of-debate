//
//  Statistic.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 02.01.18.
//  Copyright © 2018 Gruppe7. All rights reserved.
//

import Foundation

struct Statistic {
    var contra: Int
    var pro: Int
    var opinions = [[String]]()
    
    init(contra : Int, pro : Int, opinions : [[String]]) {
        self.contra = contra
        self.opinions = opinions
        self.pro = pro
    }
    
}
