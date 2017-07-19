//
//  SPItemsDetailViewCtrl.swift
//  DOTA2ShiPing
//
//  Created by wwwbbat on 2017/7/19.
//  Copyright © 2017年 wwwbbat. All rights reserved.
//

import UIKit
import ZLSwipeableViewSwift

class SPItemsDetailViewCtrl: YGBaseViewCtrl {

    override func viewDidLoad() {
        super.viewDidLoad()

        cardContainer.allowedDirection = .Horizontal;
        cardContainer.onlySwipeTopCard = true;
    }
    @IBOutlet weak var cardContainer: ZLSwipeableView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        cardContainer.nextView = {
            return self.nextCardView()
        }
    }
    @IBOutlet var scrollView: UIScrollView!
    
    func nextCardView() -> UIView? {
        
        
        
        let cardView = UIView(frame: cardContainer.bounds)
        
        let r = CGFloat(arc4random_uniform(256)) / 255.0
        let g = CGFloat(arc4random_uniform(256)) / 255.0
        let b = CGFloat(arc4random_uniform(256)) / 255.0
        
        cardView.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
        
        cardView.layer.cornerRadius = 8.0;
        cardView.layer.shadowRadius = 8.0;
        cardView.layer.shadowOpacity = 0.2;
        cardView.layer.shadowColor = cardView.backgroundColor?.cgColor;
        cardView.layer.shouldRasterize = true;
        cardView.layer.rasterizationScale = UIScreen.main.scale;
        
        if scrollView.superview == nil {
            scrollView.frame = CGRect(x: 0, y: 0, width: cardView.bounds.width, height: cardView.bounds.height);
            cardView.addSubview(scrollView);
        }
        
        return cardView
    }
}
