#if canImport(SwiftData)
import SwiftData

@available(iOS 17, *)
public struct SwiftDataClient {
    public var modelContext: () -> ModelContext
}

public class SwiftDataProvider {
    
}
#endif
