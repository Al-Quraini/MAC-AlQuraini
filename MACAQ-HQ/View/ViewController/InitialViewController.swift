//
//  ViewController.swift
//  MACAQ-HQ
//
//  Created by Mohammed Al-Quraini on 2/11/22.
//

import UIKit

class InitialViewController: UIViewController {
    
    // text field
    private lazy var textField : UITextField = {
        let textField = UITextField()
        textField.returnKeyType = .done
        textField.leftViewMode = .always
        textField.backgroundColor = .systemGray6
        textField.placeholder = "Enter Your Name Here!"
        textField.layer.cornerRadius = 10
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.masksToBounds = true
        textField.textColor = .black
        textField.tintColor = .black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        let color = UIColor.placeholderText
        textField.attributedPlaceholder =
        NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : color])
        let imageContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 40))
        textField.leftViewMode = .always
        textField.font = UIFont.systemFont(ofSize: 12)
        textField.leftView = imageContainerView
        
        return textField
    }()
    
    // button
    private lazy var button : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
            
        return button
    }()
    
    private var name = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // add subviews
        subviewsAdd()
    }
    
    // did layout subviews
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // safe area
        let safeArea = view.safeAreaLayoutGuide
        
        // text field constraints
        textField.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor).isActive = true
        textField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20).isActive = true
        textField.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -10).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // button constraints
        button.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20).isActive = true
        button.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }


    // add subviews
    @objc private func subviewsAdd(){
        view.addSubview(textField)
        view.addSubview(button)
    }
    
    // button pressed
    @objc private func buttonPressed(){
        self.textField.endEditing(true)
        if name.count < 3 {
            displayAlert()
            return
        }
        navigateToNextPage()
        
    }
    
    
    // display alert
    private func displayAlert(){
        let alert = UIAlertController(title: "Invalid Name", message: "Please enter more than three letters!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // navigate
    private func navigateToNextPage(){
        let detailVC = MoviesViewController(name: name)
        detailVC.modalPresentationStyle = .fullScreen
        detailVC.modalTransitionStyle = .partialCurl
        navigationController?.setViewControllers([detailVC], animated: true)
    }
    
}

//MARK: - UITextFieldDelegate
extension InitialViewController : UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textField {
            textField.text = ""
            textField.endEditing(true)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text{
            name = text
        }
    }
   
}

