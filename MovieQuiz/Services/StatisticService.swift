import Foundation

protocol StatisticService {
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: BestGame? { get }
    
    func store(correct count: Int, total amount: Int)
}

final class StatisticServiceImplementation: StatisticService {
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount
    }
    
    private let userDefaults = UserDefaults.standard
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    private let dateProvider: () -> Date
    
    var correct: Int {
        get {
            userDefaults.integer(forKey: Keys.correct.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    var total: Int {
        get {
            userDefaults.integer(forKey: Keys.total.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.total.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: BestGame? {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                let record = try? JSONDecoder().decode(BestGame.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            
            return record
        }
        
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        return Double(correct) / Double(total) * 100
    }
    
    func store(correct count: Int, total amount: Int) {
        self.correct += count
        self.total += amount
        self.gamesCount += 1
        
        let date = dateProvider()
            let currentGame = BestGame(correct: count, total: amount, date: date)
            
            if let previousBestGame = bestGame {
                if currentGame.correct > previousBestGame.correct {
                    bestGame = currentGame
                }
            } else {
                bestGame = currentGame
            }
        }
        
//
//        let date = dateProvider()
//        let currentBestGame = BestGame(correct: correct, total: total, date: date)
//
//        if let previousBestGame = bestGame {
//            if currentBestGame > previousBestGame {
//                bestGame = currentBestGame
//            }
//        } else {
//            bestGame = currentBestGame
//        }
//    }
    
    init(
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder(),
        dateProvider: @escaping () -> Date = { Date() }
    ) {
        self.decoder = decoder
        self.encoder = encoder
        self.dateProvider = dateProvider
    }
}
