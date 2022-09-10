//
//  SuperheroDetailsViewController.swift
//  NewsFlix
//
//  Created by luciano scarpaci on 9/9/22.
//

import UIKit

class SuperheroDetailsViewController: UIViewController {

    
    var movie: [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(movie["title"])
        
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
