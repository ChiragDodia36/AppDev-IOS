// Project Name: StepCount
// Team Member 1: Chirag Dodia (cpdodia@iu.edu)
// Team Member 2: Shreyas Jadhav (shrejadh@iu.edu)
// Date: 05/06/2025
// Code Author: Chirag Dodia

import UIKit
import CoreMotion
import DGCharts

class DashboardVC: UIViewController {

    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var caloriesLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!

    private let pedometer = CMPedometer()

    private var historyEntries: [ChartDataEntry] = []

    private let baseChallenges: [Challenge] = [
        Challenge(title: "Walk 10 steps", threshold: 10, isComplete: false),
        Challenge(title: "Walk 5,000 steps", threshold: 5_000, isComplete: false),
        Challenge(title: "Walk 10,000 steps", threshold: 10_000, isComplete: false),
        Challenge(title: "Walk 15,000 steps", threshold: 15_000, isComplete: false)
    ]
    private var challenges: [Challenge] {
        var list = baseChallenges
        let daily = UserDefaults.standard.integer(forKey: "dailyGoal")
        if daily > 0 {
            list.insert(Challenge(title: "Daily Goal: \(daily) steps", threshold: daily, isComplete: false), at: 0)
        }
        return list
    }

    private var lastDashboardResetDate: Date {
        get {
            return UserDefaults.standard.object(forKey: "lastDashboardResetDate") as? Date
                ?? Date.distantPast
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "lastDashboardResetDate")
        }
    }
    private var dashboardStartDate: Date {
        get {
            return UserDefaults.standard.object(forKey: "dashboardStartDate") as? Date
                ?? Date()
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "dashboardStartDate")
        }
    }
    private var startDate: Date = Date()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let startOfToday = Calendar.current.startOfDay(for: Date())
        if lastDashboardResetDate < startOfToday {
            dashboardStartDate = Date()
            lastDashboardResetDate = Date()
        }
        startDate = dashboardStartDate
        stepsLabel.text = "0 Steps"
        caloriesLabel.text = "0 Calories Burned"
        let total = challenges.count
        let done  = challenges.filter { _ in false }.count  // initially zero
        completedLabel.text = "\(done) / \(total) Challenges Completed"
        historyEntries = [ChartDataEntry(x: startDate.timeIntervalSince1970, y: 0)]
        let dataSet = LineChartDataSet(entries: historyEntries, label: "Steps")
        dataSet.drawCirclesEnabled = false
        dataSet.mode = .cubicBezier
        chartView.data = LineChartData(dataSet: dataSet)
        startPedometerUpdates()
    }

    private func startPedometerUpdates() {
        guard CMPedometer.isStepCountingAvailable() else {
            stepsLabel.text = "N/A"
            caloriesLabel.text = ""
            return
        }
        pedometer.startUpdates(from: startDate) { [weak self] data, error in
            guard let self = self, let data = data, error == nil else { return }
            DispatchQueue.main.async {
                let steps = data.numberOfSteps.intValue
                let calories = Int(ceil(Double(steps) * 0.04))
                UIView.transition(with: self.stepsLabel,
                                  duration: 0.25,
                                  options: .transitionCrossDissolve) {
                    self.stepsLabel.text = "\(steps) Steps"
                }
                UIView.transition(with: self.caloriesLabel,
                                  duration: 0.25,
                                  options: .transitionCrossDissolve) {
                    self.caloriesLabel.text = "\(calories) Calories Burned"
                }
                let completedCount = self.challenges.filter { steps >= $0.threshold }.count
                let totalCount = self.challenges.count
                self.completedLabel.text = "\(completedCount) / \(totalCount) Challenges Completed"
                let timestamp = Date().timeIntervalSince1970
                self.historyEntries.append(ChartDataEntry(x: timestamp, y: Double(steps)))
                let newDataSet = LineChartDataSet(entries: self.historyEntries, label: "Steps")
                newDataSet.drawCirclesEnabled = false
                newDataSet.mode = .cubicBezier
                self.chartView.data = LineChartData(dataSet: newDataSet)
                self.chartView.notifyDataSetChanged()
            }
        }
    }

    func clearDashboardProgress() {
        let now = Date()
        dashboardStartDate = now
        lastDashboardResetDate = now
        stepsLabel.text = "0 Steps"
        caloriesLabel.text = "0 Calories Burned"
        let total = challenges.count
        completedLabel.text = "0 / \(total) Challenges Completed"
        historyEntries = [ChartDataEntry(x: now.timeIntervalSince1970, y: 0)]
        let dataSet = LineChartDataSet(entries: historyEntries, label: "Steps")
        dataSet.drawCirclesEnabled = false
        dataSet.mode = .cubicBezier
        chartView.data = LineChartData(dataSet: dataSet)
        chartView.notifyDataSetChanged()
        pedometer.stopUpdates()
        startPedometerUpdates()
    }
}
