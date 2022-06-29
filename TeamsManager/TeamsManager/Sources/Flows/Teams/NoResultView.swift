//
//  NoResult.swift
//  TeamsManager
//
//  Created by Sergey Vysotsky on 28.06.2022.
//

import Foundation
import UIKit

class NoResultView {
    
    private var mainView = UIView()
    
    init(view: UIView) {
        mainView = view
    }
    
    public func configureNoResult() -> UIView {

        let viewResult = makeView()
        mainView.addSubview(viewResult)

        let stackView = makeStackView()
        stackView.addArrangedSubview(makeLabel())
        stackView.addArrangedSubview(makeImageView())
        stackView.translatesAutoresizingMaskIntoConstraints = false
        viewResult.addSubview(stackView)

        //Constraints
        stackView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        
        return mainView
    }

}

// MARK: - Factory
extension NoResultView {
    func makeView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: mainView.frame.width, height: mainView.frame.height))
        view.backgroundColor = UIColor.white
        view.tag = 100
        return view
    }

    func makeImageView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(named: "NoResult.png"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }

    func makeLabel() -> UILabel {
        let label = UILabel()
        label.text = "No result"
        return label
    }

    func makeStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 16.0
        return stackView
    }
}
