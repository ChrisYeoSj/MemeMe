//
//  SentMemeTableViewController.swift
//  MemeMe
//
//  Created by Christopher on 20/8/15.
//  Copyright (c) 2015 Chris. All rights reserved.
//

import UIKit

class SentMemeTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var sharedMemeTable: UITableView!
    var meme: [Meme]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Sent Memes" //todo
    }

    
    override func viewWillAppear(animated: Bool) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        meme = appDelegate.memesArray
        sharedMemeTable.reloadData()
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meme.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("sentMemeCell", forIndexPath: indexPath) as! SentMemeTableViewCell
        
        cell.memedImageView.image = meme[indexPath.row].memedImage
        let textFromMeme = "\(meme[indexPath.row].topText)...\(meme[indexPath.row].bottomText)"
        cell.memedTextLabel.text = textFromMeme
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        println(meme[indexPath.row].memedImage)
        detailVC.memedImage = meme[indexPath.row].memedImage
        
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    @IBAction func segueToAddMeme(sender: UIBarButtonItem) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var createMemeVC = storyboard.instantiateViewControllerWithIdentifier("createMemeViewController") as! MemeViewController
        let navController = UINavigationController(rootViewController: createMemeVC)
        self.presentViewController(navController, animated: true, completion: nil)
        
    }
}
