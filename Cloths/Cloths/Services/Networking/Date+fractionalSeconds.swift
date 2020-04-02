import Foundation

extension DateFormatter {
    public static func iso8601withFractionalSeconds(locale: Locale) -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        return dateFormatter
    }
}

extension Date {
    static func weekInterval(
        locale: Locale,
        currentDate: Date = Date()
    ) -> (weekStart: Date?, weekEnd: Date?) {
        return (
            startOfWeek(locale: locale, currentDate: currentDate),
            endOfWeek(locale: locale, currentDate: currentDate)
        )
    }

    private static func startOfWeek(locale: Locale, currentDate: Date) -> Date? {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.locale = locale
        guard let referenceDate = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)) else { return nil }
        return gregorian.date(byAdding: .day, value: 0, to: referenceDate)
    }

    private static func endOfWeek(locale: Locale, currentDate: Date) -> Date? {
        var gregorian = Calendar(identifier: .gregorian)
        gregorian.locale = locale
        guard let referenceDate = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)) else { return nil }
        return gregorian.date(byAdding: .day, value: 7, to: referenceDate)
    }
}

