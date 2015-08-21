//
//  MemeViewController.swift
//  MemeMe
//
//  Created by Christopher on 17/8/15.
//  Copyright (c) 2015 Chris. All rights reserved.
//

import UIKit
import AVFoundation

class MemeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet var pickedImage: UIImageView!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var albumButton: UIBarButtonItem!
    @IBOutlet var randomFontButton: UIButton!
    
    
    var textTop : String!
    var textBottom : String!
    var image : UIImage!
    var randomFonts: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        randomFonts = ["HelveticaNeue-CondensedBlack", "Times New Roman", "Arial-BoldMT", "Avenir-Black", "ChalkboardSE-Bold", "Verdana-Bold", "GeezaPro-Bold", "AmericanTypewriter-CondensedBold", "Copperplate-Bold", "Courier-Bold"]
        
        shareButton.enabled = pickedImage.image != nil //if no image is picked, sharebutton will be disabled.
        
        
        if image != nil{
            pickedImage.image = image
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if textTop == nil && textBottom == nil{
            
            setTextAttributesInitial("HelveticaNeue-CondensedBlack")
            
        } else {
            
            setTextAttributes("HelveticaNeue-CondensedBlack", topText: textTop, bottomText: textBottom)
            
        }

        
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        subscribeToKeyboardNotification()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        unsubscribeToKeyboardNotification()
    }
    
    func setTextAttributesInitial(fontName: String){
        
        let memeTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSStrokeColorAttributeName : UIColor.blackColor(), NSFontAttributeName : UIFont(name: fontName, size: 26)!, NSStrokeWidthAttributeName : -7.0, ]
        
        textTop = "TOP"
        textBottom = "BOTTOM"
        
        topTextField.text = textTop
        topTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        
        bottomTextField.text = textBottom
        bottomTextField.delegate = self
        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.textAlignment = NSTextAlignment.Center
        
    }
    
    func setTextAttributes(fontName : String, topText : String, bottomText : String){
        
        let memeTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSStrokeColorAttributeName : UIColor.blackColor(), NSFontAttributeName : UIFont(name: fontName, size: 26)!, NSStrokeWidthAttributeName : -7.0, ]
        
        topTextField.text = topText
        topTextField.delegate = self
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = NSTextAlignment.Center
        
        bottomTextField.text = bottomText
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
                self.view.frame.origin.y = 0
            })
        }
    }
    
    func generateMemeImage() -> UIImage{
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        toolbar.hidden = true
        randomFontButton.hidden = true
        
        UIGraphicsBeginImageContext(self.pickedImage.frame.size)
        view.drawViewHierarchyInRect(self.pickedImage.frame, afterScreenUpdates: true)
        let memeImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        toolbar.hidden = false
        randomFontButton.hidden = false
        
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
        pickerController.allowsEditing = false
        presentViewController(pickerController, animated: true, completion: nil)
        
    }
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(pickerController, animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func shareMemeButton(sender: AnyObject) {
        
        let activityController = UIActivityViewController(activityItems: [generateMemeImage()], applicationActivities: nil)
        

        
        activityController.completionWithItemsHandler = {
            (activity, success, items, error) in
            if success == true{
                self.saveMeme()
                let successMessage = UIAlertView(title: "Success", message: nil, delegate: self, cancelButtonTitle: "OK")
                successMessage.show()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        navigationController!.presentViewController(activityController, animated: true, completion: nil)
        
    }
    
    func saveMeme(){
        
        var meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, memeImage: generateMemeImage(), originalImage: pickedImage.image!)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memesArray.append(meme)
        
    }
    
    @IBAction func randomFontButton(sender: UIButton) {
        
        var randomNumber : Int = Int(arc4random() % 10)
        setTextAttributesInitial(randomFonts[randomNumber])
    }
    
}
