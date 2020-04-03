import Foundation

extension Bundle {

    func decode <T: Decodable> (_ type: T.Type, from fileName: String) -> T {

        guard let url = url(forResource: fileName, withExtension: nil) else {
            fatalError("Couldn't make URL for '\(fileName)'.")
        }

        guard let loadedData = try? Data(contentsOf: url) else {
            fatalError("Couldn't load data from '\(fileName)'.")
        }

        let decoder = JSONDecoder()
        
        guard let decodedData = try? decoder.decode(T.self, from: loadedData) else {
            fatalError("Couldn't decode data from '\(fileName)'.")
        }

        return decodedData

    }

}
