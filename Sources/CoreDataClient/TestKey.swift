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
            container: unimplemented("\(Self.self).container", placeholder: .init()),
            viewContext: unimplemented("\(Self.self).viewContext", placeholder: .init(concurrencyType: .privateQueueConcurrencyType)),
            newBackgroundContext: unimplemented("\(Self.self).newBackgroundContext", placeholder: .init(concurrencyType: .privateQueueConcurrencyType))
        )
    }
}
