//
//  SearchViewController.swift
//  BreweryFinder
//
//  Created by Jason Allen on 7/18/19.
//  Copyright © 2019 Jason Allen. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    var searchTextString = "Hi"

    @IBOutlet weak var searchText: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchText.text = searchTextString
        

        // Do any additional setup after loading the view.
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
