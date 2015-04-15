//
//  NotificationAbstraction.swift
//  Lesson04
//
//  Created by Isaac Benham on 4/12/15.
//  Copyright (c) 2015 General Assembly. All rights reserved.
//

import UIKit

class KeyboardNotificationHelper {
    
    let info: [String : Any]
    let type: String

    required init (aKeyboardNotification: NSNotification){
        println(aKeyboardNotification)
        info = {
            var newDict = [String: Any]()
            if let someInfo = aKeyboardNotification.userInfo{
                for (key, value) in someInfo {
                    let keyString = key as String
                    if let pair = DictionaryKey(rawValue: keyString) {
                        switch pair {
                        case .animationDuration:
                            let aFloat = someInfo[pair.rawValue]?.floatValue
                            newDict[pair.rawValue] = aFloat
                        case .animationCurve:
                            let anInt = someInfo[pair.rawValue]?.integerValue
                            newDict[pair.rawValue] = anInt
                        default:
                            let aRect = someInfo[pair.rawValue]?.CGRectValue()
                            newDict[pair.rawValue] = aRect
                        }
                    }
                    
                }
            }
            return newDict
        } ()
        type = aKeyboardNotification.name
        // may want to make this failable
    }
    
    enum DictionaryKey: String {
        case beginFrame = "UIKeyboardFrameBeginUserInfoKey"
        case endFrame = "UIKeyboardFrameEndUserInfoKey"
        case animationDuration = "UIKeyboardAnimationDurationUserInfoKey"
        case animationCurve = "UIKeyboardAnimationCurveUserInfoKey"
    }
    
    
    func keyboardBeginningRect() -> CGRect {
        let key = DictionaryKey.beginFrame.rawValue
        return info[key] as CGRect
    }
    
    func keyboardEndingRect() -> CGRect {
        let key = DictionaryKey.endFrame.rawValue
        return info[key] as CGRect
    }
    
    func animationDuration() -> Double {
        let key = DictionaryKey.animationDuration.rawValue
        let returnVal = info[key] as Float
        return Double(returnVal)

    }
    
    
    func animationCurve() -> UIViewAnimationOptions {
        let key = DictionaryKey.animationCurve.rawValue
        let rawValue = info[key] as Int
        return UIViewAnimationOptions(UInt(rawValue))
    }
    
}