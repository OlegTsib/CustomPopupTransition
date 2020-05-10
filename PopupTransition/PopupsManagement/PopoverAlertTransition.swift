//
//  ErrorPopupType.swift
//  PopupTransition
//
//  Created by Oleg Tsibulevskiy on 10/05/2020.
//  Copyright © 2020 OTCode. All rights reserved.
//

import UIKit

class PopoverAlertTransition: NSObject
{
    // MARK: - Public Properties
    var animationDuration = TimeInterval(0.5)
    var backgroundColor: UIColor
    
    // MARK: - Private Properties
    private var isPresenting          = true
    private var floatZero             = CGFloat(0.0)
    private var springWithDamping     = CGFloat(0.7)
    private var initialSpringVelocity = CGFloat(0.5)
    
    private var dimmedBackground     : UIView?
    
    init(backgroundColor: UIColor = .black)
    {
        self.backgroundColor = backgroundColor
        super.init()
    }
}

//MARK: - UIViewControllerTransitioningDelegate
extension PopoverAlertTransition: UIViewControllerTransitioningDelegate
{
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresenting = true
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        isPresenting = false
        return self
    }
}

//MARK: - UIViewControllerAnimatedTransitioning
extension PopoverAlertTransition: UIViewControllerAnimatedTransitioning
{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval
    {
        return animationDuration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning)
    {
        switch isPresenting
        {
        case true : animateTransitionForPresentation(transitionContext)
        case false: animateTransitionForDismissal   (transitionContext)
        }
    }
}

// MARK: - Private methods
extension PopoverAlertTransition
{
    func animateTransitionForPresentation(_ transitionContext: UIViewControllerContextTransitioning)
    {
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else
        {
            transitionContext.completeTransition(transitionContext.transitionWasCancelled)
            return
        }
        
        let containerView       = transitionContext.containerView
        
        dimmedBackground                  = UIView(frame: containerView.bounds)
        dimmedBackground?.backgroundColor = backgroundColor
        dimmedBackground?.alpha           = floatZero
        
        guard let dimmedBackground = dimmedBackground else {
            transitionContext.completeTransition(transitionContext.transitionWasCancelled)
            return
        }
        
        containerView.addSubview(dimmedBackground)
        containerView.addSubview(toView)
        
        toView.alpha     = floatZero
        toView.frame     = containerView.bounds
        toView.transform = CGAffineTransform(scaleX: CGFloat(0.1), y: CGFloat(0.1))
        
        let targetAffineTransform = CGAffineTransform.identity
        
        
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: springWithDamping, initialSpringVelocity: initialSpringVelocity, options: .allowUserInteraction, animations: {
            
            dimmedBackground.alpha = CGFloat(0.5)
            
            toView.transform = targetAffineTransform
            toView.alpha = CGFloat(1.0)
            
        }, completion: { (success) in
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
    func animateTransitionForDismissal   (_ transitionContext: UIViewControllerContextTransitioning)
    {
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else
        {
            transitionContext.completeTransition(transitionContext.transitionWasCancelled)
            return
        }
        
        guard let dimmedBackground = dimmedBackground else
        {
            transitionContext.completeTransition(transitionContext.transitionWasCancelled)
            return
        }
        
        let targetAffineTransform = CGAffineTransform(scaleX: CGFloat(0.1), y: CGFloat(0.1))
        
        /// Animate the transition
        UIView.animate(withDuration: animationDuration, delay: 0.0, usingSpringWithDamping: springWithDamping, initialSpringVelocity: initialSpringVelocity, options: [], animations: { [weak self] in
            
            guard let weakSelf = self else { return }
            
            fromView.alpha         = weakSelf.floatZero
            fromView.transform     = targetAffineTransform
            
            dimmedBackground.alpha = weakSelf.floatZero
            
        }) { [weak self] (finished) in
            
            dimmedBackground.removeFromSuperview()
            self?.dimmedBackground = nil
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
