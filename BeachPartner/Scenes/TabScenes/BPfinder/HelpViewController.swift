//
//  HelpViewController.swift
//  BeachPartner
//
//  Created by Beach Partner LLC on 21/04/18.
//  Copyright © 2018 Beach Partner LLC. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController,UIScrollViewDelegate {

    @IBOutlet weak var btnSkip: UIButton!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    var imageArray = [UIImage]()
    var contentWidth:CGFloat = 0.0
    var currentContentOffset: CGFloat = 0.0
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
    
        mainScrollView.isPagingEnabled = true
        mainScrollView.delegate = self
        imageArray.append(UIImage(named: "home-1")!)
        imageArray.append(UIImage(named: "home-2")!)
        imageArray.append(UIImage(named: "home-3")!)
        imageArray.append(UIImage(named: "home-4")!)
        imageArray.append(UIImage(named: "Image5")!)
        imageArray.append(UIImage(named: "Image6")!)
        imageArray.append(UIImage(named: "Image7")!)
        imageArray.append(UIImage(named: "messages-v3")!)
        imageArray.append(UIImage(named: "High-fives-v3")!)
     
        
        print(imageArray);
        pageControl.numberOfPages = imageArray.count
        for i in 0..<imageArray.count{
            let imageView = UIImageView()
            imageView.image = imageArray[i]
            let xPosition = self.view.frame.width * CGFloat(i)
            
            imageView.frame = CGRect(x:xPosition,y:0,width:UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height)
            mainScrollView.contentSize.width = UIScreen.main.bounds.size.width * CGFloat(i + 1)
            mainScrollView.addSubview(imageView)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(mainScrollView.contentOffset.x / CGFloat (UIScreen.main.bounds.size.width))
         currentContentOffset = mainScrollView.contentOffset.x
        print(pageControl.currentPage)
        if  pageControl.currentPage+1 == imageArray.count {
            btnSkip.isHidden = true
            btnNext.setTitle("Got It", for: .normal)
            
        }
        else{
            btnSkip.isHidden = false
            btnNext.setTitle("Next", for: .normal)
        }
        
    }
    

    @IBAction func nextBtnClicked(_ sender: Any) {
        
        print(currentContentOffset)
        print(mainScrollView.contentSize.width)
        
        if currentContentOffset < mainScrollView.contentSize.width - mainScrollView.frame.width {

            currentContentOffset = currentContentOffset + mainScrollView.frame.width
        }
        else if  pageControl.currentPage+1 == imageArray.count  {
            dismiss(animated: true, completion: nil)
        }

        self.mainScrollView.contentOffset = CGPoint(x: currentContentOffset, y: 0)

    }
    @IBAction func skipBtnClicked(_ sender: Any) {
        print("====+++ ",pageControl.currentPage)
        if pageControl.currentPage == 0 {
            dismiss(animated: true, completion: nil)
        }
        if currentContentOffset < mainScrollView.contentSize.width + mainScrollView.frame.width {
            print("==== ",pageControl.currentPage," ==== ",currentContentOffset," ==== ")
            currentContentOffset = currentContentOffset - mainScrollView.frame.width
            self.mainScrollView.contentOffset = CGPoint(x: currentContentOffset, y:0)
        }
         }
}
