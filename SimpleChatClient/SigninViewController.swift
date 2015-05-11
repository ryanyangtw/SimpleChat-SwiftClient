//
//  SigninViewController.swift
//  FSC
//
//  Created by Ryan on 2015/4/27.
//  Copyright (c) 2015年 Ryan. All rights reserved.
//

import UIKit
import Alamofire
import Locksmith
import Parse
import Bolts


class SigninViewController: UIViewController {

  
  @IBOutlet weak var accountTextField: SigninTextField!
  @IBOutlet weak var passwordTextField: SigninTextField!

  // Model
  //var userModel: UserModel?
  
  
  
  
  private struct Storyboard {
    static let SuccessedSigninSegue = "SuccessedSignin"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //let error = Locksmith.deleteDataForUserAccount("Device", inService: "KeyChainService")

    let gestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard"))
    view.addGestureRecognizer(gestureRecognizer)
    

  }
  
  
  // Should put authentication in viewDidAppear to avoid "Warning: Attempt to present YourViewController on ViewController whose view is not in the window hierarchy!"
  override func viewDidAppear(animated: Bool) {
    // check if user is signed in
    let defaults = NSUserDefaults.standardUserDefaults()
    
    if defaults.objectForKey("userLoggedIn") != nil {
      println(" != nil")
      self.performSegueWithIdentifier(Storyboard.SuccessedSigninSegue, sender: nil)
      
    } else {
      
    }
  
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  // MARK: - IBAction
  
  func dismissKeyboard() {
    view.endEditing(true)
  }
    

  @IBAction func signIn() {
    
    println("pressed sign in button")
    if inputIsValid() {
      
      //let uuid = getDeviseUUID()
      let user = UserModel()
      
      Alamofire.request(SimpleChat.Router.Signin(self.accountTextField.text, self.passwordTextField.text)).validate().responseObject() {
        (request, response, user: UserModel?, error) in
        
        if error == nil && user != nil{
          // Write flag into UserDefault
          self.updateUserLoggedInFlag()
          self.setUserDataInUserDefault(user!)
          self.setupParse(user!)

          
          let hudView = HudView.hudInView(self.view, animated: true)
          hudView.text = "Success"
          
          afterDelay(0.6) {
            self.performSegueWithIdentifier(Storyboard.SuccessedSigninSegue, sender: nil)
            //self.dismissViewControllerAnimated(true, completion: nil)
          }
          
        } else {
          self.displayAlertMessage("錯誤", alertDescription: "帳號密碼輸入錯誤")
        }
      }
    } else {
      self.displayAlertMessage("錯誤", alertDescription: "欄位未填寫完整")
    }

  }
  
  
  

  
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    println("In prepareForSegue")
    if segue.identifier == Storyboard.SuccessedSigninSegue {
      println("go into next  controller")
    }
  }
  
  // MARK: - Helper method
  
  func inputIsValid() -> Bool {
    
    return count(accountTextField.text) > 0 && count(passwordTextField.text) > 0 ? true : false
  
  }
  
  
  func displayAlertMessage(alertTitle:String, alertDescription:String) -> Void {
    // hide activityIndicator view and display alert message
    //self.activityIndicatorView.hidden = true
    let errorAlert = UIAlertView(title:alertTitle as String, message:alertDescription as String, delegate:nil, cancelButtonTitle:"OK")
    errorAlert.show()
  }
  
  func updateUserLoggedInFlag() {
    // Update the NSUserDefaults flag
    let defaults = NSUserDefaults.standardUserDefaults()
    defaults.setObject("loggedIn", forKey: "userLoggedIn")
    defaults.synchronize()
    
  }
  
  func setUserDataInUserDefault(user: UserModel) {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let userHash: [String: AnyObject] = ["id": user.id!, "name": user.name!, "avatar": user.avatarUrl!, "email": user.email!]
    
    defaults.setObject(userHash, forKey: "userHash")
    
    /*
    defaults.setInteger(user.id!, forKey: "userId")
    defaults.setObject(user.name!, forKey: "userName")
    defaults.setObject(user.name!, forKey: "userName")
    defaults.setObject(user.avatarUrl!, forKey: "userAvatarUrl")
    */
    defaults.synchronize()
  }
  
  func setupParse(user: UserModel) {
//    let installation = PFInstallation.currentInstallation()
//    installation.installationId = "\(user.id!)"
//    //installation.setDeviceTokenFromData(deviceToken)
//    installation.saveInBackground()
    
    println("setup Parse")
    let installation = PFInstallation.currentInstallation()
    installation.setObject(user.id!, forKey: "userId")
    installation.saveInBackground()
  }
  
  



}
