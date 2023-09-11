import Foundation

// MARK: - groupedBy(dateComponents:)

extension Array {
    /// Returns a dictionary of elements grouped by `Date`.
    /// Elements are grouped based on a set of `Calendar.Component`.
    ///
    /// - Important: The date returned as a key will only contain elements passed in via `dateComponents`.
    /// Example: With the components `[.month, .day]` for April 9, the date key would be "0001-04-09 00:00:00 +0000".
    /// Date's of the element in the dictionary will not be affected.
    ///
    /// - Parameters:
    ///     - dateComponents: Components by which date elements will be grouped.
    ///
    /// - Returns: A `dictionary` of elements grouped by `Date`.
    ///
    /// - seealso: https://gist.github.com/karsonbraaten/a31f4ac1f26a20d03c2fe8dc4aca1491#file-grouped-by-date-components-swift
    ///
    public func groupedBy(
        calendar: Calendar = .autoupdatingCurrent,
        dateComponents: Set<Calendar.Component>,
        dateMap: (Element) -> Date
    ) -> [Date: [Element]] {
        let initial: [Date: [Element]] = [:]

        let groupedByDateComponents = reduce(into: initial) { dictionary, element in
            let components = calendar.dateComponents(dateComponents, from: dateMap(element))
            let date = calendar.date(from: components)!

            dictionary[date, default: []] += [element]
        }

        return groupedByDateComponents
    }
}
