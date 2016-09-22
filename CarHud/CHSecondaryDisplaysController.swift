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
        self.currentPage = self.displays[1] as? CHSecondaryDisplayViewController
        self.setViewControllers([currentPage!], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        CHCarBridgeConnector.sharedInstance.commandReceiver = self
    }
    
    
    // MARK: - Private
    // MARK: | Displays
    
    lazy var displays: [UIViewController] = [
        self.speedLimitDisplay,
        self.powerDisplay,
        self.engineDisplay
    ]
    
    lazy var speedLimitDisplay: CHSpeedLimitDisplayController = CHSpeedLimitDisplayController.display() as! CHSpeedLimitDisplayController
    lazy var powerDisplay: CHPowerDisplayController = CHPowerDisplayController.display() as! CHPowerDisplayController
    lazy var engineDisplay: CHEngineDisplayController = CHEngineDisplayController.display() as! CHEngineDisplayController
    
    
    // MARK: - UIPageViewControllerDataSource

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if self.selectedPage != nil {
            return nil
        }
        let index = (self.displays as NSArray).index(of: viewController)
        return index < self.displays.count - 1 ? self.displays[index+1] as UIViewController : nil
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if self.selectedPage != nil {
            return nil
        }
        let index = (self.displays as NSArray).index(of: viewController)
        return index > 0 ? self.displays[index-1] as UIViewController : nil
    }
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.displays.count
    }
    
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let controller: AnyObject = pageViewController.viewControllers!.first {
            return (self.displays as NSArray).index(of: controller)
        }
        return 0
    }
    
    
    // MARK: - CHCommandReceiver
    
    func right() {
        if let activePage = self.selectedPage {
            activePage.selectNextElement()
        } else {
            let nextPage = self.pageViewController(self, viewControllerAfter: self.currentPage!) as? CHSecondaryDisplayViewController
            if let newPage = nextPage {
                self.setViewControllers([newPage], direction: UIPageViewControllerNavigationDirection.forward,      animated: true) { (finished: Bool) in
                    self.currentPage = newPage
                }
            }
        }
    }
    
    func left() {
        if let activePage = self.selectedPage {
            activePage.selectPreviousElement()
        } else {
            let nextPage = self.pageViewController(self, viewControllerBefore: self.currentPage!) as? CHSecondaryDisplayViewController
            if let newPage = nextPage {
                self.setViewControllers([newPage], direction: UIPageViewControllerNavigationDirection.reverse, animated: true) { (finished: Bool) in
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
    
    func activateDisplay(_ display: CHSecondaryDisplayViewController) {
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
