//
//  DogeCoinTrackerViewController.swift
//  DogeCoinTracker
//
//  Created by Abraham Estrada on 5/11/21.
//

import UIKit

class DogeCoinTrackerViewController: UIViewController {
    
    // MARK: - Properties
    
    private var priceService = DogeCoinPriceService()
    
    private let dogeImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "doge")
        iv.alpha = 0
        iv.transform = CGAffineTransform.init(rotationAngle: 30)
        iv.contentMode = .scaleAspectFit
        iv.setDimensions(height: 250, width: 250)
        return iv
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        return label
    }()
    
    private lazy var refreshButton: UIButton = {
        let button = UIButton()
        button.setTitle("Refresh", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.6771411896, green: 0.4405295849, blue: 0.01948912814, alpha: 1)
        button.layer.cornerRadius = 10
        button.setDimensions(height: 30, width: 125)
        button.center.y += 50
        button.alpha = 0
        button.addTarget(self, action: #selector(handleRefreshTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureGradientLayer()
        
        let stack = UIStackView(arrangedSubviews: [dogeImageView, priceLabel])
        stack.axis = .vertical
        stack.alignment = .center
        view.addSubview(stack)
        stack.center(inView: view)
        
        view.addSubview(refreshButton)
        refreshButton.anchor(top: stack.bottomAnchor, paddingTop: 24)
        refreshButton.centerX(inView: view)
        
        priceService.delegate = self
        priceService.fetchPrice()
        
        animateViewsForStartup()
    }
    
    // MARK: - Actions
    
    @objc func handleRefreshTapped() {
        priceService.fetchPrice()
        animatePriceLabel()
    }
    
    // MARK: - Helpers
    
    func animateViewsForStartup() {
        UIView.animate(withDuration: 1.2, delay: 0.2, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.dogeImageView.alpha = 1
            self.dogeImageView.transform = CGAffineTransform.init(rotationAngle: 0)
            self.priceLabel.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            self.refreshButton.center.y -= 50
            self.refreshButton.alpha = 1
        }, completion: nil)
    }
    
    func animatePriceLabel() {
        UIView.animate(withDuration: 1.2, delay: 0.2, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.priceLabel.transform = CGAffineTransform.init(scaleX: 2, y: 2)
        }, completion: nil)
        UIView.animate(withDuration: 1.2, delay: 0.2, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
            self.priceLabel.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        }, completion: nil)
    }
}

// MARK: - DogeCoinPriceServiceDelegate

extension DogeCoinTrackerViewController: DogeCoinPriceServiceDelegate {
    func didFetchPrice(price: Double) {
        DispatchQueue.main.async {
            let roundedPrice = String(format: "%.5f", price)
            self.priceLabel.text = "\(roundedPrice)$ USD"
        }
    }
}
