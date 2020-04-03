import Foundation
import TabularView

enum ColumnId: Int, ColumnIdType {

    case name
    case population
    case landArea

    var title: String? {
        switch self {
        case .name:
            return "name"
        case .population:
            return "population"
        case .landArea:
            return "land area (km²)"
        }
    }

}
