//
//  ViewController.swift
//  CandyBarTest
//
//  Created by Chris Garbers on 06.07.18.
//  Copyright © 2018 skubo.media. All rights reserved.
//

import UIKit
import CandyBar

class ViewController: UIViewController {

    @IBOutlet weak var Snickers: UIView!
    var candyBarView : CandyBarView!
    
    @IBOutlet weak var sliderView: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        candyBarView = CandyBarView(frame: CGRect(x: 0, y: 0, width: Snickers.frame.size.width, height: Snickers.frame.size.height))
        Snickers.addSubview(candyBarView)
        candyBarView.maximum = 1
        candyBarView.minimum = 0
        candyBarView.current = 0.5
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sliderChanged(_ sender: Any) {
        candyBarView.current = sliderView.value
        
    }
    @IBAction func editChanged(_ sender: UITextField) {
        candyBarView.barTitle.text = sender.text
    }
    
}

