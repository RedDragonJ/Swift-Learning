//
//  View+AlertView.swift
//  LearnSwift
//
//  Created by James Layton on 2/26/23.
//

import SwiftUI

extension View {
    func alert(with showAlert: Binding<Bool>, alertDetails: Binding<AlertDetail?>) -> some View {
        modifier(AlertView(showAlert: showAlert, alertDetails: alertDetails))
    }
}

struct AlertView: ViewModifier {
    @Binding var showAlert: Bool
    @Binding var alertDetails: AlertDetail?
    
    func body(content: Content) -> some View {
        content
            .alert(Text(alertDetails?.title ?? ""), isPresented: $showAlert, presenting: alertDetails) { detail in
                makeAlertButtons(buttons: detail.buttons)
            } message: { detail in
                Text("\(detail.message)")
            }
    }
    
    private func makeAlertButtons(buttons: [AlertDetail.Button]) -> some View {
        ForEach(buttons, id: \.title) { button in
            Button("\(button.title)") {
                button.action()
            }
        }
    }
}
