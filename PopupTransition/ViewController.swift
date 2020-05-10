//
//  ViewController.swift
//  PopupTransition
//
//  Created by Oleg Tsibulevskiy on 10/05/2020.
//  Copyright © 2020 OTCode. All rights reserved.
//

import UIKit

struct CustomError: Error
{
    var description: String
}


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapregularError(_ sender: UIButton)
    {
        let error = CustomError(description: "Description")
        
        showErrorPopup(by: .regularError(error: error, defaultAction: { (button, sender) -> Void? in
            
            print("regularError ok button clicked")
            
        }))
    }
    
    @IBAction func didTapDoubleActionError(_ sender: Any)
    {
        let data = ErrorPopupContentData(title: "Title", message: "Message")
        showErrorPopup(by: .contactUs(data: data, okAction: { (button, sender) -> Void? in
            
            print("contactUs ok button clicked")
            
        }, cotanctUsAction: { (button, sender) -> Void? in
            
            print("contactUs clicked")
            
        }))
    }
    
    public func showErrorPopup(by type: ErrorPopupType)
    {
        guard let errorPopup = PopupFactory.buildErrorPopup(for: type) else { return }
        
        self.present(errorPopup, animated: true, completion: nil)
    }
}



