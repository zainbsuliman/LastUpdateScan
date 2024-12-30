//
//  ScanEntity.swift
//  ScanTest]
//
//  Created by Zainab Alatwi  on 14/06/1446 AH.
//

import SwiftData
import Foundation

@Model
class ScanEntity {
    @Attribute(.unique) var id: UUID
    var content: String
    var date: Date
    
    init(content: String, date: Date = Date()) {
        self.id = UUID()
        self.content = content
        self.date = date
    }
}
