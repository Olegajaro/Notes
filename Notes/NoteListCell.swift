//
//  NoteListCell.swift
//  Notes
//
//  Created by Олег Федоров on 25.02.2022.
//

import UIKit

class NoteListCell: UITableViewCell {
    
    
    static let cellID = "NoteListCell"
    static let rowHeight: CGFloat = 70
    
    var noteNameLabel = UILabel()
    var noteTextLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = UIColor(named: "CellColor")
        
        noteNameLabel.translatesAutoresizingMaskIntoConstraints = false
        noteNameLabel.font = UIFont.preferredFont(forTextStyle: .title2)
        
        noteTextLabel.translatesAutoresizingMaskIntoConstraints = false
        noteTextLabel.font = UIFont.preferredFont(forTextStyle: .body)
        noteTextLabel.textColor = .lightGray
        
        contentView.addSubview(noteNameLabel)
        contentView.addSubview(noteTextLabel)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            noteNameLabel.topAnchor.constraint(
                equalToSystemSpacingBelow: topAnchor, multiplier: 1
            ),
            noteNameLabel.leadingAnchor.constraint(
                equalToSystemSpacingAfter: leadingAnchor, multiplier: 2
            ),
            trailingAnchor.constraint(
                equalToSystemSpacingAfter: noteNameLabel.trailingAnchor,
                multiplier: 2
            )
        ])
        
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(
                equalToSystemSpacingBelow: noteTextLabel.bottomAnchor,
                multiplier: 1
            ),
            noteTextLabel.leadingAnchor.constraint(
                equalToSystemSpacingAfter: leadingAnchor, multiplier: 2
            ),
            trailingAnchor.constraint(
                equalToSystemSpacingAfter: noteTextLabel.trailingAnchor,
                multiplier: 2
            )
        ])
    }
}
