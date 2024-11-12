//
//  PracticeTableViewCell.swift
//  Meditation
//
//  Created by Karen Khachatryan on 25.10.24.
//

import UIKit

class PracticeTableViewCell: UITableViewCell {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var smileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        dateLabel.font = .interRegular(size: 20)
        bgView.layer.cornerRadius = 3
        bgView.layer.borderWidth = 1
        bgView.layer.borderColor = #colorLiteral(red: 0.5176470588, green: 0.5450980392, blue: 0.662745098, alpha: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func formatTimeInterval(_ time: Int64) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return "\(minutes) min \(seconds) sec"
    }
    
    func setupData(practice: PracticeModel) {
        dateLabel.text = "\(practice.date?.toString() ?? Date().toString()) \(formatTimeInterval(practice.duration ?? 0))"
        let smile = "smile\(practice.feelings ?? 0)"
        smileImageView.image = UIImage(named: smile)
    }
    
}
