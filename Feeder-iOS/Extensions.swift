//
//  Extensions.swift
//  Feeder-iOS
//
//  Created by Joe Diragi on 8/26/22.
//

import SwiftUI

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

extension Bool {
     static var iOS16: Bool {
         guard #available(iOS 16, *) else {
             // It's iOS 16 so return true.
             return false
         }
         // It isn't, return false
         return true
     }
 }
