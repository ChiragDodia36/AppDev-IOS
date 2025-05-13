// Project Name: StepCount
// Team Member 1: Chirag Dodia (cpdodia@iu.edu)
// Team Member 2: Shreyas Jadhav (shrejadh@iu.edu)
// Date: 05/06/2025
// Code Author: Chirag Dodia

import UIKit
import CoreMotion

struct Challenge {
    let title: String
    let threshold: Int
    var isComplete: Bool
}

class ChallengesVC: UITableViewController {

    private let baseChallenges: [Challenge] = [
        Challenge(title: "Walk 10 steps", threshold: 10, isComplete: false),
        Challenge(title: "Walk 5,000 steps", threshold: 5_000, isComplete: false),
        Challenge(title: "Walk 10,000 steps", threshold: 10_000, isComplete: false),
        Challenge(title: "Walk 15,000 steps", threshold: 15_000, isComplete: false)
    ]
    private var challenges: [Challenge] = []
    private var completedThresholds: Set<Int> {
        get {
            let saved = UserDefaults.standard.array(forKey: "completedChallenges") as? [Int] ?? []
            return Set(saved)
        }
        set {
            UserDefaults.standard.set(Array(newValue), forKey: "completedChallenges")
        }
    }
    private var lastResetDate: Date {
        get {
            return UserDefaults.standard.object(forKey: "lastResetDate") as? Date ?? Date.distantPast
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastResetDate")
        }
    }
    private let pedometer = CMPedometer()
    private var launchDate: Date = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Challenges"
        view.backgroundColor = .systemBackground
        resetDailyCompletionIfNeeded()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChallengeCell")
        tableView.tableFooterView = UIView()
        tableView.allowsSelection = false
        launchDate = Date()
        reloadChallenges()
        tableView.reloadData()
        startPedometerUpdates()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadChallenges()
        tableView.reloadData()
    }

    private func startPedometerUpdates() {
        guard CMPedometer.isStepCountingAvailable() else { return }
        
        pedometer.startUpdates(from: launchDate) { [weak self] data, error in
            guard
                let self = self,
                let data = data,
                error == nil
            else { return }
            
            let steps = data.numberOfSteps.intValue
            
            DispatchQueue.main.async {
                self.resetDailyCompletionIfNeeded()
                self.reloadChallenges()
                for index in 0..<self.challenges.count {
                    if !self.challenges[index].isComplete && steps >= self.challenges[index].threshold {
                        self.challenges[index].isComplete = true
                        var set = self.completedThresholds
                        set.insert(self.challenges[index].threshold)
                        self.completedThresholds = set
                    }
                }
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges.count
    }
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeCell", for: indexPath)
        let challenge = challenges[indexPath.row]
    
        cell.textLabel?.text = challenge.title
        cell.accessoryType = challenge.isComplete ? .checkmark : .none
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17)
        cell.textLabel?.textColor = .label
        return cell
    }
    private func reloadChallenges() {
        var list = baseChallenges
        let daily = UserDefaults.standard.integer(forKey: "dailyGoal")
        if daily > 0 {
            let title = "Daily Goal: \(daily) steps"
            let wasComplete = completedThresholds.contains(daily)
            list.insert(Challenge(title: title, threshold: daily, isComplete: wasComplete), at: 0)
        }
        list = list.map { ch in
            var copy = ch
            copy.isComplete = completedThresholds.contains(ch.threshold)
            return copy
        }
        challenges = list
    }
    
    private func resetDailyCompletionIfNeeded() {
        let startOfToday = Calendar.current.startOfDay(for: Date())
        // Only reset once per day
        if lastResetDate < startOfToday {
            let daily = UserDefaults.standard.integer(forKey: "dailyGoal")
            var set = completedThresholds
            set.remove(daily)
            completedThresholds = set
            lastResetDate = Date()
        }
    }

    func clearAllProgress() {
        UserDefaults.standard.removeObject(forKey: "completedChallenges")
        UserDefaults.standard.removeObject(forKey: "lastResetDate")
        launchDate = Date()
        resetDailyCompletionIfNeeded()
        reloadChallenges()
        tableView.reloadData()
    }
}
