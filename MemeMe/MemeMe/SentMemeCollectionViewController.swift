//
//  SentMemeCollectionViewController.swift
//  MemeMe
//
//  Created by Christopher on 20/8/15.
//  Copyright (c) 2015 Chris. All rights reserved.
//

import UIKit

let reuseIdentifier = "sentMemeCell"

class SentMemeCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var meme : [Meme]!
    @IBOutlet var sentMemeCollection: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        meme = appDelegate.memesArray
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        meme = appDelegate.memesArray
        sentMemeCollection.reloadData()
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return meme.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SentMemeCollectionViewCell
    
        cell.sentMemeImageView.image = meme[indexPath.item].memedImage
    
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC : MemeDetailViewController = storyboard.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailVC.meme = meme[indexPath.item]
        detailVC.arrayIndex = indexPath.item
        
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    @IBAction func segueToAddMeme(sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var createMemeVC = storyboard.instantiateViewControllerWithIdentifier("createMemeViewController") as! MemeViewController
        let navController = UINavigationController(rootViewController: createMemeVC)
        presentViewController(navController, animated: true, completion: nil)
        
    }

}
