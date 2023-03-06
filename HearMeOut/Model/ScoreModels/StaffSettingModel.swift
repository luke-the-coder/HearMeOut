//
//  StaffSettingModel.swift
//  MC3
//
//  Created by Nicola Rigoni on 03/03/23.
//

import Foundation

struct StaffSettingModel: Identifiable {
    
    var name: String
    var isActive: Bool = true
    
    var id: String {
        self.name
    }
    
}
