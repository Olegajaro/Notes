//
//  AddNoteViewController.swift
//  Notes
//
//  Created by Олег Федоров on 25.02.2022.
//

import UIKit

class AddNoteViewController: UIViewController {
    
    let stackView = UIStackView()
    let label = UILabel()
    let noteNameTextField = UITextField()
    let noteTextTextField = UITextField()
    
    lazy var saveNoteBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(saveTapped)
        )
        
        barButtonItem.tintColor = .label
        return barButtonItem
    }()
    
    var note: Note?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
        navigationItem.rightBarButtonItem = saveNoteBarButtonItem
    }
    
    @objc func saveTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension AddNoteViewController {
    private func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        
        noteNameTextField.translatesAutoresizingMaskIntoConstraints = false
        noteNameTextField.placeholder = "Enter note title"
        
        noteTextTextField.translatesAutoresizingMaskIntoConstraints = false
        noteTextTextField.placeholder = "Enter note text"
    }
    
    private func layout() {
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(noteNameTextField)
        stackView.addArrangedSubview(noteTextTextField)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
