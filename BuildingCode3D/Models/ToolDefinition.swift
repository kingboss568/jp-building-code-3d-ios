import Foundation

enum ToolMode: String, Hashable {
    case multiply
    case divide
    case percentage
    case difference
    case sum
    case slope
    case checklist

    func calculate(_ first: Double, _ second: Double) -> Double? {
        switch self {
        case .multiply: first * second
        case .divide: second == 0 ? nil : first / second
        case .percentage: second == 0 ? nil : first / second * 100
        case .difference: first - second
        case .sum: first + second
        case .slope: second == 0 ? nil : first / second * 100
        case .checklist: nil
        }
    }
}

struct ToolDefinition: Identifiable, Hashable {
    let id: Int
    let title: String
    let group: String
    let icon: String
    let mode: ToolMode
    let firstLabel: String
    let secondLabel: String
    let resultLabel: String
    let unit: String
    let guidance: String
    let checklist: [String]
}

