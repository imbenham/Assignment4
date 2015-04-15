//
//  MapViewController.swift
//  Lesson04
//
//  Created by Rudd Taylor on 9/28/14.
//  Copyright (c) 2014 General Assembly. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var keyField: UITextField!
    @IBOutlet weak var valueField: UITextField!
    
    @IBOutlet weak var valueFieldBottomPin: NSLayoutConstraint!
    @IBOutlet weak var textFieldBottomPin: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    var dataDictionary = [String: String]()
    var pendingKey: String?
    var textFieldPadding:CGFloat = 0
    let textFieldSelectedColor = UIColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 1)
    let textFieldUnselectedColor = UIColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        keyField.delegate = self
        valueField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        keyField.backgroundColor = textFieldUnselectedColor
        valueField.backgroundColor = textFieldUnselectedColor
        
        
        /*
        TODO three: Add TWO text views and a table view to this view controller, either using code or storybaord. Accept keyboard input from the two text views. When the 'return' button is pressed on the SECOND text view, add the text view data to a dictionary. The KEY in the dictionary should be the string in the first text view, the VALUE should be the second. DONE
        TODO four: Make this class a UITableViewDelegate and UITableViewDataSource that supply this table view with cells that correspond to the values in the dictionary. Each cell should print out a unique pair of key/value that the map contains. When a new key/value is inserted, the table view should display it. DONE
        TODO five: Make the background of the text boxes in this controller BLUE when the keyboard comes up, and RED when it goes down. Start with UIKeyboardWillShowNotification and NSNotificationCenter. DONE
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
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: text field delegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField === keyField {
            if textField.text != "" {
                pendingKey = textField.text
                valueField.becomeFirstResponder()
            }
        } else {
            if pendingKey != nil {
                if textField.text != "" {
                    dataDictionary[pendingKey!] = textField.text
                    pendingKey = nil
                    keyField.text = ""
                    valueField.text = ""
                    
                    let lastIndex = NSIndexPath(forRow: dataDictionary.count-1, inSection: 0)
                    self.tableView.insertRowsAtIndexPaths([lastIndex], withRowAnimation: UITableViewRowAnimation.Left)
                } else {
                    keyField.text = ""
                    self.scoldUser()
                }
            } else {
                valueField.text = ""
                self.scoldUser()
            }

        }
    }
    
    func scoldUser () {
        // throw an alert
    }
    
    // MARK: table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataDictionary.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DetailCell", forIndexPath: indexPath) as UITableViewCell

        let theKey = dataDictionary.keys.array[indexPath.row]
        let theValue = dataDictionary[theKey]!
        
        
        cell.textLabel!.text = "key: "+theKey
        let valueLabel = cell.detailTextLabel!
        valueLabel.font = UIFont.boldSystemFontOfSize(18)
        valueLabel.text = theValue
        
        return cell
    }
    
    // MARK: keyboard notification
    func keyboardWillShow(notification:NSNotification) {
        let helper = KeyboardNotificationHelper(aKeyboardNotification: notification)
        let kbRect = helper.keyboardEndingRect()
        textFieldPadding = kbRect.size.height
        
        let animationBlock:() -> Void = {
            self.view.layoutIfNeeded()
            self.keyField.backgroundColor = self.textFieldSelectedColor
            self.valueField.backgroundColor = self.textFieldSelectedColor
            self.valueFieldBottomPin.constant += self.textFieldPadding
            self.textFieldBottomPin.constant += self.textFieldPadding
        }
        
        let animationCurve = helper.animationCurve()
        println(animationCurve)
        let theDelay:NSTimeInterval = 0.0
        let theDuration:NSTimeInterval = helper.animationDuration()
        
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(theDuration, delay: theDelay, options: animationCurve, animations: animationBlock, completion:nil)

    }
    

    func keyboardDidShow(notification:NSNotification) {
            }
    
    func keyboardWillHide(notification:NSNotification) {
        let helper = KeyboardNotificationHelper(aKeyboardNotification: notification)
        
        let animationBlock:() -> Void = {
            self.view.layoutIfNeeded()
            self.keyField.backgroundColor = self.textFieldUnselectedColor
            self.valueField.backgroundColor = self.textFieldUnselectedColor
            self.valueFieldBottomPin.constant -= self.textFieldPadding
            self.textFieldBottomPin.constant -= self.textFieldPadding
        }
        
        let animationCurve = helper.animationCurve()
        println(animationCurve)
        let theDelay:NSTimeInterval = 0.0
        let theDuration:NSTimeInterval = helper.animationDuration()
        
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(theDuration, delay: theDelay, options: animationCurve, animations: animationBlock, completion:nil)
       
    }
    
    func keyboardDidHide(notification:NSNotification) {
       
    }

}
