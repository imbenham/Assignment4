//
//  ViewController.swift
//  Lesson04
//
//  Created by Rudd Taylor on 9/28/14.
//  Copyright (c) 2014 General Assembly. All rights reserved.
//

import UIKit

class ArrayViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textFieldBottomPin: NSLayoutConstraint!
    var dataStore = [String]()
    
    var textFieldPadding:CGFloat = 0
    
    var keyboardUp = false

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.dismissViewControllerAnimated(false, completion: nil)
        self.dismissViewControllerAnimated(false, completion: { () -> Void in
            self.view.backgroundColor = UIColor.blueColor()
        })
        
        self.view.backgroundColor = UIColor.redColor()
        textField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        //textField.setTranslatesAutoresizingMaskIntoConstraints(false)
        //tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        //testView.setTranslatesAutoresizingMaskIntoConstraints(false)

        
        /*
        TODO one: Add a table view AND a text input box to this view controller, either in code or via the storyboard. Accept keyboard input from the text view when the return key is pressed. Add the string that was entered into the text view into an array of strings (stored in this class).
        */
        /*
        let textPinBottom = NSLayoutConstraint(item: textField, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1, constant: 10)
        //let textPinLeft = NSLayoutConstraint(item: textField, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1, constant: 0)
       // let textPinRight = NSLayoutConstraint(item: textField, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1, constant: 0)
        let textHeight = NSLayoutConstraint(item: textField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20)
        let textWidth = NSLayoutConstraint(item: textField, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1, constant: 0)
        
        let constraints = [textPinBottom, textHeight, textWidth]
        NSLayoutConstraint.activateConstraints(constraints)
        */
        //println(constraints.description)
        
        
        
        /*
        TODO two: Make this class a UITableViewDelegate and UITableViewDataSource that supply the above table view with cells. These cells should correspond to the text entered into the text box. E.g. If the text "one", then "two", then "three" was entered into the text box, there should be three cells in this table view that contain those strings in order.
        
        */
    }
    
    override func viewWillAppear(animated: Bool) {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardDidHide:", name: UIKeyboardDidHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
        if keyboardUp {
            textFieldBottomPin.constant -= textFieldPadding
        }
    }
    
    // MARK: text field delegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let newString = textField.text
        if newString != "" {
            dataStore.append(newString)
            let lastIndex = NSIndexPath(forRow: dataStore.count-1, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([lastIndex], withRowAnimation: UITableViewRowAnimation.Left)
            textField.text = ""
        }

        return true
    }
    
    // MARK: table view
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStore.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TextCell", forIndexPath: indexPath) as UITableViewCell
        
        cell.textLabel!.text = dataStore[indexPath.row]
        
        return cell
    }
    
    
    // MARK: keyboard notification
    func keyboardWillShow(notification:NSNotification) {
        keyboardUp = true
        let helper = KeyboardNotificationHelper(aKeyboardNotification: notification)
        let kbRect = helper.keyboardEndingRect()
        textFieldPadding = kbRect.size.height
        
        
        let animationBlock:() -> Void = {
            self.view.layoutIfNeeded()
            self.textFieldBottomPin.constant += self.textFieldPadding
        }
        
        let animationCurve = helper.animationCurve()
        println(animationCurve)
        let theDelay:NSTimeInterval = 0.3
        let theDuration:NSTimeInterval = helper.animationDuration()
        
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(theDuration, delay: theDelay, options: animationCurve, animations: animationBlock, completion:nil)
    }
    
    func keyboardDidShow(notification:NSNotification) {
       
    }
    
    func keyboardWillHide(notification:NSNotification) {
        let animationBlock:() -> Void = {
            self.view.layoutIfNeeded()
            self.textFieldBottomPin.constant -= self.textFieldPadding
        }
        let helper = KeyboardNotificationHelper(aKeyboardNotification: notification)
        let animationCurve = helper.animationCurve()
        println(animationCurve)
        let theDelay:NSTimeInterval = 0.0
        let theDuration:NSTimeInterval = helper.animationDuration()
        
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(theDuration, delay: theDelay, options: animationCurve, animations: animationBlock, completion:nil)
    }
    
    func keyboardDidHide(notification:NSNotification) {
        keyboardUp = false
    }
    

}

