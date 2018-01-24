//
//  Proposal.swift
//  matterOfdebate
//
//  Created by Gregor Anzer on 24.01.18.
//  Copyright © 2018 Gruppe7. All rights reserved.
//

import Foundation

struct Proposal {
    
    let title: String
    let description: String
    let id: String
    
    init(t: String, d: String, i: String) {
        self.title = t
        self.description = d
        self.id = i
    }
}
