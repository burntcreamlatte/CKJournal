//
//  EntryDetailViewController.swift
//  CKJournal
//
//  Created by Aaron Shackelford on 12/9/19.
//  Copyright © 2019 Aaron Shackelford. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    // MARK: - Properties
    var entry: Entry? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    @IBOutlet weak var entryTextField: UITextField!
    @IBOutlet weak var entryBodyTextView: UITextView!
    
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        entryTextField.delegate = self
        loadViewIfNeeded()
    }
    
    // MARK: - Actions
    @IBAction func saveEntryButtonTapped(_ sender: UIBarButtonItem) {
        
        guard let title = entryTextField.text, !title.isEmpty,
            let bodyText = entryBodyTextView.text, !bodyText.isEmpty else { return }
        
        let entry = Entry(title: title, bodyText: bodyText)
        
        EntryController.shared.addEntryWith(title: entry.title, bodyText: entry.bodyText) { (success) in
            self.updateViews()
        }
        navigationController?.popViewController(animated: true)
    }
    @IBAction func clearTextButtonTapped(_ sender: UIButton) {
        entryTextField.text = ""
        entryBodyTextView.text = ""
    }
    @IBAction func mainViewTapped(_ sender: UITapGestureRecognizer) {
        entryTextField.resignFirstResponder()
        entryBodyTextView.resignFirstResponder()
    }
    
    // MARK: - Helper Methods
    func updateViews() {
        DispatchQueue.main.async {
            self.entryTextField.text = self.entry?.title
            self.entryBodyTextView.text = self.entry?.bodyText
            self.loadViewIfNeeded()
        }
    }
}

extension EntryDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}
