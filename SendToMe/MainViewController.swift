//
//  ViewController.swift
//  SendToMe
//
//  Created by Chris Jimenez on 1/22/16.
//  Copyright © 2016 Chris Jimenez. All rights reserved.
//

import UIKit
import IBAnimatable
import SendToMeFramework
import SwiftDelayer

class MainViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var stackView: AnimatableStackView!

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var saveEmailButton: AnimatableButton!
    
    lazy var emailDataStorage:EmailDataStorage = EmailDataStorage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Shows the email info if available
        showEmailInfo()
        saveInitialSettings();
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func saveEmailClicked(sender: AnyObject) {
        
        if isValid(){
            
            //Saves the email in the data storage
            saveEmail()
            
        }else {
            
            //Shakes the stackview to show an error
            stackView.shake()

        }
    }
    
    
    private func saveInitialSettings(){
        
        log.debug("Saving initial settings")
        let keysData = KeysDataStorage();
        
        log.debug("Save mailgun api key")
        keysData.saveMailgunApiKey(Keys.mailgunApiKey)
        log.debug("Save client domain path")
        keysData.saveClientDomainKey(Keys.clientDomain)
    }
    
    /**
     Check if the form is valid
     
     - returns: form is valid
     */
    private func isValid() -> Bool{
        
        var returnValue = false
        
        if emailTextField.text!.isValidEmail()
        {
            returnValue = true
        }
        
        return returnValue
        
    }
    
    //Saves the email in the local storage
    private func saveEmail()
    {
        
        //Shows an initial save animation
        //Sets an email for the delay
        saveEmailButton.setTitle("email_saved".localized, forState: UIControlState.Normal)
        saveEmailButton.zoomIn { () -> Void in
            
           //Sets the button back to normal
            Delayer.delayOnMainQueue(seconds:2.0){
            
                self.saveEmailButton.squeezeFadeInRight()
                self.saveEmailButton.setTitle("save_email_title".localized, forState: UIControlState.Normal)
            
           }
        }
        
        if let emailText = emailTextField.text{
            
            emailDataStorage.saveEmail(emailText)
        }
        //Shows the saved email info
        showEmailInfo()
    }
    
    //Shows the email info in the placeholder if is available
    private func showEmailInfo()
    {
        self.emailTextField.text = ""
        if emailDataStorage.hasEmailSaved
        {
            emailTextField.placeholder = String(format: "save_email_text".localized, arguments: [emailDataStorage.getEmail()])
        }
        
    }
    
    //Hide the keyboard when done
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

