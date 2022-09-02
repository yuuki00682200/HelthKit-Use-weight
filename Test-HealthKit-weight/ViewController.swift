//
//  ViewController.swift
//  Test-HealthKit-weight
//
//  Created by 髙津悠樹 on 2022/09/02.
//

//import HealthKit
import HealthKit
import UIKit

class ViewController: UIViewController {
    
    var isHealthAvailable : Bool!
    var healthStore : HKHealthStore!

    @IBOutlet weak var GetqueryStatusLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.GetqueryStatusLabel.layer.borderColor = UIColor.blue.cgColor
        self.GetqueryStatusLabel.layer.borderWidth = 1.0
        
    }

    @IBAction func AccessRequest(_ sender: Any) {
        let allTypes = Set([
            HKQuantityType.quantityType(forIdentifier: .bodyMass)!,
            HKQuantityType.quantityType(forIdentifier: .stepCount)!,
        ])

        self.healthStore.requestAuthorization(toShare: allTypes, read: allTypes) { (success, error) in
            var result = ""
            if success {
                result = "allow access: \(String(describing: success))"
            } else {
                result = "\(String(describing: error?.localizedDescription))"
            }
           
        }
    }
 
    
    @IBAction func getBodyweight(_ sender: Any) {
        let start = Calendar.current.date(byAdding: .month, value: -48, to: Date())
        let end = Date()
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end)
        let sampleType = HKQuantityType.quantityType(forIdentifier: .bodyMass)!
        
        let query = HKSampleQuery(
            sampleType: sampleType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: nil) {
            (query, results, error) in
            
            let samples = results as! [HKQuantitySample]
                
            var buf = ""
            for sample in samples {
                // Process each sample here.
                let s = sample.quantity
                print("\(String(describing: sample))")
                
                buf.append("\(sample.startDate) \(String(describing: s))\n")
            }
            
        }
        self.healthStore.execute(query)
    }
}

