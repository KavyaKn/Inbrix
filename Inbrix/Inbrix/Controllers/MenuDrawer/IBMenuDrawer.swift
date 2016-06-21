//
//  IBMenuDrawer.swift
//  Inbrix
//
//  Created by Kavya on 09/06/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class IBMenuDrawer: SlideMenuController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SlideMenuOptions.leftViewWidth = self.view.frame.width - 50
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.leftViewController?.view.hidden = false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
