//
//  TableViewController.swift
//  VocaStudy
//
//  Created by naver on 2017. 5. 24..
//  Copyright © 2017년 ansi. All rights reserved.
//

import Foundation
import SwipeCellKit
import UIKit
import RealmSwift

class TableViewController: UITableViewController, UITextFieldDelegate{

    
    let common = Common()
    @IBOutlet  var timeText:UITextField!
    
    override func viewDidLoad() {
        timeText.delegate = self
        timeText.text = String(common.getIntaval())
        
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //테이블 수
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return common.getCount()
    }
    
    //각셀 설정
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = common.getVoca(indexPath.row)
        let cell = SwipeTableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "ListCell")
        
        cell.textLabel?.text = row.main + "(" + row.sub + ")"
        cell.detailTextLabel?.text = row.describe
        
        if(row.isComplete == true)
        {
            cell.backgroundColor = UIColor.green
        }
        else{
            cell.backgroundColor = UIColor.white
        }
        
        cell.delegate = self
        
        return cell
    }
    
    
    //셀 선택 시
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //클릭 후선 택 해제
        self.tableView.deselectRow(at: indexPath, animated: true)
         self.addAlert(common.getVoca(indexPath.row), true)
        self.tableView.reloadData()
        
    }

    
    @IBAction func stop(_ segue:UIStoryboardSegue){ }
    
    @IBAction func addVocatoUser(){
        
        let item = VocaData()
        let isEdit = false
        
        let alert = UIAlertController(title:"Add Method",message:"Select the add method",preferredStyle: .actionSheet)
        
        let single = UIAlertAction(title:"singeAdd", style:.default){
            (_) in
            self.addAlert(item, isEdit)
        }
        
        let multi = UIAlertAction(title:"multiAdd", style:.default){
            (_) in
            self.present(self.common.successAlert("NOT YET"),animated: true)
        }
        
        let cancel = UIAlertAction(title:"cancel", style:.default)
        
        alert.addAction(single)
        alert.addAction(multi)
        alert.addAction(cancel)
        
        self.present(alert,animated: true)
        
    }
    
    func addList(_ index:Int,_ isEdit:Bool){
        
        
        
    }
    
    
    func addAlert(_ item:VocaData,_ isEdit:Bool){
        
        let alert = UIAlertController(title:"Add Audit Site", message:"input info", preferredStyle:UIAlertControllerStyle.alert)
        let confirm = UIAlertAction(title:"confirm", style:UIAlertActionStyle.default){
            (_) in
            try! self.common.realm.write{
                if !isEdit{
                    item.main = (alert.textFields?[0].text)!
                }
                
                item.sub = (alert.textFields?[1].text)!
                item.describe = (alert.textFields?[2].text)!
            }
            
               self.subAlert(item,isEdit)
            
        }
        let cancel = UIAlertAction(title:"cancel",style:UIAlertActionStyle.cancel)
        
        alert.addAction(confirm)
        alert.addAction(cancel)
        
        
            alert.addTextField(configurationHandler: {(tf) in
                
                tf.placeholder = "Main"
                tf.text = item.main
                
                
                if(isEdit){
                    tf.isUserInteractionEnabled = false
                }
                
            })
        
        alert.addTextField(configurationHandler: {(tf) in
            
            tf.placeholder = "SubMain"
            tf.text = item.sub
        })
        
        alert.addTextField(configurationHandler: {(tf) in
            
            tf.placeholder = "Description"
            tf.text = item.describe
        })
        
        
        self.present(alert, animated: false)
        
    }
    
    func subAlert(_ item:VocaData,_ isEdit:Bool){
        
        if (item.main.isEmpty) || (item.describe.isEmpty){
            self.present(self.addFailAlert(item, isEdit,"input main and description"), animated: false)
        }
        else if common.isExist(item.main) && !isEdit{
            self.present(self.addFailAlert(item, isEdit,"this Voca exist"), animated: false)
        }
        else
        {
                common.updateVoca(item, isEdit)
            self.tableView.reloadData()
            self.present(common.successAlert("complete"), animated: false)
        }
        
    }
    
    func addFailAlert(_ item:VocaData,_ isEdit:Bool, _ msg:String)->UIAlertController{
        let alert1 = UIAlertController(title:nil, message:msg, preferredStyle:UIAlertControllerStyle.alert)
        let confirm = UIAlertAction(title:"confirm", style:UIAlertActionStyle.default){
            (_) in
            self.addAlert(item, isEdit)
        }
        alert1.addAction(confirm)
        
        return alert1
    }
    
    

    @IBAction func changeTime(){
        self.timeText.resignFirstResponder()
        let time = timeText.text
        
        common.setIntaval(Int(time!)!)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.timeText.resignFirstResponder()
        
        
        
    }
    
    
}

extension TableViewController:SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        if orientation == .left {
            let item = self.common.getVoca(indexPath.row)
            var title:String
            if(!item.isComplete){
                title = "complete"
            }
            else{
                title = "uncomplete"
            }
           let isCompleteAction = SwipeAction(style: SwipeActionStyle.default, title: title) { action, indexPath in
                // handle action by updating model with deletion
            
            try! self.common.realm.write {
                item.isComplete = !item.isComplete
            }
            
                self.common.updateVoca(item, true)
             self.tableView.reloadData()
            }
            return [isCompleteAction]
            
            
        }
        else {
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                self.common.deleteVoca(indexPath.row)
                self.tableView.reloadData()
                
            }
            deleteAction.image = UIImage(named: "delete")
            return [deleteAction]
        }
        
        
    }
    //스와이프 옵션
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .selection
        options.transitionStyle = .border
        return options
    }
}

