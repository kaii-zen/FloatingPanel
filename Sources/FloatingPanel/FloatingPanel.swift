//
//  FloatingPanel.swift
//  FloatingPanel
//
//  Created by Shay Bergmann on 2022-07-24.
//

import SwiftUI
 
/// An NSPanel subclass that implements floating panel traits.
public class FloatingPanel: NSPanel {
    
    public init<Content: View>(@ViewBuilder view: () -> Content,
//                contentRect: NSRect = CGRect(x: 0, y: 0, width: 624, height: 512),
                               contentRect: NSRect = .zero,
                backing: NSWindow.BackingStoreType = .buffered,
                defer flag: Bool = false) {
     
        /// Init the window as usual
        super.init(contentRect: contentRect,
                   styleMask: [.nonactivatingPanel, .titled, .resizable, .closable, .fullSizeContentView],
                   backing: backing,
                   defer: flag)
        
        /// Allow the panel to be on top of other windows
        isFloatingPanel = true
        level = .floating
        
        /// Allow the pannel to be overlaid in a fullscreen space
        collectionBehavior.insert(.fullScreenAuxiliary)
        
        /// Don't show a window title, even if it's set
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        
        /// Since there is no title bar make the window moveable by dragging on the background
        isMovableByWindowBackground = true
        
        /// Hide when unfocused
        hidesOnDeactivate = true
        
        /// Hide all traffic light buttons
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
        
        /// Sets animations accordingly
        animationBehavior = .utilityWindow
        
        /// Set the content view.
        /// The safe area is ignored because the title bar still interferes with the geometry
        contentView = NSHostingView(rootView: view()
            .ignoresSafeArea()
            .environment(\.floatingPanel, self))
    }
    
    /// Present the panel and make it the key window
    public func show() {
        NSApp.activate(ignoringOtherApps: true)
        center()
        makeKeyAndOrderFront(nil)
    }
    
    public func hide() {
        orderOut(nil)
    }
    
    public func toggle() {
        if isVisible {
            hide()
        } else {
            show()
        }
    }
     
    /// `canBecomeKey` and `canBecomeMain` are both required so that text inputs inside the panel can receive focus
    override public var canBecomeKey: Bool {
        return true
    }
     
    override public var canBecomeMain: Bool {
        return true
    }
}

private struct FloatingPanelKey: EnvironmentKey {
    static let defaultValue: FloatingPanel? = nil
}
 
extension EnvironmentValues {
  public var floatingPanel: FloatingPanel? {
    get { self[FloatingPanelKey.self] }
    set { self[FloatingPanelKey.self] = newValue }
  }
}
