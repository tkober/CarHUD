//
//  CHSecondaryDisplaysController.swift
//  CarHud
//
//  Created by Thorsten Kober on 26.07.15.
//  Copyright (c) 2015 Thorsten Kober. All rights reserved.
//

import UIKit


class CHSecondaryDisplaysController: UIPageViewController, UIPageViewControllerDataSource, CHCommandReceiver {

    var currentPage: CHSecondaryDisplayViewController?
    
    var selectedPage: CHSecondaryDisplayViewController?
    
    // MARK: - Internal
    // MARK: | Views Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.currentPage = self.displays.first as? CHSecondaryDisplayViewController
        self.setViewControllers([currentPage!], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        CHCarBridgeConnector.sharedInstance.commandReceiver = self
    }
    
    
    // MARK: - Private
    // MARK: | Displays
    
    lazy var displays: [UIViewController] = [
        self.powerDisplay,
        self.engineDisplay
    ]
    
    lazy var powerDisplay: CHPowerDisplayController = CHPowerDisplayController.display() as! CHPowerDisplayController
    lazy var engineDisplay: CHEngineDisplayController = CHEngineDisplayController.display() as! CHEngineDisplayController
    
    
    // MARK: - UIPageViewControllerDataSource

    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        if self.selectedPage != nil {
            return nil
        }
        let index = (self.displays as NSArray).indexOfObject(viewController)
        return index < self.displays.count - 1 ? self.displays[index+1] as UIViewController : nil
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        if self.selectedPage != nil {
            return nil
        }
        let index = (self.displays as NSArray).indexOfObject(viewController)
        return index > 0 ? self.displays[index-1] as UIViewController : nil
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.displays.count
    }
    
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        if let controller: AnyObject = pageViewController.viewControllers!.first {
            return (self.displays as NSArray).indexOfObject(controller)
        }
        return 0
    }
    
    
    // MARK: - CHCommandReceiver
    
    func right() {
        if let activePage = self.selectedPage {
            activePage.selectNextElement()
        } else {
            let nextPage = self.pageViewController(self, viewControllerAfterViewController: self.currentPage!) as? CHSecondaryDisplayViewController
            if let newPage = nextPage {
                self.setViewControllers([newPage], direction: UIPageViewControllerNavigationDirection.Forward,      animated: true) { (finished: Bool) in
                    self.currentPage = newPage
                }
            }
        }
    }
    
    func left() {
        if let activePage = self.selectedPage {
            activePage.selectPreviousElement()
        } else {
            let nextPage = self.pageViewController(self, viewControllerBeforeViewController: self.currentPage!) as? CHSecondaryDisplayViewController
            if let newPage = nextPage {
                self.setViewControllers([newPage], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true) { (finished: Bool) in
                    self.currentPage = newPage
                }
            }
        }
    }
    
    func press() {
        if let activePage = self.selectedPage {
            activePage.engageSelectedElement()
        } else {
            activateDisplay(self.currentPage!)
        }
    }
    
    func longPress() {
        deactivateDisplay();
    }
    
    
    // MARK: | Displays
    
    func activateDisplay(display: CHSecondaryDisplayViewController) {
        self.selectedPage = display
        display.becameActive()
        for view in self.view.subviews {
            if view is UIPageControl {
                (view as! UIPageControl).alpha = 0
            }
        }
    }
    
    func deactivateDisplay() {
        if let activePage = self.selectedPage {
            activePage.becameInactive()
        }
        self.selectedPage = nil
        for view in self.view.subviews {
            if view is UIPageControl {
                (view as! UIPageControl).alpha = 1
            }
        }
    }

}
