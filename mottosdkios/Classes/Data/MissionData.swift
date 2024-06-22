//
//  MissionData.swift
//  mottoapp
//
//  Created by MHD on 2024/02/17.
//

import Foundation

struct MissionData {
    var ticket: Int
    var pcode: String
    var store: String
    var adrole: Int
    var jmethod: Int
    
    init(ticket: Int, pcode: String, store: String, adrole: Int, jmethod: Int) {
        self.ticket = ticket
        self.pcode = pcode
        self.store = store
        self.adrole = adrole
        self.jmethod = jmethod
    }
}
