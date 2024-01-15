//
//  EditViewController.swift
//  Scanner
//
//  Created by Sona on 15.01.24.
//

import UIKit

class EditViewController: UIViewController {
    
    @IBOutlet weak var editImg: UIImageView!
    
    var img: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configUI()
    }
    
    private func configUI(){
        if let img = img{
            editImg.transform = editImg.transform.rotated(by: .pi / 2)        // 180˚
            editImg.image = img
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
