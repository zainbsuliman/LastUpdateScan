//
//  Scandata.swift
//  ScanTest]
//
//  Created by Zainab Alatwi  on 13/06/1446 AH.
//

import Foundation

struct ScanData: Identifiable {
    var id = UUID()
    
    let content: String
    init(content: String) {
        self.content = content
    }
}
