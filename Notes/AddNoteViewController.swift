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
    let noteTextTextView = UITextView()
    
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
        
        setupNavigationBar()
        style()
        layout()
        
        // Reading object
        if let note = note {
            noteNameTextField.text = note.noteName
            noteTextTextView.text = note.noteText
        }
    }
    
    @objc func saveTapped() {
        if saveNote() {
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func saveNote() -> Bool {
        if noteNameTextField.text!.isEmpty {
            let alertController = UIAlertController(
                title: "Input Error",
                message: "Please enter note name",
                preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(okAction)
            present(alertController, animated: true)
            
            return false
        }
        
        // create object
        if note == nil {
            note = Note()
        }
        
        if let note = note {
            note.noteName = noteNameTextField.text
            note.noteText = noteTextTextView.text
            CoreDataManager.shared.saveContext()
        }
        
        return true
    }
    
    deinit {
        print("add note end editing")
    }
}

extension AddNoteViewController {
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Add note"
        navigationItem.rightBarButtonItem = saveNoteBarButtonItem
    }
    
    private func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome"
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        
        noteNameTextField.translatesAutoresizingMaskIntoConstraints = false
        noteNameTextField.font = UIFont.preferredFont(forTextStyle: .title1)
        noteNameTextField.placeholder = "Enter note title"
        noteNameTextField.backgroundColor = UIColor(named: "ChatIncomingBubble")
        noteNameTextField.setContentHuggingPriority(UILayoutPriority(251), for: .vertical)
        noteNameTextField.layer.cornerRadius = 10
        noteNameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: noteNameTextField.frame.height))
        noteNameTextField.leftViewMode = .always
        
        noteTextTextView.translatesAutoresizingMaskIntoConstraints = false
        noteTextTextView.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        noteTextTextView.autocapitalizationType = .none
        noteTextTextView.backgroundColor = UIColor(named: "ChatIncomingBubble")
        noteTextTextView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        noteTextTextView.layer.cornerRadius = 10
    }
    
    private func layout() {
        stackView.addArrangedSubview(noteNameTextField)
        stackView.addArrangedSubview(noteTextTextView)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
