//
//  SurveyVC.swift
//  FoviFridge
//
//  Created by Lyndon Samual McKay on 7/15/16.
//  Copyright © 2016 Lyndon Samual McKay. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import RealmSwift
import FoldingTabBar

class SurveyVC: UIViewController {

    @IBOutlet var yesNo_View: YesNo_SurveyQ!
    @IBOutlet var yesNoPic_View: YesNoPic_SurveyQ!
    @IBOutlet var thankYou_View: ThankYou_SurveyView!
    
    @IBOutlet var longAnswer_View: UIView!
    @IBOutlet var multichoice_View: UIView!
    
    var actIndi : NVActivityIndicatorView?
    var survey_questions = [SurveyQuestion]()
    var answered_questionsArray = [String]()
    var no_survey : Bool?
    var last_survey_date : NSDate?
    var today = NSDate()
    var cUser = UserDetails()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        removeAllViews()
        addLoadingScreen()
        
        //testing users
//        createDummyUser()
        
        // finding all survey question ids
        self.grab_question_ids()
        // getting userdetails
        
        self.queryUserInfo()
        // Check If question Answered Question Today Func, if so... (inside the func)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    func createDummyUser(){
        let realm = try! Realm()
        let dummy = UserDetails()
        dummy.name = "Matt"
        dummy.paid_for_removeSurvey = false // didn;t opt out
        dummy.the_last_answered = nil // new user
        try! realm.write {
            realm.deleteAll()
            realm.add(dummy)
            print("Created User")
        }
    }
    
    // MARK: - LongAnswer
    func use_longAnswer(q : SurveyQuestion){
        removeAllViews()
        let lav = childViewControllers[1] as! LongAnswer_SurveyQ
        //lav.delegate = self // no need
        
        longAnswer_View.fadeIn()
        lav.answerTX.becomeFirstResponder() // works
        lav.cUser = self.cUser
        lav.questionLabel.text = q.question
        lav.question_id = q.question_id
        lav.idLabel.text = "#\(q.question_id!)"
        print("+++ qid \(q.question_id)")
        print("+++ survey id\(self.survey_questions[0].question_id)")
        if q.question_id == self.survey_questions[0].question_id{
            lav.sendActionsButton.addTarget(self, action: "present_thankYou", forControlEvents: .TouchUpInside)
        }else{
            lav.sendActionsButton.addTarget(self, action: "see_you_tomorrow", forControlEvents: .TouchUpInside)
        }
    }

    // MARK: - MultiChoiceAnswer
    func use_multi_choiceAnswer(q : SurveyQuestion){
        removeAllViews()
        let mca = childViewControllers[0] as! MultiChoice_SurveyQ
        //mca.delegate = self // no need
        multichoice_View.fadeIn()
        mca.questionLabel.text = q.question
        mca.idLabel.text = "#\(q.question_id!)"
        mca.question_id = q.question_id
        mca.answers_array = q.options
        mca.tableView.reloadData()
        if q.question_id == self.survey_questions[0].question_id{
            mca.sendActionsButton.addTarget(self, action: "present_thankYou", forControlEvents: .TouchUpInside)
        }else{
            mca.sendActionsButton.addTarget(self, action: "see_you_tomorrow", forControlEvents: .TouchUpInside)
        }
    }

    // MARK: - YesNoAnswer
    func use_yesNoAnswer(q : SurveyQuestion){
        removeAllViews()
        let ynv = self.yesNo_View
        addRoundEdges(9)
        self.yesNo_View.fadeIn()
        ynv.questionLabel.text = q.question
        ynv.idLabel.text = "#\(q.question_id!)"
        ynv.question = q
        // Sending survey from here
        if q.question_id == self.survey_questions[0].question_id{
            ynv.yesButton.addTarget(self, action: "present_thankYou", forControlEvents: .TouchUpInside)
            ynv.noButton.addTarget(self, action: "present_thankYou", forControlEvents: .TouchUpInside)
        }else{
            ynv.yesButton.addTarget(self, action: "see_you_tomorrow", forControlEvents: .TouchUpInside)
            ynv.noButton.addTarget(self, action: "see_you_tomorrow", forControlEvents: .TouchUpInside)
        }
    }
    
    // MARK: - YesNo_PicAnswer
    func use_yesNo_PicAnswer(q : SurveyQuestion){
        removeAllViews()
        let ynpv = self.yesNoPic_View
        addRoundEdges(9)
        self.yesNoPic_View.fadeIn()
        ynpv.surveyPic.backgroundColor = UIColor.lightGrayColor()
        ynpv.questionLabel.text = q.question
        ynpv.question = q
        ynpv.idLabel.text = "#\(q.question_id!)"
        ynpv.image_url = q.image_url
        if q.image_url != nil{
            print("Getting Image Now")
            ynpv.surveyPic.layer.cornerRadius = 3
            ynpv.surveyPic.layer.masksToBounds = true
            ynpv.getImage()
        }
        // Sending survey from here
        if q.question_id == self.survey_questions[0].question_id{
            ynpv.yesButton.addTarget(self, action: "present_thankYou", forControlEvents: .TouchUpInside)
            ynpv.noButton.addTarget(self, action: "present_thankYou", forControlEvents: .TouchUpInside)
        }else{
            ynpv.yesButton.addTarget(self, action: "see_you_tomorrow", forControlEvents: .TouchUpInside)
            ynpv.noButton.addTarget(self, action: "see_you_tomorrow", forControlEvents: .TouchUpInside)
        }
    }

    func present_thankYou(){
        removeAllViews()
        addRoundEdges(9)
        thankYou_View.fadeIn()
        thankYou_View.anotherButton.addTarget(self, action: "present_second_question", forControlEvents: .TouchUpInside)
        thankYou_View.noButton.addTarget(self, action: "see_you_tomorrow", forControlEvents: .TouchUpInside)
        
        
    }
    
    
    func removeAllViews(){
        yesNo_View.alpha = 0
        yesNoPic_View.alpha = 0
        thankYou_View.alpha = 0
        multichoice_View.alpha = 0
        longAnswer_View.alpha = 0
    }
    
    func addRoundEdges(i : CGFloat){
        yesNo_View.layer.cornerRadius = i
        yesNoPic_View.layer.cornerRadius = i
        thankYou_View.layer.cornerRadius = i
        multichoice_View.layer.cornerRadius = i
        longAnswer_View.layer.cornerRadius = i
    }
    
    func addLoadingScreen(){
        var size : CGFloat = 37
        var xp = self.view.frame.width / 2 - (size / 2)
        var hp = self.view.frame.height / 2 - 60
        let frame = CGRect(x: xp, y: hp, width: size, height: size)
        actIndi = NVActivityIndicatorView(frame: frame, type: .LineScale, color: UIColor.whiteColor(), padding: 3)
        actIndi?.startAnimation()
        actIndi?.alpha = 0
        
        view.addSubview(actIndi!)
        
        actIndi?.fadeIn()
    }
    
    func removeLoadingScreen(){
        actIndi?.fadeOut()
    }
    
    
    // Check if user opted out or answered survey today
    func checkSurvey(){
        if self.no_survey == true{
            // No Survey, send user over to Fridge
            goto_Fridge()
        }else{
            // Check last date answered, Verifys that the days are the same
            if last_survey_date != nil{
                var last_answered = self.getDayFromDate(last_survey_date!)
                var today_day = self.getDayFromDate(today)
                if last_answered == today_day{
                    //  Answered Question Today, Send to Fridge
                    goto_Fridge()
                }else{
                    // Run Survey
                    self.queryQuestions()
                }
            }else{
                // Run Survey
                self.queryQuestions()
            }
        }
    }
    
    // Fetch UserDetails form LocalDB
    func queryUserInfo(){
        let realm = try! Realm()
        let userDetails = realm.objects(UserDetails).first
        print("UserDetails")
        print(userDetails!.paid_for_removeSurvey)
        print(userDetails!.the_last_answered)
        print("...")
        if userDetails != nil{
            self.cUser = userDetails!
            self.no_survey = userDetails!.paid_for_removeSurvey
            print("This is self.no_survey or cUser.paid_for_nosurvey = \(no_survey)")
            // Setting selfs last answer date
            self.last_survey_date = userDetails!.the_last_answered
            
            // Wait... then checkSurvey
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.checkSurvey()
            }
        }else{
            // Create UserDetail, segue to walkthrough/onboard
        }
    }
    
    func grab_question_ids(){
        print("Grabbing Old Questions' Ids")
        let realm = try! Realm()
        let answered_questions = realm.objects(SurveyQuestions)
        for each in answered_questions{
            print("Grabbed \(each.id) for old questions")
            self.answered_questionsArray.append(each.id!)
            print("")
        }
    }
    // Query Survey Questions
    func queryQuestions() {
        var i = 0

        Alamofire.request(.GET, "https://rocky-fjord-88249.herokuapp.com/api/v1/surveys").responseJSON { (response) in
            print("querying Questions")
            print(response.result.value)
            if let questionsArray = response.result.value as? NSArray {
                print("P1")

                for each in questionsArray{
                    if let question = each as? NSDictionary{
                        var survey_question = SurveyQuestion()
                        let a_question = question["question"] as? String
                        print(a_question)
                        if a_question != nil{
                            survey_question.question = a_question!
                        }
                        let a_question_id = question["id"] as? Int
                        print(a_question_id)
                        if a_question_id != nil{
                            survey_question.question_id = a_question_id!
                        }
                        let stype = question["stype"] as? String
                        print(stype)
                        if stype != nil{
                            survey_question.stype = stype!
                        }
                        if stype == "mc"{
                            let option1 = question["option1"] as? String
                            if option1 != "" && option1 != "<null>" && option1 != nil && option1?.characters.count >= 2{
                                survey_question.options.append(option1!)
                                print("Appended Option1")
                            }
                            let option2 = question["option2"] as? String
                            if option2 != "" && option2 != "<null>" && option2 != nil && option2?.characters.count >= 2{
                                survey_question.options.append(option2!)
                                print("Appended Option2")
                            }
                            let option3 = question["option3"] as? String
                            if option3 != "" && option3 != "<null>" && option3 != nil && option3?.characters.count >= 2{
                                survey_question.options.append(option3!)
                                print("Appended Option3")
                            }
                            let option4 = question["option4"] as? String
                            if option4 != "" && option4 != "<null>" && option4 != nil && option4?.characters.count >= 2{
                                survey_question.options.append(option4!)
                                print("Appended Option4")
                            }
                            let option5 = question["option5"] as? String
                            if option5 != "" && option5 != "<null>" && option5 != nil && option5!.characters.count >= 2{
                                survey_question.options.append(option5!)
                                print("Appended Option5")
                            }
                        }
                        var imageurl = question["image"] as? String
                        // Begin filter
                            if stype == "ynpic"{
                                // We have a picture
                                print("We have an Image")
                                
                                //KF
                                // Replacing http with https
                                let range = imageurl!.startIndex.advancedBy(4)..<imageurl!.endIndex
                                let sub_url = imageurl![range]
                                
                                print("This is the url : https\(sub_url)")
                                var url = NSURL(string: "https\(sub_url)")
                                survey_question.image_url = url // Adding Url to SurveyQuestion
                                if self.answered_questionsArray.contains("\(survey_question.question_id!)") == false{
                                    if self.survey_questions.count <= 2{
                                        self.survey_questions.append(survey_question)
                                        print("Added \(survey_question.question) to Surveys")
                                    }
                                    if i == 0{
                                        self.before_present_question()
                                    }
                                    i += 1
                                }
                                
                                // Comment Out
                               /* KingfisherManager.sharedManager.retrieveImageWithURL(url!, optionsInfo: nil, progressBlock: nil, completionHandler: { (image, error, cacheType, imageURL) -> () in
                                    survey_question.image = image
                                    if self.answered_questionsArray.contains("\(survey_question.question_id!)") == false{
                                        if self.survey_questions.count <= 2{
                                            self.survey_questions.append(survey_question)
                                            print("Added \(survey_question.question) to Surveys")
                                        }
                                        if i == 0{
                                                self.before_present_question()
                                        }
                                        i += 1
                                    }
                                })
                                */
                            }else{
                                // We Don't have an Image
                                print("We Don't have an Image")
                                if self.answered_questionsArray.contains("\(survey_question.question_id!)") == false{
                                    if self.survey_questions.count <= 1{
                                        self.survey_questions.append(survey_question)
                                        print("Added \(survey_question.question) to Surveys")
                                    }
                                    if i == 0{
                                        self.before_present_question()
                                    }
                                    i += 1
                                }
                            }
                        
                    }
                    
                }
            }
        }
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
        print("Posted Apples to SFI...")
        
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

    func before_present_question(){
        print("before_present_question")
        // Check if you have to questions
        if survey_questions.count >= 1{
            print("Have a Question")
            // Run first question
            present_question(survey_questions[0])
        }else{
            // Present See you tomorrow, Segue to fridge
            print("Zero Questions Present")
            self.see_you_tomorrow()
        }
    }
    
    func present_question(q : SurveyQuestion){
        self.removeLoadingScreen()
        
        print("present_question...")
        if q.stype != nil{
            // Present Question
            print("___Presenting Question")
            if q.stype == "long"{
                //Presnet Long Text View
                print("presenting LongTextView")
                use_longAnswer(q)
            }else if q.stype == "mc"{
                // Present multichoice view
                print("Presenting Multi Choice View")
                use_multi_choiceAnswer(q)
            }else if q.stype == "yn"{
                // Present yesno view
                print("Presenting Yes/No View")
                use_yesNoAnswer(q)
            }else if q.stype == "ynpic"{
                // Present yes/noPic view
                print("Presenting Yes/No Pic View")
                use_yesNo_PicAnswer(q)
            }else{
                //Error, just send through
                print("Error, sending to Fridge")
                self.goto_Fridge()
            }
        }else{
            //Error, just send through
            print("Error, sending to Fridge")
            self.goto_Fridge()
        }
    }
    
    func present_second_question(){
        if survey_questions.count == 2{
            // Present second Question
            print("Presenting Second Question")
            present_question(survey_questions[1])
        }else{
            // Only one Questions today, present see you tomorrow and then send to Fridge
            self.see_you_tomorrow()
        }
    }


    
    // Converts date into day for checking
    func getDayFromDate(date : NSDate)-> Int{
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        
        let year =  components.year
        let month = components.month
        let day = components.day
        
        print(day)
        
        return day
    }
    
    

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func see_you_tomorrow(){
        self.removeAllViews()
        self.addLoadingScreen()
        // Display see you tomorrow view with ok button, push ok to segue to fridge vc
        print("Displaying See you Tomorrow")
        
        var xp = self.view.frame.width / 2 - (250 / 2)
        var hp = self.view.frame.height / 2 - 150

        var seeya = SeeYouLater_View(frame: CGRect(x: xp, y: hp, width: 250, height: 162))
        seeya.alpha = 0
        seeya.fadeIn()
        
        view.addSubview(seeya)
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            // perform segue
            print("Segue to Fridge")
            self.goto_Fridge()
        }
    }
    
    func goto_Fridge(){
        // perform segue
//        self.performSegueWithIdentifier("goto_Fridge", sender: self)
        let realm = try! Realm()
        try! realm.write {
            cUser.last_checked = today
            print("Updated Last Checked Date")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
//        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

public extension UIView {
    
    /**
     Fade in a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeIn(duration duration: NSTimeInterval = 0.9) {
        UIView.animateWithDuration(duration, animations: {
            self.alpha = 1.0
        })
    }
    
    /**
     Fade out a view with a duration
     
     - parameter duration: custom animation duration
     */
    func fadeOut(duration duration: NSTimeInterval = 0.6) {
        UIView.animateWithDuration(duration, animations: {
            self.alpha = 0.0
        })
    }
    
}