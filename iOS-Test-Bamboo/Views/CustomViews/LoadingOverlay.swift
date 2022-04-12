//
//  LoadingOverlay.swift
//  Olango
//
//  Created by Sprinthub on 12/06/2020.
//  Copyright © 2020 Sprinthub. All rights reserved.
//

import UIKit

open class LoadingOverlay {

    var overlayView : UIView!
    var activityIndicator : UIActivityIndicatorView!
    lazy var title: UILabel = {
        let txt = UILabel()
        txt.textAlignment = .center
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()

    lazy var titleView: UIView = {
        let titleView = UIView(frame: .zero)
        titleView.layer.backgroundColor = UIColor.white.cgColor
        titleView.layer.cornerRadius = 10
        titleView.translatesAutoresizingMaskIntoConstraints = false
        return titleView
    }()
    
    var message: NSMutableAttributedString? {
        didSet {
            self.title.attributedText = message
        }
    }

    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }

    init(){
        self.overlayView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.65)
        
        self.activityIndicator = UIActivityIndicatorView(frame: .zero)
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.clipsToBounds = true
        self.activityIndicator.style = .large
        self.activityIndicator.color = .gray
        
        titleView.addViews([self.activityIndicator, title])
        title.anchor(top: titleView.topAnchor, leading: nil, bottom: titleView.bottomAnchor, trailing: nil)
        
        overlayView.addSubview(titleView)
        titleView.anchor(top: nil, leading: overlayView.leadingAnchor, bottom: nil, trailing:   overlayView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50))
        
        NSLayoutConstraint.activate([
            titleView.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor),
            titleView.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            titleView.widthAnchor.constraint(equalToConstant: 300),
            titleView.heightAnchor.constraint(equalToConstant: 80),
            self.activityIndicator.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            self.activityIndicator.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 10),
            self.activityIndicator.heightAnchor.constraint(equalToConstant: 45),
            self.activityIndicator.widthAnchor.constraint(equalToConstant: 45),
            title.centerYAnchor.constraint(equalTo: titleView.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: activityIndicator.trailingAnchor),
            title.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -2)
        ])
    }

    public func showOverlay(view: UIView, title: String? = nil) {
        self.title.text = title ?? "Fetching Information"
        overlayView.center = view.center
        
        view.addSubview(overlayView)
        activityIndicator.startAnimating()
    }

    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
    
}

