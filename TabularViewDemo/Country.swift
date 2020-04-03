import Foundation
import TabularView

struct Country: RowDataType {

    let id: RowId
    private static var idProvider = 0

    let name: String
    let population: Int
    let landArea: Int

    init(name: String, population: Int, landArea: Int) {

        self.id = Self.idProvider
        Self.idProvider += 1

        self.name = name
        self.population = population
        self.landArea = landArea

    }

}

extension Country {

    func data(for columnId: ColumnId) -> String {
        switch columnId {
        case .name:
            return name
        case .population:
            return "\(population)"
        case .landArea:
            return "\(landArea)"
        }
    }

}

// MARK: - Sorting support

extension Country {

    static func sorter(
        by columnId: ColumnId,
        sortOrder: SortOrder = .ascending
    ) -> (Country, Country) -> Bool {

        switch columnId {
        case .name:
            return { lhs, rhs in
                sortOrder == .ascending
                    ? lhs.name < rhs.name
                    : lhs.name > rhs.name
            }
        case .population:
            return { lhs, rhs in
                sortOrder == .ascending
                    ? lhs.population < rhs.population
                    : lhs.population > rhs.population
            }
        case .landArea:
            return { lhs, rhs in
                sortOrder == .ascending
                    ? lhs.landArea < rhs.landArea
                    : lhs.landArea > rhs.landArea
            }
        }

    }

}

extension Array where Element == Country {

    func sorted(by columnId: ColumnId, sortOrder: SortOrder = .ascending) -> Self {
        self.sorted(by: Country.sorter(by: columnId, sortOrder: sortOrder))
    }

}

// MARK: - Decodable conformance

extension Country: Decodable {

    enum CountryCodingKey: CodingKey {
        case name
        case population
        case landArea
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CountryCodingKey.self)
        let name = try container.decode(String.self, forKey: .name)
        let population = try container.decode(Int.self, forKey: .population)
        let landArea = try container.decode(Int.self, forKey: .landArea)

        self.init(name: name, population: population, landArea: landArea)

    }

}
