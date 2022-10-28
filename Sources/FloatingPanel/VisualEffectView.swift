//
//  VisualEffectView.swift
//  FloatingPanel
//
//  Created by Shay Bergmann on 2022-07-24.
//

import SwiftUI
 
/// Bridge AppKit's NSVisualEffectView into SwiftUI
public struct VisualEffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode
    var state: NSVisualEffectView.State
    var isEmphasized: Bool
    
    public init(material: NSVisualEffectView.Material = .sidebar,
                blendingMode: NSVisualEffectView.BlendingMode = .behindWindow,
                state: NSVisualEffectView.State = .active,
                isEmphasized: Bool = true) {
        self.material = material
        self.blendingMode = blendingMode
        self.state = state
        self.isEmphasized = isEmphasized
    }
    
    public func makeNSView(context: Context) -> NSVisualEffectView {
        context.coordinator.visualEffectView
    }
 
    public func updateNSView(_ view: NSVisualEffectView, context: Context) {
        context.coordinator.update(
            material: material,
            blendingMode: blendingMode,
            state: state,
            isEmphasized: isEmphasized
        )
    }
 
    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }
 
    public class Coordinator {
        let visualEffectView = NSVisualEffectView()
 
        func update(material: NSVisualEffectView.Material,
                    blendingMode: NSVisualEffectView.BlendingMode,
                    state: NSVisualEffectView.State,
                    isEmphasized: Bool
        ) {
            visualEffectView.material = material
            visualEffectView.blendingMode = blendingMode
            visualEffectView.state = state
            visualEffectView.isEmphasized = isEmphasized
        }
    }
  }
