//
//  CHSecondaryDisplayViewController.swift
//  CarHud
//
//  Created by Thorsten Kober on 11/09/16.
//  Copyright © 2016 Thorsten Kober. All rights reserved.
//

import UIKit

class CHSecondaryDisplayViewController: UIViewController {
    
    var selectableElements: [CHSelectableView] = []
    
    var currentSelection: Int = -1
    
    var engagedElement: CHSelectableView?
    
    func selectedElement() -> CHSelectableView? {
        return currentSelection != -1 ? self.selectableElements[currentSelection] : nil
    }

    func becameActive() {
        if let selected = self.selectedElement() {
            if self.engagedElement == nil {
                selected.select()
            }
        }
    }
    
    func becameInactive() {
        if let selected = self.selectedElement() {
            if shouldDeselectOnBecommingInactive() {
                selected.deselect()
            }
        }
    }
    
    func selectNextElement() {
        if engagedElement == nil {
            if let selected = self.selectedElement() {
                selected.deselect()
                currentSelection = currentSelection < self.selectableElements.count-1 ? currentSelection + 1 : 0
                self.selectedElement()!.select()
            }
        }
    }
    
    func selectPreviousElement() {
        if engagedElement == nil {
            if let selected = self.selectedElement() {
                selected.deselect()
                currentSelection = currentSelection > 0 ? currentSelection - 1 : self.selectableElements.count - 1
                self.selectedElement()!.select()
            }
        }
    }
    
    func engageSelectedElement() {
        if !shouldEngage() {
            return
        }
        if let selected = self.selectedElement() {
            if engagedElement != nil {
                engagedElement = nil
                selected.engage()
                selected.select()
            } else {
                selected.deselect()
                selected.engage()
                engagedElement = selected
            }
            
        }
    }
    
    func shouldDeselectOnBecommingInactive() -> Bool {
        return true
    }
    
    func shouldEngage() -> Bool {
        return true
    }
    
}
