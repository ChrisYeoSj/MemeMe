//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Christopher on 20/8/15.
//  Copyright (c) 2015 Chris. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    var memedImage : UIImage!
    
    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "editMeme")
        self.navigationItem.rightBarButtonItem = editButton
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        imageView.image = memedImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func editMeme(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var createMemeVC : MemeViewController = storyboard.instantiateViewControllerWithIdentifier("createMemeViewController") as! MemeViewController
        createMemeVC.image = memedImage
        
        let navController = UINavigationController(rootViewController: createMemeVC)
        self.presentViewController(navController, animated: true, completion: nil)
        
    }


}
