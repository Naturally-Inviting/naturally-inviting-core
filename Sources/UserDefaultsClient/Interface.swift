import Dependencies
import Foundation

public extension DependencyValues {
    var userDefaults: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}

public struct UserDefaultsClient {
    public var boolForKey: @Sendable (String) -> Bool
    public var dataForKey: @Sendable (String) -> Data?
    public var doubleForKey: @Sendable (String) -> Double
    public var integerForKey: @Sendable (String) -> Int
    public var remove: @Sendable (String) async -> Void
    public var setBool: @Sendable (Bool, String) async -> Void
    public var setData: @Sendable (Data?, String) async -> Void
    public var setDouble: @Sendable (Double, String) async -> Void
    public var setInteger: @Sendable (Int, String) async -> Void

    public init(
        boolForKey: @escaping @Sendable (String) -> Bool,
        dataForKey: @escaping @Sendable (String) -> Data?,
        doubleForKey: @escaping @Sendable (String) -> Double,
        integerForKey: @escaping @Sendable (String) -> Int,
        remove: @escaping @Sendable (String) async -> Void, 
        setBool: @escaping @Sendable (Bool, String) async -> Void,
        setData: @escaping @Sendable (Data?, String) async -> Void, 
        setDouble: @escaping @Sendable (Double, String) async -> Void,
        setInteger: @escaping @Sendable (Int, String) async -> Void
    ) {
        self.boolForKey = boolForKey
        self.dataForKey = dataForKey
        self.doubleForKey = doubleForKey
        self.integerForKey = integerForKey
        self.remove = remove
        self.setBool = setBool
        self.setData = setData
        self.setDouble = setDouble
        self.setInteger = setInteger
    }
}
