//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Christopher on 20/8/15.
//  Copyright (c) 2015 Chris. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var meme : Meme!
    var arrayIndex : Int!
    
    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "editMeme")
        let deleteButton = UIBarButtonItem(title: "Delete", style: UIBarButtonItemStyle.Plain, target: self, action: "deleteMeme")
        let arrayButtons = [editButton, deleteButton] as [AnyObject]
        navigationItem.rightBarButtonItems = arrayButtons
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        imageView.image = meme.memedImage
    }
    
    func editMeme(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var createMemeVC : MemeViewController = storyboard.instantiateViewControllerWithIdentifier("createMemeViewController") as! MemeViewController
        createMemeVC.image = meme.originalImage
        createMemeVC.textTop = meme.topText
        createMemeVC.textBottom = meme.bottomText
        
        let navController = UINavigationController(rootViewController: createMemeVC)
        presentViewController(navController, animated: true, completion: nil)
        
    }
    
    func deleteMeme(){
        var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.memesArray.removeAtIndex(arrayIndex)
        navigationController?.popToRootViewControllerAnimated(true)
        
    }


}
