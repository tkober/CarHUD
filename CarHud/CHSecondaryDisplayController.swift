//
//  CHSecondaryDisplayController.swift
//  CarHud
//
//  Created by Thorsten Kober on 26.07.15.
//  Copyright (c) 2015 Thorsten Kober. All rights reserved.
//

import UIKit


class CHSecondaryDisplayController: UIPageViewController, UIPageViewControllerDataSource {

    
    // MARK: - Internal
    // MARK: | Views Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        let startPage = [self.displays.first!]
        self.setViewControllers(startPage, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
    }
    
    
    
    // MARK: - Private
    // MARK: | Displays
    
    
    
    lazy var displays: [UIViewController] = [
        self.powerDisplay,
        self.fuelDisplay,
        self.engineDisplay
    ]
    
    
    lazy var powerDisplay: CHPowerDisplayController = CHPowerDisplayController.display() as! CHPowerDisplayController
    lazy var fuelDisplay: CHFuelDisplayController = CHFuelDisplayController.display() as! CHFuelDisplayController
    lazy var engineDisplay: CHEngineDisplayController = CHEngineDisplayController.display() as! CHEngineDisplayController
    
    
    
    // MARK: - UIPageViewControllerDataSource

    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        let index = (self.displays as NSArray).indexOfObject(viewController)
        return index < self.displays.count - 1 ? self.displays[index+1] as UIViewController : nil
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        let index = (self.displays as NSArray).indexOfObject(viewController)
        return index > 0 ? self.displays[index-1] as UIViewController : nil
    }
    
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.displays.count
    }
    
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        if let controller: AnyObject = pageViewController.viewControllers.first {
            return (self.displays as NSArray).indexOfObject(controller)
        }
        return 0
    }

}
