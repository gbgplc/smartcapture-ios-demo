import Foundation
import UIKit

extension FaceCameraHomeViewController {
    
    enum Constants {
        static let logoName: String = "gbg-logo"
        static let buttonPadding: CGFloat = 20.0
        static let imageRatioMultiplier: CGFloat = 0.5
        static let buttonTitle: String = "Start"
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: Constants.logoName)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Constants.buttonTitle, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        view.addSubview(imageView)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: Constants.imageRatioMultiplier),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1.0),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            button.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.buttonPadding),
            button.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        ])
    }
    
    @objc
    private func buttonTapped(_ sender: Any) {
        startFaceCamera()
    }
}
