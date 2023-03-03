//
//  NoteController.swift
//  RedNotes
//
//  Created by Alexander on 02.03.2023.
//

import UIKit

// MARK: - NoteProtocol

protocol NoteProtocol: AnyObject {
    func changeNote(with text: String,
                    date: String,
                    index: Int)
    func addNote(with text: String,
                 date: String)
    func deleteNote(with index: Int)
}

final class NoteController: UIViewController {
    
    let noteTextView: UITextView = {
        let noteTextView = UITextView()
        noteTextView.backgroundColor = .systemGray6
        noteTextView.font = UIFont(name: "Arial", size: 17)
        return noteTextView
    }()
    
    let index: Int?
    
    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy HH:mm"
        dateFormatter.timeZone = NSTimeZone(name: "UTC +4") as TimeZone?
        return dateFormatter
    }()
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.addTarget(self,
                         action: #selector(saveNote),
                         for: .touchUpInside)
        let image = UIImage(systemName: index != nil ? "square.and.pencil" : "plus")
        button.setImage(image,
                        for: .normal)
        button.tintColor = .red
        button.backgroundColor = .systemPink.withAlphaComponent(0.1)
        button.layer.cornerRadius = 8
        button.isHidden = true
        return button
    }()

    weak var delegate: NoteProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        navigationBar()
    }
    
    init(text: String,
         delegate: NoteProtocol,
         index: Int? = nil) {
        noteTextView.text = text
        
        self.index = index
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func navigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image:
                                                                      UIImage(systemName: "trash"),
                                                                      style: .plain,
                                                                      target: self,
                                                                      action: #selector(deleteNoteButtonAction))
        
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = UIColor.clear
        
        navigationController?.navigationBar.tintColor = .red
        navigationItem.rightBarButtonItem?.isHidden = index == nil
    }
    
    private func setupView() {
        view.addSubview(noteTextView)
        view.backgroundColor = .systemGray6
        view.addSubview(addButton)
        noteTextView.delegate = self
    }
    
    private func setupLayout() {
        noteTextView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(addButton.snp.top).inset(-8)
        }
        
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).inset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(250)
            make.height.equalTo(50)
        }
    }

    @objc
    private func deleteNoteButtonAction() {
        if let index = index {
            delegate?.deleteNote(with: index)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func saveNote() {
        
        let date = dateFormatter.string(from: Date())
        if let index = index {
            delegate?.changeNote(with: noteTextView.text,
                                 date: "\(date)",
                                 index: index)
        } else {
            delegate?.addNote(with: noteTextView.text,
                              date: "\(date)")
        }
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextViewDelegate

extension NoteController: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
       
        if updatedText.isEmpty {
            textView.text = ""
                    addButton.isHidden = true
        } else {
            addButton.isHidden = false
            return true
        }

        return false

    }
}
