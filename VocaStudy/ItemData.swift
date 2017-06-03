//
//  ItemData.swift
//  VocaStudy
//
//  Created by naver on 2017. 5. 27..
//  Copyright © 2017년 ansi. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


class VocaData:Object{

    //dynamic var id:Int = 0
    dynamic var main:String = ""
    dynamic var sub:String = ""
    dynamic var describe : String = ""
    dynamic var isComplete : Bool = false
    
    override class func primaryKey()->String{
        return "main"
        
    }
}

class SettingValue:Object{
    dynamic var id:Int = 0
    dynamic var intaval:Int = 0
    
    override class func primaryKey () -> String {
        return "id"
    }
}
