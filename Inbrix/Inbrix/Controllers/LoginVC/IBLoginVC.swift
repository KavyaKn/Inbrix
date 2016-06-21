//
//  IBLoginVC.swift
//  Inbrix
//
//  Created by Kavya on 08/06/16.
//  Copyright © 2016 Kavya. All rights reserved.
//

import UIKit
import TTPLLibrary

class IBLoginVC: IBBaseVC {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeView()
    }
    
    func initializeView() {
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "Screen")
        self.view.insertSubview(backgroundImage, atIndex: 0)
        self.navigationController?.navigationBarHidden = true
        self.loginButton.configureButton()
        self.textFieldMethod()
    }
    
    func textFieldMethod() {
        self.usernameTextField.configureUserNameTextField()
        self.passwordTextField.configurePasswordTextField()
        
        self.usernameTextField.text = "abcd@gng.com";
        self.passwordTextField.text = "123456";
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonClicked(sender: AnyObject) {
        self.endViewEditing()
        if self.validateUserDetails(){
            print("user details validated")
            self.showHomeToUser()
        }
    }
    
    func validateUserDetails() -> Bool {
        
        var sucess: Bool = true
        let userName: String = self.usernameTextField.text!
        let isValidEmail: Bool = userName.isValidEmail()
        if self.usernameTextField.text == kGENERAL_Empty_string || self.passwordTextField.text == kGENERAL_Empty_string {
            // Username and password is empty..
            self.showAlertWithTitle(kGENERAL_Empty_string, message: kLogin_FieldShouldNotBeEmpty_alertMessage)
            sucess = false
            return sucess
        }
        else if !isValidEmail {
            // Show invalid email alert..
            self.showAlertWithTitle(kGENERAL_Empty_string, message: kLogin_PleaseEnterValidEmailId_alertMessage)
            sucess = false
            return sucess
        }
        sucess = (isValidEmail)
        return sucess
    }
    
    func showHomeToUser() {
        self.createMenuView()
    }
    
    
    func createMenuView() {
        let sideMenuStoryboard = UIStoryboard(name:kIBSideManuStoryboardIdentifier, bundle: nil)
        let mainStoryboard  = UIStoryboard(name:kIBMainStoryboardIdentifier, bundle: nil)
        
        let mainViewController = mainStoryboard.instantiateViewControllerWithIdentifier(kIBPlaceListViewControllerIdentifier) as! IBPlaceListVC
        let leftViewController = sideMenuStoryboard.instantiateViewControllerWithIdentifier(kIBSideMenuViewControllerIdentifier) as! IBMenuVC
        leftViewController.view.hidden = true
        
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        let slideMenuController = IBMenuDrawer(mainViewController:nvc, leftMenuViewController: leftViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        self.navigationController?.pushViewController(slideMenuController, animated: true)


    }

}
