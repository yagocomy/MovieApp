import Foundation
import SwiftData

// MARK: - MoviesPersistentModel
@Model
class MoviesPersistentModel {
    @Attribute(.unique) var id: String
    var page: Int
    var results: ResultPersistent
    var totalPages: Int
    var totalResults: Int

    init(id: String, page: Int, results: ResultPersistent, totalPages: Int, totalResults: Int) {
        self.id = id
        self.page = page
        self.results = results
        self.totalPages = totalPages
        self.totalResults = totalResults
    }
}

// MARK: - Result
@Model
class ResultPersistent {
    var adult: Bool
    var backdropPath: String
    var genreIDS: [Int]
    var id: Int
    var originalLanguage: String
    var originalTitle: String
    var overview: String
    var popularity: Double
    var posterPath: String
    var releaseDate: String
    var title: String
    var video: Bool
    var voteAverage: Double
    var voteCount: Int
    var isExpanded: Bool = false

    init(adult: Bool, backdropPath: String, genreIDS: [Int], id: Int, originalLanguage: String, originalTitle: String, overview: String, popularity: Double, posterPath: String, releaseDate: String, title: String, video: Bool, voteAverage: Double, voteCount: Int) {
        self.adult = adult
        self.backdropPath = backdropPath
        self.genreIDS = genreIDS
        self.id = id
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.overview = overview
        self.popularity = popularity
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.title = title
        self.video = video
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }
}

