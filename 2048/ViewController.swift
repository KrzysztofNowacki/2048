//
//  ViewController.swift
//  2048
//
//  Created by Krzysiu on 01/08/2019.
//  Copyright © 2019 k.now. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    struct Keys{
        static let savedProfile  = "saved"
        static let savePoints    = "savePoints"
        static let saveScore     = "saveScore"
        static let saveSteps     = "saveSteps"
    }
    let defaults = UserDefaults.standard
    var points = Array(repeating: 0, count: 16)
    
    @IBOutlet weak var box1x1: UIImageView!
    @IBOutlet weak var box1x2: UIImageView!
    @IBOutlet weak var box1x3: UIImageView!
    @IBOutlet weak var box1x4: UIImageView!
    @IBOutlet weak var box2x1: UIImageView!
    @IBOutlet weak var box2x2: UIImageView!
    @IBOutlet weak var box2x3: UIImageView!
    @IBOutlet weak var box2x4: UIImageView!
    @IBOutlet weak var box3x1: UIImageView!
    @IBOutlet weak var box3x2: UIImageView!
    @IBOutlet weak var box3x3: UIImageView!
    @IBOutlet weak var box3x4: UIImageView!
    @IBOutlet weak var box4x1: UIImageView!
    @IBOutlet weak var box4x2: UIImageView!
    @IBOutlet weak var box4x3: UIImageView!
    @IBOutlet weak var box4x4: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    
    var steps = 0
    var score = 0
    
    func addStep(){
        steps+=1
        defaults.set(steps, forKey: Keys.saveSteps)
    }
    func addScore(){
        score+=1
        defaults.set(score, forKey: Keys.saveScore)
    }
    
    func winning(){
        var win = false
        for i in 0...15{
            if points[i] == 11{
                win = true
            }
        }
        if win{
            label.text = "You win in \(steps) steps,\nand get \(score) points"
        }
    }
    
    func changeBoxes(){
        defaults.set(true, forKey: Keys.savedProfile)
        defaults.set(points, forKey: Keys.savePoints)
        box1x1.image = UIImage(named: "box\(points[0])")
        box1x2.image = UIImage(named: "box\(points[1])")
        box1x3.image = UIImage(named: "box\(points[2])")
        box1x4.image = UIImage(named: "box\(points[3])")
        box2x1.image = UIImage(named: "box\(points[4])")
        box2x2.image = UIImage(named: "box\(points[5])")
        box2x3.image = UIImage(named: "box\(points[6])")
        box2x4.image = UIImage(named: "box\(points[7])")
        box3x1.image = UIImage(named: "box\(points[8])")
        box3x2.image = UIImage(named: "box\(points[9])")
        box3x3.image = UIImage(named: "box\(points[10])")
        box3x4.image = UIImage(named: "box\(points[11])")
        box4x1.image = UIImage(named: "box\(points[12])")
        box4x2.image = UIImage(named: "box\(points[13])")
        box4x3.image = UIImage(named: "box\(points[14])")
        box4x4.image = UIImage(named: "box\(points[15])")
        winning()
    }
    
    func addBox(){
        var full = true
        for i in 0...15{
            if points[i] == 0 {
                full = false
            }
        }
        if full {
            score=0
            steps=0
            for i in 0...15{
                points[i] = 0
            }
        }
        var rand = true
        while rand{
            let number = Int.random(in: 0...15)
            if points[number] == 0{
                points[number] = 1
                rand = false
            }
        }
        changeBoxes()
    }
    
    @IBAction func restart(_ sender: UIButton) {
        for i in 0...15{
            points[i] = 0
        }
        changeBoxes()
        score=0
        steps=0
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {self.addBox()})
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let saved = defaults.bool(forKey: Keys.savedProfile)
        if saved{
            points = defaults.array(forKey: Keys.savePoints) as! [Int]
            score = defaults.integer(forKey: Keys.saveScore)
            steps = defaults.integer(forKey: Keys.saveSteps)
        }
        changeBoxes()
        if saved == false{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {self.addBox()})
        }
    }
    @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
        addStep()
        for i in 0...3{
            let j = i*4
            var m = 3
            while m > 0{
                if points[m+j] == 0{
                    var n = m-1
                    while n >= 0{
                        if points[n+j] > 0{
                            points[m+j] = points[n+j]
                            while n > 0{
                                points[n+j] = points[n+j-1]
                                n-=1
                            }
                            points[j] = 0
                        }
                        n-=1
                    }
                }
                m-=1
            }
            m = 3
            while m > 0{
                if points[m+j] == points[m+j-1] && points[m+j] > 0{
                    addScore()
                    points[m+j]+=1
                    var n=m-1
                    while n > 0{
                        points[n+j] = points[n+j-1]
                        n-=1
                    }
                    points[j]=0
                }
                m-=1
            }
        }
        changeBoxes()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {self.addBox()})
    }
    
    @IBAction func swipeLeft(_ sender: UISwipeGestureRecognizer) {
        addStep()
        for i in 0...3{
            let j = i*4
            var m = 0
            while m < 3{
                if points[m+j] == 0{
                    var n = m+1
                    while n <= 3{
                        if points[n+j] > 0{
                            points[m+j] = points[n+j]
                            while n < 3{
                                points[n+j] = points[n+j+1]
                                n+=1
                            }
                            points[j+3] = 0
                        }
                        n+=1
                    }
                }
                m+=1
            }
            m = 0
            while m < 3{
                if points[m+j] == points[m+j+1] && points[m+j] > 0{
                    addScore()
                    points[m+j]+=1
                    var n=m+1
                    while n < 3{
                        points[n+j] = points[n+j+1]
                        n+=1
                    }
                    points[j+3]=0
                }
                m+=1
            }
        }
        changeBoxes()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {self.addBox()})
    }
    
    @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
        addStep()
        for i in 0...3{
            var m = 12+i
            while m > i{
                if points[m] == 0{
                    var n = m-4
                    while n >= i{
                        if points[n] > 0{
                            points[m] = points[n]
                            while n > i{
                                points[n] = points[n-4]
                                n-=4
                            }
                            points[i]=0
                        }
                        n-=4
                    }
                }
                m-=4
            }
            m = 12
            while m > i{
                if points[m+i] == points[m+i-4] && points[m+i] > 0{
                    addScore()
                    points[m+i]+=1
                    var n=m-4
                    while n > i{
                        points[n+i] = points[n+i-4]
                        n-=4
                    }
                    points[i] = 0
                }
                m-=4
            }
        }
        changeBoxes()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {self.addBox()})
    }
    
    @IBAction func swipeUp(_ sender: UISwipeGestureRecognizer) {
        addStep()
        for i in 0...3{
            var m = i
            while m < 12+i {
                if points[m] == 0{
                    var n = m+4
                    while n <= 12+i{
                        if points[n] > 0{
                            points[m] = points[n]
                            while n < i+12{
                                points[n] = points[n+4]
                                n+=4
                            }
                            points[n]=0
                        }
                        n+=4
                    }
                }
                m+=4
            }
            m = i
            while m < i+12{
                if points[m] == points[m+4] && points[m] > 0{
                    addScore()
                    points[m]+=1
                    var n=m+4
                    while n < 12+i{
                        points[n] = points[n+4]
                        n+=4
                    }
                    points[i+12] = 0
                }
                m+=4
            }
        }
        changeBoxes()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {self.addBox()})
    }
    

}

