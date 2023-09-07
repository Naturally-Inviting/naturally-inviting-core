import Charts
import Foundation
import SnapshotTesting
import SnapshotTestSupport
import SwiftUI
import XCTest

class AppStoreSnapshotTests: XCTestCase {
    static override func setUp() {
        super.setUp()

        UIApplication.shared.keyWindow?.layer.speed = 100
        UIView.setAnimationsEnabled(false)

        SnapshotTesting.diffTool = "ksdiff"
    }

    override func setUpWithError() throws {
        try super.setUpWithError()

        isRecording = false
    }

    override func tearDown() {
        isRecording = false

        super.tearDown()
    }

    func test_1_Dashboard() {
        assertAppStoreSnapshots(
            for: TestChartView(),
            description: {
                Text("Test")
            },
            backgroundColor: Color.orange,
            colorScheme: .light
        )
    }
}

struct TestChartView: View {
    let players = ["Ozil", "Ramsey", "Laca", "Auba", "Xhaka", "Torreira"]
    let goals = [6, 8, 26, 30, 8, 10]

    var body: some View {
        VStack {
            Chart {
                ForEach(players, id: \.self) { player in
                    LineMark(
                        x: .value("Player", player),
                        y: .value("Scor", 1)
                    )
                }
            }
        }
    }
}
