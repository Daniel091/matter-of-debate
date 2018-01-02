//
//  Statistic.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 02.01.18.
//  Copyright © 2018 Gruppe7. All rights reserved.
//

import Foundation

struct Statistic {
    var id : String
    var contra: Int
    var pro: Int
    var startOpinion: String
    var currentOpinion: String
    var opinions = [[String]]()
    
    init(id : String, contra : Int, pro : Int, startOpinion: String, currentOpinion:String ,opinions : [[String]]) {
        self.id = id
        self.contra = contra
        self.opinions = opinions
        self.pro = pro
        self.currentOpinion = currentOpinion
        self.startOpinion = startOpinion
    }
    
    public func getContra() -> Int {
        return contra
    }
    
    public func getPro() -> Int {
        return pro
    }
    
    public func getStartOpinion() -> String{
        return startOpinion
    }
    
    public func getCurrentOpinion() -> String{
        return currentOpinion
    }
}
