//
//  CommonFunc.swift
//  VocaStudy
//
//  Created by naver on 2017. 5. 27..
//  Copyright © 2017년 ansi. All rights reserved.
//

import Foundation
import RealmSwift

class Common{

    let realm = try! Realm()
    var itemList : Results<VocaData>!
    var settingValue:SettingValue!
    
    init() {
        itemList = realm.objects(VocaData.self)
        
        let set = realm.objects(SettingValue.self)
        
        if set.count == 0{
            settingValue = SettingValue()
            settingValue.id = 1
            settingValue.intaval = 60
            
            try! realm.write {
                realm.add(settingValue)
            }
        }
        else{
            settingValue = set[0]
        }
        
    }
    
    func getVoca(_ index:Int) -> VocaData{
        return itemList[index]
    }
    
    func updateVoca(_ item:VocaData, _ isEdit:Bool){
        
        try! realm.write{
            realm.add(item,update:true)
        }
        
        if(!isEdit){
            itemList = realm.objects(VocaData.self)
        }
    }
    
    func addVoca(_ item:VocaData){
        try! realm.write{
            realm.add(item)
        }
    }
    
    func deleteVoca(_ index:Int){
        try! realm.write{
            realm.delete(itemList[index])
        }
    }
    
    
        
    func setIntaval(_ time:Int){
        try! realm.write{
            settingValue.intaval = time
            realm.add(settingValue, update:true)
        }
    }
    
    func getIntaval() -> Int{
        return settingValue.intaval
    }
    
    
    func getCount()->Int{
        return itemList.count
    }
    
    func isExist(_ main:String)->Bool{
    
        for i in 0..<itemList.count{
            if(itemList[i].main == main){
                return true
            }
        }
        
        return false
    }
    
    
    
    func successAlert( _ msg:String)->UIAlertController{
        let alert1 = UIAlertController(title:nil, message:msg, preferredStyle:UIAlertControllerStyle.alert)
        let confirm = UIAlertAction(title:"confirm", style:UIAlertActionStyle.default)
        alert1.addAction(confirm)
        
        return alert1
    }
    
    
    
}
