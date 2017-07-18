//
//  ViewController.swift
//  myJobSearch
//
//  Created by chang on 2017/7/11.
//  Copyright © 2017年 chang. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
    @IBOutlet weak var txtJob: UITextField!
    @IBOutlet weak var txtSalary: UITextField!
    @IBOutlet weak var switchLocation: UISwitch!
    
    var dicRow = [String:Any?]()
    var arrJob1 = [[String:Any?]]()
    
    var currentRow = 0
    var db:OpaquePointer? = nil
    var counter = 2
    
    
//    var arrJob = [["經營／人資類",
//                  "經營／幕僚類人員",
//                  "儲備幹部",
//                  "人力資源主管",
//                  "行政／總務類人員",
//                  "行政人員",
//                  "法務／智財類人員",
//                  "法務／智財主管"],["行政人員","法務／智財類人員","法務／智財主管"]]
    //測試
    //var arrJob = [["經營/幕僚類人員":["行政人員","法務／智財類人員","法務／智財主管"]]]
    
    
    
    var arrSalary = ["30000-35000","35000-40000","40000-45000","45000-50000","50000-55000"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            db = appDelegate.getDB()
        }
        
        
        //執行sql指令
        let sql = "SELECT yvtc_num,yvtc_name,yvtc_des,yvtc_visable FROM job_category Where substr(yvtc_num,5,6) = '000000'"

        //第二層  Where substr(yvtc_num,5,3) <> '000' and substr(yvtc_num,8,3) = '000'
        //第三層  Where substr(yvtc_num,5,3) <> '000' and substr(yvtc_num,8,3) <> '000'
        let cSql = sql.cString(using: .utf8)
        var statement:OpaquePointer? = nil
        
        sqlite3_prepare(db, cSql!, -1, &statement, nil)
        while sqlite3_step(statement) == SQLITE_ROW{
            let job_no = sqlite3_column_text(statement, 0)
            let cJobNo = String(cString: job_no!)
            let job_name = sqlite3_column_text(statement, 1)
            let cJobName = String(cString: job_name!)
            
            dicRow = ["job_no": cJobNo,"job_name": cJobName]
            arrJob1.append(dicRow)
        }
        //print(arrJob1)
        sqlite3_finalize(statement)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "job1"{
            let vc = segue.destination as! JobViewController1
            vc.arrJob1 = self.arrJob1
        }
        if segue.identifier == "salary1"{
            let vc = segue.destination as! SalaryTableViewController
            vc.arrSalary = self.arrSalary
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.resignFirstResponder()
    }
    
    @IBAction func btnStart(_ sender: UIButton) {
        
        performSegue(withIdentifier: "jobSearchResult", sender: nil)
    }
    
    @IBAction func txtJobEnter(_ sender: UITextField) {
        if self.counter % 2 == 0 {
            performSegue(withIdentifier: "job1", sender: nil)
            
        }
        counter += 1
        
    }

    @IBAction func txtSalaryEnter(_ sender: Any) {
        if self.counter % 2 == 0 {
            performSegue(withIdentifier: "salary1", sender: nil)
            
        }
        counter += 1
    }
    
}

