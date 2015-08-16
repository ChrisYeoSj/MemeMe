//
//  ViewController.swift
//  MemeMe
//
//  Created by Christopher on 17/8/15.
//  Copyright (c) 2015 Chris. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var pickedImage: UIImageView!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var albumButton: UIBarButtonItem!
    
    var randomFonts: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        randomFonts = ["HelveticaNeue-CondensedBlack", "Times New Roman", "Arial-BoldMT", "Avenir-Black", "ChalkboardSE-Bold", "Verdana-Bold", "GeezaPro-Bold", "AmericanTypewriter-CondensedBold", "Copperplate-Bold", "Courier-Bold"]
        
        shareButton.enabled = pickedImage.image != nil //if no image is picked, sharebutton will be disabled.
        
        setTextAttributes("HelveticaNeue-CondensedBlack")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotification()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        unsubscribeToKeyboardNotification()
    }
    
    func setTextAttributes(fontName: String){
        
        let memeTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSStrokeColorAttributeName : UIColor.blackColor(), NSFontAttributeName : UIFont(name: fontName, size: 26)!, NSStrokeWidthAttributeName : -7.0, ]
        
        topTextField.text = "TOP"
        topTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        
        bottomTextField.text = "BOTTOM"
        bottomTextField.delegate = self
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = NSTextAlignment.Center
        
    }
    
    func textFieldDidBeginEditing(textField: UITextField){
        
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.isFirstResponder() {
            textField.resignFirstResponder()
        }
        return false
    }
    
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
            
            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
                pickedImage.image = image
                shareButton.enabled = pickedImage.image != nil
            }
            
            dismissViewControllerAnimated(true, completion: nil)
            
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func subscribeToKeyboardNotification(){
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeToKeyboardNotification(){
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }
    
    func keyboardWillShow(notification: NSNotification){
        
        if bottomTextField.isFirstResponder(){
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.view.frame.origin.y -= self.getKeyboardHeight(notification)
            })
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        
        if bottomTextField.resignFirstResponder(){
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.view.frame.origin.y += self.getKeyboardHeight(notification)
            })
        }
    }
    
    func generateMemeImage() -> UIImage{
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.toolbar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memeImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.toolbar.hidden = false
        
        return memeImage
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.CGRectValue().height
        
    }
    
    @IBAction func pickAnImage(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        pickerController.allowsEditing = true
        presentViewController(pickerController, animated: true, completion: nil)
        
    }
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareMemeButton(sender: AnyObject) {
        
        let activityController = UIActivityViewController(activityItems: [generateMemeImage()], applicationActivities: nil)
        
        activityController.completionWithItemsHandler = {
            (activity, success, items, error) in
            println("Activity: \(activity) Success: \(success) Items: \(items) Error: \(error)")
            if success == true{
                
                let successMessage = UIAlertView(title: "Success", message: nil, delegate: self, cancelButtonTitle: "OK")
                successMessage.show()
            }
        }
        self.navigationController!.presentViewController(activityController, animated: true, completion: nil)
        
    }
    
    func saveMeme(){
        
        var meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, memeImage: generateMemeImage(), originalImage: pickedImage.image!)
        
    }
    
    @IBAction func randomFontButton(sender: UIButton) {
        
        var randomNumber : Int = Int(arc4random() % 10)
        setTextAttributes(randomFonts[randomNumber])
    }
    
}