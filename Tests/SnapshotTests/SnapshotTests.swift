import Charts
import Foundation
import SnapshotTesting
import SnapshotTestSupport
import SwiftUI
import XCTest

class AppStoreSnapshotTests: XCTestCase {
    static override func setUp() {
        super.setUp()

        UIView.setAnimationsEnabled(false)

        SnapshotTesting.diffTool = "ksdiff"
    }

    override func setUpWithError() throws {
        try super.setUpWithError()

        isRecording = true
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

    func test_2_List() {
        assertAppStoreSnapshots(
            for: ListTestView(),
            description: {
                Text("Test")
            },
            backgroundColor: Color.orange,
            colorScheme: .light
        )
    }
}

struct ListTestView: View {
    var body: some View {
        List {
            ForEach(0 ..< 50) { item in
                Text("Item - \(item)")
            }
        }
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
