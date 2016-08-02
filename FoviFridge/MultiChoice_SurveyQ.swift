//
//  MultiChoice_SurveyQ.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 7/16/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire

class MultiChoice_SurveyQ: UIViewController, UITableViewDelegate, UITableViewDataSource, otherMC {

    
    @IBOutlet var sendActionsButton: UIButton!
    
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var idLabel : UILabel!

    
    var my_answers = [String]()
    
    var question_id : Int?
    var cUser = UserDetails()
    var today = NSDate()

    var answers_array = [String]()
    
    var q = SurveyQuestion()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view.layer.cornerRadius = 9
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.answers_array.count != 0{
        return self.answers_array.count + 1
        }else{
            return self.answers_array.count
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        print(indexPath.row)
//        print(answers_array.count)

        if indexPath.row <= self.answers_array.count - 1 {
            let cell : MultiChoice_Cell = tableView.dequeueReusableCellWithIdentifier("MultiChoice_Cell", forIndexPath: indexPath) as! MultiChoice_Cell
            
            cell.delegate = self

            cell.answerLabel.text = "\(self.answers_array[indexPath.row])"//"Friends / Family"
//            cell.circleButton.addTarget(self, action: "addAnswer", forControlEvents: .TouchUpInside)
            tableView.rowHeight = 44

            return cell
        }else {
            let cell : MultiChoice_Other_Cell = tableView.dequeueReusableCellWithIdentifier("MultiChoice_Other_Cell", forIndexPath: indexPath) as! MultiChoice_Other_Cell
            cell.delegate = self
            cell.sendButton.addTarget(self, action: "beforeSendAnswers", forControlEvents: .TouchUpInside)
            tableView.rowHeight = 88
            
            return cell
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            let cell : MultiChoice_Cell = tableView.dequeueReusableCellWithIdentifier("MultiChoice_Cell", forIndexPath: indexPath) as! MultiChoice_Cell
        
            cell.answerLabel.text = self.answers_array[indexPath.row]//"Friends / Family"
            print("Selected")
            // Send Survey Answer here, animataion doesn't matter
            
        }
    }
    
    
    
    func beforeSendAnswers(){
        sendAnswer("\(self.my_answers)", question: self.questionLabel.text!, question_id: self.question_id!)
    }
    
    // var myAnswer = "\(my_answers)"
    // var theQuestion = self.questionLabel!.text
    
    // Send Answer to Survey Question
    func sendAnswer(answer : String, question : String, question_id : Int){
        print("Posting...")
        let parameters = [
            "answer": "\(answer)",
            "question": "\(question)",
            "question_id": question_id
        ]
        
        
        Alamofire.request(.POST, "https://rocky-fjord-88249.herokuapp.com/api/v1/answers", parameters: parameters as? [String : AnyObject], encoding: .JSON)
        //        debugPrint(teth)
        print("Posted Answer to Survey...")
        
        
        print("\(cUser.name) is adding Question Id to the list")
        
        let realm = try! Realm()
        var q_id = SurveyQuestions()
        q_id.id = "\(question_id)"
        
        try! realm.write {
            cUser.the_last_answered = today
            cUser.survey_questions_answered.append(q_id)
            print("Added Question Id and Updated Last Answered date")
        }
        sendActionsButton.sendActionsForControlEvents(.TouchUpInside)

    }
    
        
    
    
    func addAnswer(cellAnswer : String){
        print("Added \(cellAnswer) to Answers")
        my_answers.append(cellAnswer)
        print(my_answers)
    }
    
    func removeAnswer(cellAnswer : String){
        if my_answers.contains(cellAnswer){
            var it = my_answers.indexOf(cellAnswer)
            my_answers.removeAtIndex(it!)
            print("Removed \(cellAnswer) from Answers")
            print(my_answers)
        }else{
            print("\(cellAnswer) Not Found in Answers Array")
            print(my_answers)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegueUITextFieldDelegatesegue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
