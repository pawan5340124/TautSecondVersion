//
//  TutorialScreen.swift
//  SecondTaut
//
//  Created by Matrix Marketers on 21/08/19.
//  Copyright © 2019 pawan. All rights reserved.
//

import UIKit
import MyBaby


class TutorialScreen: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    //MARK: - Outlet
    @IBOutlet weak var viewSignInButton: UIView!
    @IBOutlet weak var viewGetStartedButton: UIView!
    @IBOutlet weak var PageControllerCUrrentPage: UIPageControl!
    @IBOutlet weak var CollectionViewTutorial: UICollectionView!
    var WelcomeScreenPresent : String = ""

    
    var ImageArray : NSArray = [UIImage.init(named: "tutorial1") as Any,UIImage.init(named: "tutorial2") as Any,UIImage.init(named: "tutorial3") as Any]
    var TitleArray = ["Taut Team Communication","Talk to your project team","Easily Getting Started"]
    var descriptionArray = ["The Easiest way of instant messaging on your fingertips. Connect with your colleagues and sharing a files anytime any where!","You can easily handle your project in taut team with sharing a project details and images etc","Create your user and team name, add coworkers and you are in taut"]
    
    //MARK: - Basic Function
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SetUI()
       
        // Do any additional setup after loading the view.
    }


    
    override func viewWillAppear(_ animated: Bool) {
        WelcomeScreenPresent = "PRESENT"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        WelcomeScreenPresent = "NotPRESENT"
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if  WelcomeScreenPresent == "PRESENT"{
            CollectionViewTutorial.contentOffset.x = 0
            self.CollectionViewTutorial.reloadData()
        }
    }
    
    
    func SetUI(){
        let nib = UINib(nibName: "WelcomeCollectionViewCell", bundle: nil)
        CollectionViewTutorial?.register(nib, forCellWithReuseIdentifier: "WelcomeCollectionViewCell")
        CollectionViewTutorial.delegate = self
        CollectionViewTutorial.dataSource = self
        CollectionViewTutorial.reloadData()
        PageControllerCUrrentPage.numberOfPages = 3
        PageControllerCUrrentPage.currentPage = 0
        
        self.viewSignInButton.layer.cornerRadius = 6
        self.viewGetStartedButton.layer.cornerRadius = 6
        self.viewSignInButton.layer.borderWidth = 1
        self.viewSignInButton.layer.borderColor = UIColor.init(red: 96/255, green: 101/255, blue: 143/255, alpha: 1).cgColor
        
        self.viewSignInButton.layer.cornerRadius = 6
 
    }

    //MARK: - ButtonAction
    @IBAction func btnGetStarted(_ sender: Any) {
        let Instace = self.storyboard?.instantiateViewController(withIdentifier: "SignUpEmail") as! SignUpEmail
        self.navigationController?.pushViewController(Instace, animated: true)
        
        
    }
    @IBAction func btnSignIN(_ sender: Any) {
        let Instace = self.storyboard?.instantiateViewController(withIdentifier: "TeamUrlSignIN") as! TeamUrlSignIN
        self.navigationController?.pushViewController(Instace, animated: true)
    }
    
    //MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ImageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = CollectionViewTutorial.dequeueReusableCell(withReuseIdentifier: "WelcomeCollectionViewCell", for: indexPath) as! WelcomeCollectionViewCell
        
        cell.imgWelcome.image = ImageArray[indexPath.row] as? UIImage
        cell.lblTitle.text = TitleArray[indexPath.row]
        cell.lblDescription.text = descriptionArray[indexPath.row]
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CollectionViewTutorial.layer.frame.width, height: CollectionViewTutorial.layer.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == CollectionViewTutorial {
            let witdh = scrollView.frame.width - (scrollView.contentInset.left*2)
            let index = scrollView.contentOffset.x / witdh
            let roundedIndex = round(index)
            PageControllerCUrrentPage.currentPage = Int(roundedIndex)
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



extension UIViewController {
    
    func LaunchEmailApp(){
        
        let url = NSURL(string: "message://")
        UIApplication.shared.openURL(url! as URL)

    }
    
}



