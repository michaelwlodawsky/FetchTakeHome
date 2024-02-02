//
//  Meal.swift
//  FetchTakeHome
//
//  Created by Michael Wlodawsky on 1/31/24.
//

import Foundation

/// Data structure containing the information of a meal.
struct Meal: Codable, Equatable, Identifiable, Hashable {
    /// Structure containing the ingredient name and measurement.
    struct Ingredient: Equatable, Hashable, Identifiable {
        /// ID of the ingredient, used for `ForEach`
        var id: UUID = UUID()
        /// Measurement for this ingredient
        var measurement: String
        /// Name of this ingredient
        var name: String
    }
    
    /// The unique id of the meal
    let id: String
    /// The name of the meal
    let name: String
    /// The image url for the meal thumbnail
    let imageURL: String
    
    // MARK: - Meal Details, Optional
    
    // TODO: Not sure what this is lol
    let drinkAlternate: String?
    /// The food category of the meal
    let category: String?
    /// Place of origin of the recipe
    let areaOfOrigin: String?
    /// Instructions on how to make the recipe
    let instructions: String?
    /// Tags associated with the meal
    let tags: [String]?
    /// YouTube URL showing the recipe being made
    let youtubeURL: String?
    /// Source website of the recipe
    let sourceURL: String?
    /// Source website of the image thumbnail
    let imageSourceURL: String?
    // TODO: Not sure what this is lol
    let commonsConfirmed: Bool?
    /// Date the recipe was last modified
    let dateModified: Date?
    /// Meal Ingredients with their appropriate measurements
    let ingredients: [Ingredient]?
    
    /// Mapping of internal variables to JSON keys for the decoder
    enum CodingKeys: String, CodingKey {
        case id = "idMeal"
        case name = "strMeal"
        case imageURL = "strMealThumb"
        case drinkAlternate = "strDrinkAlternate"
        case category = "strCategory"
        case areaOfOrigin = "strArea"
        case instructions = "strInstructions"
        case tags = "strTags"
        case youtubeURL = "strYoutube"
        case sourceURL = "strSource"
        case imageSourceURL = "strImageSource"
        case commonsConfirmed = "strCreativeCommonsConfirmed"
        case dateModified = "dateModified"
    }
    
    private struct DynamicCodingKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        // Required for protocol conformance, do not use.
        var intValue: Int?
        init?(intValue: Int) {
            fatalError("Not implemented.")
            return nil
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.imageURL = try container.decode(String.self, forKey: .imageURL)
        
        // The rest of the trys are optional to share this object between our request types
        self.drinkAlternate = try? container.decode(String.self, forKey: .drinkAlternate)
        self.category = try? container.decode(String.self, forKey: .category)
        self.areaOfOrigin = try? container.decode(String.self, forKey: .areaOfOrigin)
        self.tags = try? container.decode(String.self, forKey: .tags).components(separatedBy: ",")
        self.youtubeURL = try? container.decode(String.self, forKey: .youtubeURL)
        self.sourceURL = try? container.decode(String.self, forKey: .sourceURL)
        self.imageSourceURL = try? container.decode(String.self, forKey: .imageSourceURL)
        self.commonsConfirmed = try? container.decode(Bool.self, forKey: .commonsConfirmed)
        self.dateModified = try? container.decode(Date.self, forKey: .dateModified)
        self.instructions = try? container.decode(String.self, forKey: .instructions)
        
        // Based off the API, there can be up to 20 ingredients in the list
        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)
        let ingredientPrefix = "strIngredient"
        let measurementPrefix = "strMeasure"
        var ingredientList: [Ingredient] = []
        for index in 1...20 {
            var name: String?
            if let key = DynamicCodingKeys(stringValue: ingredientPrefix + String(index)) {
                name = try? dynamicContainer.decodeIfPresent(String.self, forKey: key)
            }
            
            var measurement: String?
            if let key = DynamicCodingKeys(stringValue: measurementPrefix + String(index)) {
                measurement = try? dynamicContainer.decodeIfPresent(String.self, forKey: key)
            }
            
            if let name, let measurement, !name.isEmpty, !measurement.isEmpty {
                ingredientList.append(.init(measurement: measurement, name: name))
            }
        }
        
        self.ingredients = ingredientList
    }
}
