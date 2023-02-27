//
//  AlertDetail.swift
//  LearnSwift
//
//  Created by James Layton on 2/26/23.
//

import SwiftUI

struct AlertDetail: Identifiable {
    let id: UUID
    let title: String
    let message: String
    let buttons: [Button]
    
    init(title: String, message: String, buttons: [Button] = []) {
        id = UUID()
        self.title = title
        self.message = message
        self.buttons = !buttons.isEmpty ? buttons : [Button(title: "Ok", role: .cancel, action: {
            // Do nothing
        })]
    }
    
    struct Button {
        let title: String
        let role: ButtonRole
        let action: () -> Void
    }
}
