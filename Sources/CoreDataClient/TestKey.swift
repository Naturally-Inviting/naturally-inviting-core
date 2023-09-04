import Dependencies

extension DependencyValues {
    public var coreData: CoreDataClient {
        get { self[CoreDataClient.self] }
        set { self[CoreDataClient.self] = newValue }
    }
}

extension CoreDataClient: TestDependencyKey {
    public static var testValue: CoreDataClient {
        CoreDataClient(
            container: unimplemented("\(Self.self).container"),
            viewContext: unimplemented("\(Self.self).viewContext"),
            newBackgroundContext: unimplemented("\(Self.self).newBackgroundContext")
        )
    }
}
