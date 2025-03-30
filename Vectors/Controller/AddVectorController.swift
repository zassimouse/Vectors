//
//  AddVectorController.swift
//  Vectors
//
//  Created by Denis Haritonenko on 30.03.25.
//

import UIKit

protocol AddVectorDelegate: AnyObject {
    func didAddVector(startX: CGFloat, startY: CGFloat, endX: CGFloat, endY: CGFloat)
}

class AddVectorController: UIViewController {
    
    weak var delegate: AddVectorDelegate?
    
    private let label1: UILabel = {
        let label = UILabel()
        label.text = "(x1; y1)"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let label2: UILabel = {
        let label = UILabel()
        label.text = "(y1; y2)"
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    private let textFieldX1: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let textFieldY1: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let textFieldX2: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let textFieldY2: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить", for: .normal)
        button.backgroundColor = .systemGray
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.isEnabled = false
        return button
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let inputStackView1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let inputStackView2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
    
        [textFieldX1, textFieldY1, textFieldX2, textFieldY2].forEach {
            $0.delegate = self
            view.addSubview($0)
        }
        
        view.addSubview(verticalStackView)
        view.addSubview(addButton)
        
        verticalStackView.addArrangedSubview(label1)
        verticalStackView.addArrangedSubview(inputStackView1)
        verticalStackView.addArrangedSubview(label2)
        verticalStackView.addArrangedSubview(inputStackView2)
        
        inputStackView1.addArrangedSubview(textFieldX1)
        inputStackView1.addArrangedSubview(textFieldY1)
        
        inputStackView2.addArrangedSubview(textFieldY2)
        inputStackView2.addArrangedSubview(textFieldX2)
        
        setupConstraints()
        
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            addButton.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 24),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    @objc private func addButtonTapped() {
        print("add tapped")
        guard let x1 = Double(textFieldX1.text?.replacingOccurrences(of: ",", with: ".") ?? ""),
              let y1 = Double(textFieldX1.text?.replacingOccurrences(of: ",", with: ".") ?? ""),
              let x2 = Double(textFieldX1.text?.replacingOccurrences(of: ",", with: ".") ?? ""),
              let y2 = Double(textFieldX1.text?.replacingOccurrences(of: ",", with: ".") ?? "") else { return }
        
        delegate?.didAddVector(startX: CGFloat(x1), startY: CGFloat(y1), endX: CGFloat(x2), endY: CGFloat(y2))
        dismiss(animated: true)
    }
    
    private func isValidInput(_ text: String) -> Bool {
        let regex = "^(?!0\\d)(\\d+|\\d*\\,\\d+)$" // Regex to match numbers like 12.34 or 12345
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: text)
    }
    
    private func updateButtonState() {
        let allFieldsValid = [textFieldX1, textFieldY1, textFieldX2, textFieldY2].allSatisfy { textField in
            guard let text = textField.text else { return false }
            return isValidInput(text)
        }
        
        addButton.isEnabled = allFieldsValid
        addButton.backgroundColor = allFieldsValid ? .systemBlue : .systemGray
    }
}

extension AddVectorController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)

        // Prevent starting with a comma
        if newText.first == "," {
            return false
        }

        // Allow only one comma
        let commaCount = newText.filter { $0 == "," }.count
        if commaCount > 1 {
            return false
        }

        return true
    }

    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        updateButtonState()
    }
}
