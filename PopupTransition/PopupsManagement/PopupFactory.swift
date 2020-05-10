//
//  PopupFactory.swift
//  PopupTransition
//
//  Created by Oleg Tsibulevskiy on 10/05/2020.
//  Copyright © 2020 OTCode. All rights reserved.
//


import UIKit

final class PopupFactory
{
    static func buildErrorPopup(for type: ErrorPopupType) -> UIViewController?
    {
        let viewController = ErrorViewController(nibName:"ErrorViewController", bundle: nil)
        viewController.setupCustomTransitioningDelegate(with: PopoverAlertTransition())
        viewController.modalPresentationStyle = .overFullScreen

        switch type
        {
      
        case .contactUs(let data, let okAction, let cotanctUsAction):
            
            viewController.bind(content: data)
            addOKButton(with: okAction, for: viewController)
            addCotancUsButton(with: cotanctUsAction, for: viewController)
            
        case .regularError(let error, let defaultAction):
            
            let data  = ErrorPopupContentData(title: "Title", message: error?.description ?? "" )
            viewController.bind(content: data)
            addOKButton(with: defaultAction, for: viewController)

        }
        
        return viewController
    }
    
    private static func addOKButton(with handler: ErrorPopupButtonHandler?, for viewController: ErrorViewController)
    {
        let configuratorForDefaultButton = ErrorPopupButtonConfigurator(title: "Ok", backgroundColor: .blue, titleColor: .white)
        viewController.addDefaultAction(action: ErrorPopupAction(configurator: configuratorForDefaultButton, handler: handler))
    }
    
    private static func addCotancUsButton(with handler: ErrorPopupButtonHandler?, for viewController: ErrorViewController)
    {
        let configuratorForContactUsButton = ErrorPopupButtonConfigurator(title: "Contact Us", backgroundColor: .blue, titleColor: .white)
        viewController.addAdditionalAction(action: ErrorPopupAction(configurator: configuratorForContactUsButton, handler: handler))
    }
}
