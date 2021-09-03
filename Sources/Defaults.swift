import Foundation

public enum Defaults: String {
    case
    _rated,
    _created

    public static var rated: Bool {
        get { self[._rated] as? Bool ?? false }
        set { self[._rated] = newValue }
    }
    
    public static var created: Date? {
        get { self[._created] as? Date }
        set { self[._created] = newValue }
    }
    
    private static subscript(_ key: Self) -> Any? {
        get { UserDefaults.standard.object(forKey: key.rawValue) }
        set { UserDefaults.standard.setValue(newValue, forKey: key.rawValue) }
    }
}
