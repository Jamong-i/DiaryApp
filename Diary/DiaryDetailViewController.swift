//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Jamong on 2022/12/30.
//

import UIKit


class DiaryDetailViewController: UIViewController {

	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var contentsTextView: UITextView!
	@IBOutlet var dateLabel: UILabel!
	var startButton: UIBarButtonItem?
	
	var diary: Diary?
	var indexPath: IndexPath?
	
	
	override func viewDidLoad() {
        super.viewDidLoad()
		self.configureView()
    }
	
	private func configureView() {
		guard let diary = self.diary else { return }
		self.titleLabel.text = diary.title
		self.contentsTextView.text = diary.contents
		self.dateLabel.text = dateToString(date: diary.date)
		self.startButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapStarButton))
		self.startButton?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
		self.startButton?.tintColor = .orange
		self.navigationItem.rightBarButtonItem = self.startButton
	}
	
	private func dateToString(date: Date) -> String {
		let formatter = DateFormatter()
		formatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
		formatter.locale = Locale(identifier: "ko_KR")
		return formatter.string(from: date)
	}
	
	@objc func editDiaryNotification(_ notification: Notification) {
		guard let diary = notification.object as? Diary else { return }
		guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
		self.diary = diary
		self.configureView()
	}
	
	@IBAction func tapEditButton(_ sender: UIButton) {
		guard let viewController = self.storyboard?.instantiateViewController(identifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }
		guard let indexPath = self.indexPath else { return }
		guard let diary = self.diary else { return }
		viewController.diaryEditorMode = .edit(indexPath, diary)
		NotificationCenter.default.addObserver(self, selector: #selector(editDiaryNotification(_ :)), name: NSNotification.Name("editDiary"), object: nil)
		self.navigationController?.pushViewController(viewController, animated: true)
	}
	
	@IBAction func tapDeleteButton(_ sender: UIButton) {
		guard let indexPath = self.indexPath else { return }
		NotificationCenter.default.post(name: NSNotification.Name("deleteDiary"), object: indexPath, userInfo: nil)
		self.navigationController?.popViewController(animated: true)
	}
	
	@objc func tapStarButton() {
		guard let isStar = self.diary?.isStar else { return }
		guard let indexPath = self.indexPath else { return }
		
		if isStar {
			self.startButton?.image = UIImage(systemName: "Star")
		} else {
			self.startButton?.image = UIImage(systemName: "star.fill")
		}
		self.diary?.isStar = !isStar
		NotificationCenter.default.post(
			name: NSNotification.Name("starDiaty"),
			object: [
				"isStar": self.diary?.isStar ?? false,
				"indexPath": indexPath
			],
			userInfo: nil)
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
}
