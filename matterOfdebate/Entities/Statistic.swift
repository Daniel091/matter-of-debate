//
//  Statistic.swift
//  matterOfdebate
//
//  Created by Daniel Eichinger on 02.01.18.
//  Copyright © 2018 Gruppe7. All rights reserved.
//

import Foundation

class Statistic {
    
    // TODO: private
    
    var id : String
    var contra: Int
    var pro: Int
    var startOpinion: String?
    var currentOpinion: String?
    
    init(id: String, contra : Int, pro : Int, startOpinion: String?, currentOpinion:String?) {
        self.id = id
        self.contra = contra
        self.pro = pro
        self.currentOpinion = currentOpinion
        self.startOpinion = startOpinion
    }
    
    public func getID() -> String {
        return id
    }
    
    public func getContra() -> Int {
        return contra
    }
    
    public func getPro() -> Int {
        return pro
    }
    
    public func getStartOpinion() -> String?{
        return startOpinion
    }
    
    public func getCurrentOpinion() -> String?{
        return currentOpinion
    }
    
    public func setContra(_ contra: Int) {
        self.contra = contra
    }
    
    public func setPro(_ pro: Int) {
        self.pro = pro
    }
    
    public func setCurrentOpinion(_ currentOpinion: String) {
        self.currentOpinion = currentOpinion
    }
    
    public func votePro() -> Bool{
        if self.startOpinion != nil {
            if(self.currentOpinion == "pro") {
                return false
            }
            pro = pro + 1
            contra = contra - 1
            currentOpinion = "pro"
        } else {
            pro = pro + 1
            currentOpinion = "pro"
            startOpinion = "pro"
        }
        return true
    }
    
    public func voteContra() -> Bool{
        if self.startOpinion != nil {
            if(self.currentOpinion == "contra") {
                return false
            }
            contra = contra + 1
            pro = pro - 1
            currentOpinion = "contra"
        } else {
            contra = contra + 1
            currentOpinion = "contra"
            startOpinion = "contra"
        }
        return true
    }
}
