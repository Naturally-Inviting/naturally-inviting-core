import ComposableArchitecture
import ComposableStoreKit
import NaturalDesignSystem
import StoreKit
import SwiftUI
import TCACustomAlert
import UserDefaultsClient

private let appRatingUserDefaultsKey = "com.naturally_inviting_appRatingUserDefaultsKey"

@Reducer
public struct AppRatingFeature: Reducer {
    @ObservableState
    public struct State: Equatable {
        var alertState: CustomTcaAlert.State = .init(
            endScrimOpacity: 0.4
        )

        public init() {}
    }
    
    public enum Action: Equatable {
        case task
        case alert(CustomTcaAlert.Action)
        case yesActionTapped
        case noActionTapped
    }
    
    @Dependency(\.calendar) var calendar
    @Dependency(\.continuousClock) var continuousClock
    @Dependency(\.date) var date
    @Dependency(\.storeKit.requestStoreReview) var requestStoreReview
    @Dependency(\.userDefaults) var userDefaults
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        Reduce<State, Action> { state, action in
            switch action {
            case .task:
                return determinePresentsEffect()
                
            case .yesActionTapped:
                return acceptReviewEffect()
                
            case .noActionTapped:
                return dismissReviewEffect()
                
            default:
                return .none
            }
        }
        
        Scope(state: \.alertState, action: \.alert) {
            CustomTcaAlert()
        }
    }
    
    func determinePresentsEffect() -> Effect<Action> {
        .run { send in
            let reviewDate = userDefaults.doubleForKey(appRatingUserDefaultsKey)
            
            if reviewDate == .zero {
                let newReviewDate = calendar.date(byAdding: .weekOfYear, value: 2, to: self.date.now)?.timeIntervalSince1970 ?? 0
                await userDefaults.setDouble(newReviewDate, appRatingUserDefaultsKey)
                return
            }
            
            guard self.date.now.timeIntervalSince1970 > reviewDate else { return }
            
            try? await continuousClock.sleep(for: .seconds(1.5))
            await send(.alert(.present))
        }
    }
    
    func dismissReviewEffect() -> Effect<Action> {
        .run { send in
            await send(.alert(.dismiss))
            let newReviewDate = calendar.date(byAdding: .year, value: 1, to: self.date.now)?.timeIntervalSince1970 ?? 0
            await userDefaults.setDouble(newReviewDate, appRatingUserDefaultsKey)
        }
    }
    
    func acceptReviewEffect() -> Effect<Action> {
        .run { send in
            await send(.alert(.dismiss))
            await requestStoreReview()
            let newReviewDate = calendar.date(byAdding: .year, value: 1, to: self.date.now)?.timeIntervalSince1970 ?? 0
            await userDefaults.setDouble(newReviewDate, appRatingUserDefaultsKey)
        }
    }
}

public extension View {
    func appRatingObserver(
        store: StoreOf<AppRatingFeature>
    ) -> some View {
        self
            .customTcaAlert(store.scope(state: \.alertState, action: \.alert)) {
                AppRatingModalContentView(store: store)
            }
            .task {
                store.send(.task)
            }
    }
}

struct AppRatingModalContentView: View {
    let store: StoreOf<AppRatingFeature>
    
    var body: some View{
        VStack {
            Text("Have any feedback?")
                .font(.title)
                .bold()
            
            Text("Good or bad?")
                .font(.caption)
                .foregroundStyle(.secondary)
                .italic()
            
            Text("If not, that's okay! We won't ask you again for a while. We value your feedback whether positive or negative.")
                .font(.subheadline)
                .padding(.vertical)
                .padding(.horizontal, 32)
            
            Button("Yes, I do!", action: { store.send(.yesActionTapped) })
                .primaryPillButtonStyle()
            
            Button("Not right now", action: { store.send(.noActionTapped) })
                .primaryPillButtonStyle(
                    style: .init(foregroundColor: .blue, backgroundColor: .clear)
                )
        }
        .multilineTextAlignment(.center)
        .padding(.vertical, 24)
        .background()
        .cornerRadius(12)
        .padding(.horizontal)
    }
}

#Preview {
    AppRatingModalContentView(
        store: .init(initialState: .init(), reducer: {
            EmptyReducer()
        })
    )
    .frame(maxWidth: .infinity)
    .frame(maxHeight: .infinity)
    .background(Color.black.opacity(0.3))
}

#Preview {
    struct AppRatingFeatureView: View {
        let store: StoreOf<AppRatingFeature>
        
        init(
            store: StoreOf<AppRatingFeature>
        ) {
            self.store = store
        }
        
        var body: some View {
            VStack {
                Text("My View")
            }
            .appRatingObserver(store: store)
        }
    }
    
    return AppRatingFeatureView(
        store: .init(
            initialState: .init(),
            reducer: {
                AppRatingFeature()
                    ._printChanges()
            },
            withDependencies: {
                $0.storeKit.requestStoreReview = {
                    guard
                        let scene = await UIApplication.shared.connectedScenes
                            .first(where: { $0 is UIWindowScene })
                            as? UIWindowScene
                    else { return }
                    await SKStoreReviewController.requestReview(in: scene)
                }
                
                $0.userDefaults.doubleForKey = { _ in 10_000 }
            }
        )
    )
}

