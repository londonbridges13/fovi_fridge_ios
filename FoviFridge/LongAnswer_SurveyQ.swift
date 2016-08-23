//
//  LongAnswer_SurveyQ.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 7/19/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class LongAnswer_SurveyQ: UIViewController, UITextViewDelegate {

    
    @IBOutlet var questionLabel: UILabel!
    
    
    @IBOutlet var answerTX: UITextView! = nil
    
    
    @IBOutlet var sendActionsButton: UIButton!
    
    @IBOutlet var idLabel : UILabel!

    var question_id : Int?
    var cUser = UserDetails()
    var today = NSDate()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.layer.cornerRadius = 9
        answerTX.delegate = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            print("Pressed Return")
            if answerTX.text.characters.count >= 2{
                textView.resignFirstResponder()
                sendActionsButton.sendActionsForControlEvents(.TouchUpInside)
                sendAnswer(answerTX.text!, question: questionLabel.text!, question_id: question_id!)
                answerTX.text = ""
            }
            return false
        }
        return true
    }
    
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
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
