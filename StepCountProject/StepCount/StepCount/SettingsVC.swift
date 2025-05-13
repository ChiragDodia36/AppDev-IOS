//
//  SettingsVC.swift
//  StepCount
//
//  Created by Chirag Dodia on 2025-04-28.
//

import UIKit
import ContactsUI

class SettingsVC: UITableViewController, CNContactPickerDelegate, UITextFieldDelegate {

    @IBOutlet weak var userNameDetailLabel: UILabel!
    @IBOutlet weak var goalTextField: UITextField!
    @IBOutlet weak var notificationsSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        goalTextField.delegate = self
        goalTextField.keyboardType = .numberPad
        addDoneButtonToKeyboard()
        notificationsSwitch.addTarget(self,
                                      action: #selector(notificationsSwitchChanged(_:)),
                                      for: .valueChanged)
        let resetButton = UIButton(type: .system)
        resetButton.setTitle("Reset App", for: .normal)
        resetButton.setTitleColor(.systemRed, for: .normal)
        resetButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        resetButton.addTarget(self, action: #selector(promptForReset), for: .touchUpInside)

        let footer = UIView(frame: CGRect(x: 0, y: 0,
                                          width: tableView.bounds.width,
                                          height: 60))
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        footer.addSubview(resetButton)
        NSLayoutConstraint.activate([
            resetButton.centerXAnchor.constraint(equalTo: footer.centerXAnchor),
            resetButton.centerYAnchor.constraint(equalTo: footer.centerYAnchor)
        ])
        tableView.tableFooterView = footer
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadSettings()
        tableView.reloadData()
    }

    private func addDoneButtonToKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                        target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done,
                                         target: self, action: #selector(doneTapped))
        toolbar.items = [flexSpace, doneButton]
        goalTextField.inputAccessoryView = toolbar
    }

    @objc private func doneTapped() {
        if let text = goalTextField.text, let value = Int(text) {
            saveDailyGoal(value)
        }
        goalTextField.resignFirstResponder()
    }

    private func loadSettings() {
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey: "userName") ?? ""
        userNameDetailLabel.text = name.isEmpty ? "Your Name" : name
        let goal = defaults.integer(forKey: "dailyGoal")
        goalTextField.text = goal > 0 ? "\(goal)" : ""
        notificationsSwitch.isOn = defaults.bool(forKey: "notifyChallenges")
    }
    private func saveDailyGoal(_ goal: Int) {
        UserDefaults.standard.set(goal, forKey: "dailyGoal")
    }
    private func saveNotificationsEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: "notifyChallenges")
        UserDefaults.standard.synchronize()
    }
    @IBAction func goalEditingDidEnd(_ sender: UITextField) {
        if let text = sender.text, let value = Int(text) {
            saveDailyGoal(value)
        }
    }
    @IBAction func notificationsSwitchChanged(_ sender: UISwitch) {
        saveNotificationsEnabled(sender.isOn)
    }
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            let picker = CNContactPickerViewController()
            picker.delegate = self
            picker.displayedPropertyKeys = [CNContactGivenNameKey,
                                            CNContactFamilyNameKey]
            present(picker, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func contactPicker(_ picker: CNContactPickerViewController,
                       didSelect contact: CNContact) {
        let fullName = CNContactFormatter.string(from: contact,
                                                 style: .fullName) ?? ""
        userNameDetailLabel.text = fullName
        UserDefaults.standard.set(fullName, forKey: "userName")
    }
    @objc private func promptForReset() {
        let alert = UIAlertController(
            title: "Reset App?",
            message: "This will clear all your settings and progress. Continue?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            // Clear UserDefaults keys
            let keys = [
                "userName",
                "dailyGoal",
                "notifyChallenges",
                "completedChallenges",
                "lastResetDate",
                "dashboardStartDate",
                "lastDashboardResetDate"
            ]
            let defaults = UserDefaults.standard
            for key in keys {
                defaults.removeObject(forKey: key)
            }
            defaults.synchronize()
            self.loadSettings()
            self.tableView.reloadData()
            if let tab = self.tabBarController {
                if let chVC = tab.viewControllers?.compactMap({ $0 as? ChallengesVC }).first {
                    chVC.clearAllProgress()
                }
                if let dashVC = tab.viewControllers?.compactMap({ $0 as? DashboardVC }).first {
                    dashVC.clearDashboardProgress()
                }
            }
        })
        present(alert, animated: true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
