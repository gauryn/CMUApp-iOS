//
//  DirectViewController.swift
//  CMU App View
//
//  Created by Gaury Nagaraju on 3/30/16.
//  Copyright © 2016 Gaury Nagaraju. All rights reserved.
//

import UIKit

private let reuseIdentifier = "AppItemCell"

class DirectViewController: UIViewController, UIPopoverPresentationControllerDelegate{
    
    //MARK: Properties
    @IBOutlet weak var mainStack: UIStackView!
    @IBOutlet weak var appIcons: UICollectionView!
    @IBOutlet weak var tartanFooter: TartanFooter!
    
    var appItems = []
    
    func changeTitleBarColor(){
        //self.view.backgroundColor = UIColor.blackColor()
        //self.view.tintColor = UIColor.whiteColor()
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        loadAppItems()
        
        // invert title bar color from white to black
        changeTitleBarColor()
        
        self.view.addSubview(appIcons)
        
        self.view.addSubview(mainStack)
        mainStack.addArrangedSubview(appIcons)
        mainStack.addArrangedSubview(tartanFooter)
        
        mainStack.axis = UILayoutConstraintAxis.Vertical
        mainStack.distribution = UIStackViewDistribution.Fill
        
    }
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        
        let top = topLayoutGuide.length
        let bottom = bottomLayoutGuide.length
        
        mainStack.frame = CGRect(x: 0, y: top, width: view.frame.width, height: view.frame.height - top - bottom)
        
        let backgroundRect = mainStack.frame
        let bgView = UIView(frame: backgroundRect)
        bgView.backgroundColor = UIColor(red: 0.59999999999999998, green: 0.0, blue: 0.0, alpha: 0.59999999999999998)
        
        self.mainStack.insertSubview(bgView, atIndex: 0)
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = self.appIcons.bounds
        rectShape.position = self.appIcons.center
        rectShape.path = UIBezierPath(roundedRect: self.appIcons.bounds, byRoundingCorners: [.BottomLeft, .BottomRight], cornerRadii: CGSize(width: 60, height: 60)).CGPath
        
        self.appIcons.layer.mask = rectShape
        
    }
    
    func loadAppItems(){
        let query = PFQuery(className:"AppItem")
        let error = NSErrorPointer()
        let numObjects = query.countObjects(error)
        do{
            appItems = try query.findObjects()
        }
        catch{print("Error")}
        //        for i in 0...(numObjects-1){
        //            print("Index: ", i)
        //            print(appItems[i])
        //        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections - in this case, only one section
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return appItems.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //
        //        print("NS: ", indexPath)
        //        print("NS ip: ", indexPath.item)
        //        print("NS sec: ", indexPath.section)
        //        print("\n")
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! AppItemCollectionViewCell
        
        // Fetches the appropriate appItem for the data source layout.
        let appItem = appItems[indexPath.item] as! PFObject
        
        // Configure the cell
        cell.photoImageView.layer.cornerRadius = 10.0
        if let parseImage = appItem["icon"] as? PFFile!{
            parseImage?.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let img = UIImage(data:imageData)
                        cell.photoImageView.image = img
                    }
                }
            }
        }
        cell.appItemName.text = appItem["name"] as? String
        cell.appItemName.textColor = UIColor.whiteColor()

        return cell
    }

    
    // MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let appItem = appItems[indexPath.item] as! PFObject
        var link = String()
        if(appItem["type"] as! String == "url"){
            link = (appItem["link_alt"] as? String)!
        }
        else if(appItem["type"] as! String == "app"){
            link = (appItem["link_ios"] as? String)!
            //link = "tiramisu://"
            let u = NSURL(string: link)!
            if UIApplication.sharedApplication().canOpenURL(u){
                
            }
            else{
                // mobile website if tiramisu not installed on phone
                link = (appItem["link_alt"] as? String)!
            }
            print ("Link: ", link)
        }
        else{
            // phone links - e.g. Police, FMS
            link = "telprompt:" + (appItem["link_ios"] as? String)!
            print ("Link: ", link)
        }
        let url = NSURL(string: link)!
        if UIApplication.sharedApplication().canOpenURL(url) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
            
            // width
            let cellSpacing = (appIcons.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing
            let numOfCols = 3
            let whiteSpace = cellSpacing * CGFloat(numOfCols)
            // height
            let itemHeight = (UIScreen.mainScreen().bounds.width-whiteSpace)/4
            
            let numOfRows = CGFloat(Int(appItems.count/numOfCols))
            let totalCellSpaceHeight = (itemHeight+cellSpacing)*numOfRows
            // if total cell space height < collectionView height: follow AutoLayout
            if totalCellSpaceHeight+150 < appIcons.frame.height{
                let cellSize = (appIcons.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
                return cellSize
            }
            else{
                // height = weight: square icons
                return CGSizeMake((UIScreen.mainScreen().bounds.width-whiteSpace)/4, itemHeight)
            }
            
    }
    
    // Popover
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "popoverSegue" {
            let popoverViewController = segue.destinationViewController 
            popoverViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController.popoverPresentationController!.delegate = self
        }
    }
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
    }
    */
    
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
    }
    
    
    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
    return false
    }
    
    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
