//
//  ErrorViewController.swift
//  PopupTransition
//
//  Created by Oleg Tsibulevskiy on 10/05/2020.
//  Copyright © 2020 OTCode. All rights reserved.
//

import UIKit

enum ErrorPopupButtonType
{
    case`default`
    case additional
}

class ErrorViewController: UIViewController
{
    //MARK: - IBOutlets
    @IBOutlet weak var alertView        : UIView!
    @IBOutlet weak var imageError       : UIImageView!
    @IBOutlet weak var labelTitle       : UILabel!
    @IBOutlet weak var labelMessage     : UILabel!
    @IBOutlet weak var buttonConfirm    : UIButton!
    @IBOutlet weak var additionalButton : UIButton!
    
    private var actions                     = [ErrorPopupButtonType : ErrorPopupAction]()
    private var content                     : ErrorPopupContentData?
    private var customTransitioningDelegate : UIViewControllerTransitioningDelegate?
    
    private lazy var defaultButtonConfigurator   : ErrorPopupButtonConfigurator! =
    {
        return ErrorPopupButtonConfigurator(title: "OK", backgroundColor: .red, titleColor: .white)
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        connectActions()
        
        labelTitle.text   = content?.title   ?? ""
        labelMessage.text = content?.message ?? ""
        
        if let labelTitleText = labelTitle.text, labelTitleText.isEmpty
        {
            imageError.isHidden = true
        }
    }
    
    func setupCustomTransitioningDelegate(with delegate: UIViewControllerTransitioningDelegate?)
    {
        customTransitioningDelegate = delegate
        transitioningDelegate       = customTransitioningDelegate
    }
    
    func bind(content: ErrorPopupContentData)
    {
        self.content = content
    }
    
    func addDefaultAction(action: ErrorPopupAction)
    {
        addAction(action: action, type: .default)
    }
    
    func addAdditionalAction(action: ErrorPopupAction)
    {
        addAction(action: action, type: .additional)
    }
}

//MARK: - Private methods
extension ErrorViewController
{
    private func dismissPopup()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func addAction(action: ErrorPopupAction, type: ErrorPopupButtonType)
    {
        switch type
        {
        case .default:
            actions[.default] = action
        case .additional:
            actions[.additional] = action
        }
    }
    
    private func connectActions()
    {
        let actionsArr = actions.compactMap{$0.value}
        
        if actionsArr.count == 0
        {
            bindDefaultButton(action: ErrorPopupAction(configurator: defaultButtonConfigurator, handler: nil))
        }
        
        if let confirmAction = actions[.default]
        {
            bindDefaultButton(action: confirmAction)
        }
        
        if let additionalAction = actions[.additional]
        {
            bindAdditionalButton(action: additionalAction)
        }
    }
    
    private func bindDefaultButton(action: ErrorPopupAction)
    {
        buttonConfirm.setTitle     (action.configurations.title, for: .normal)
        buttonConfirm.setTitleColor(action.configurations.titleColor, for: .normal)
        buttonConfirm.addTarget    (self, action: #selector(confirmButtonAction), for: .touchUpInside)
        buttonConfirm.backgroundColor = action.configurations.backgroundColor
        buttonConfirm.isHidden        = false
        
    }
    
    private func bindAdditionalButton(action: ErrorPopupAction)
    {
        additionalButton.setTitle     (action.configurations.title, for: .normal)
        additionalButton.setTitleColor(action.configurations.titleColor, for: .normal)
        additionalButton.addTarget   (self, action: #selector(additionalButtonAction), for: .touchUpInside)
        additionalButton.backgroundColor = action.configurations.backgroundColor
        additionalButton.isHidden        = false
    }
}
//MARK: - Selectors
extension ErrorViewController
{
    @objc func confirmButtonAction()
    {
        guard let buttonHandler = actions[.default]?.handler else { return dismissPopup() }
        
        buttonHandler?(buttonConfirm, self)
        
        dismissPopup()
    }
    
    @objc func additionalButtonAction()
    {
        guard let buttonHandler = actions[.additional]?.handler else { return dismissPopup() }
        
        buttonHandler?(additionalButton, self)
        
        dismissPopup()
    }
}
