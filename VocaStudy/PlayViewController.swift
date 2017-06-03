//
//  PlayViewController.swift
//  VocaStudy
//
//  Created by naver on 2017. 5. 27..
//  Copyright © 2017년 ansi. All rights reserved.
//

import Foundation
import UIKit
class PlayViewController:UIViewController{
    
    @IBOutlet var lbl1:UILabel!
    @IBOutlet var lbl2:UILabel!
    @IBOutlet var lbl3:UILabel!
    @IBOutlet var lbl4:UILabel!
    
    let common = Common()
    var timer :Timer!
    var currentTime : Int!
    var maxTime : Int!
    var repeatCount : Int! = 0
    
    
    override func viewDidLoad() {
        let tab1 = UITapGestureRecognizer(target:self, action: #selector(self.tabAction))
        lbl1.isUserInteractionEnabled = true
        lbl1.addGestureRecognizer(tab1)
        
        let tab2 = UITapGestureRecognizer(target:self, action: #selector(self.tabAction))
        lbl2.isUserInteractionEnabled = true
        lbl2.addGestureRecognizer(tab2)
        
        let tab3 = UITapGestureRecognizer(target:self, action: #selector(self.tabAction))
        lbl3.isUserInteractionEnabled = true
        lbl3.addGestureRecognizer(tab3)
        
        self.startMemorize()
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tabAction(_ sender:UITapGestureRecognizer){
        
        
        let label = sender.view as! UILabel
        
        
        if label.textColor == UIColor.black{
            label.textColor = UIColor.white
        }
        else{
            label.textColor = UIColor.black
        }
        
        
    }
    
    func finishAlert(_ msg:String)->UIAlertController{
        let alert1 = UIAlertController(title:nil, message:msg, preferredStyle:UIAlertControllerStyle.alert)
        let confirm = UIAlertAction(title:"confirm", style:UIAlertActionStyle.default){
            (_) in
             self.performSegue(withIdentifier: "stopMemorizePage", sender: self)
        }
        alert1.addAction(confirm)
        
        return alert1
    }
    
    func startMemorize(){
         timer=Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.memorizing), userInfo: nil, repeats: true)
        currentTime = 0
        maxTime = common.getIntaval()
        print(maxTime)
    }
    
    func stopMemorize(){
        timer.invalidate()
    }
    
    func memorizing(){
        
        if currentTime == 0{
            
            if repeatCount<common.getCount() && repeatCount>=0{
                
                let item = common.getVoca(repeatCount)
                
                if item.isComplete{
                    repeatCount = repeatCount+1
                    return
                }
                else{
                    lbl1.text = item.main
                    lbl2.text = item.sub
                    lbl3.text = item.describe
                }
                
            }
            else{
                self.stopMemorize()
                self.present(self.finishAlert("End Memorizing"),animated: true)
            }
        
        }
        else if currentTime == maxTime{
            currentTime = 0
            repeatCount = repeatCount+1
            return
        }
        
        let remainTime :String? = String(maxTime-currentTime)
        
        if(remainTime != nil){
            lbl4?.text = remainTime!
            currentTime = currentTime+1
        }
        
        
    }
    
    @IBAction func moveToPreviousVoca(){
        currentTime = 0
        repeatCount = repeatCount-1
        
    }
    
    @IBAction func moveToNextVoca(){
        currentTime = 0
        repeatCount = repeatCount+1
        
    }
    
    

}
