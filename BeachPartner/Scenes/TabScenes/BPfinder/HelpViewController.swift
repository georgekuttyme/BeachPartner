//
//  HelpViewController.swift
//  BeachPartner
//
//  Created by seq-mary on 21/04/18.
//  Copyright © 2018 dev. All rights reserved.
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
        imageArray.append(UIImage(named: "BP-Guide-home--v6")!)
        imageArray.append(UIImage(named: "BP-Guide-home-2-v6")!)
        imageArray.append(UIImage(named: "BP-Guide-BP---finder-v6")!)
        imageArray.append(UIImage(named: "BP-Guide-events-v6")!)
        
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
             dismiss(animated: true, completion: nil)
        
         }
}
