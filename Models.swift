import Foundation
import SwiftUI
import PDFKit
import Vision
import VisionKit

// MARK: - Data Models

struct Meal: Identifiable, Codable {
    let id = UUID()
    var name: String
    var calories: Double
    var protein: Double
    var fat: Double
    var carbs: Double
    var eaten: Bool = false
    var imageData: Data?
    
    var image: UIImage? {
        guard let data = imageData else { return nil }
        return UIImage(data: data)
    }
}

enum MealType: String, CaseIterable {
    case breakfast = "Śniadanie"
    case lunch = "Obiad"
    case dinner = "Kolacja"
    case snack = "Przekąska"
}

struct DailyMeals: Codable {
    var date: Date
    var breakfast: Meal?
    var lunch: Meal?
    var dinner: Meal?
    var snack: Meal?
}

struct ShoppingItem: Identifiable, Codable {
    let id = UUID()
    var name: String
    var quantity: String
    var unit: String
    var isChecked: Bool = false
    var category: String
}

struct ShoppingCategory {
    var name: String
    var items: [ShoppingItem]
}

struct MealShoppingGroup {
    var mealName: String
    var servings: Int
    var items: [ShoppingItem]
}

struct CustomDish: Identifiable, Codable {
    let id = UUID()
    var name: String
    var ingredients: [Ingredient]
    var instructions: String
    var calories: Double
    var protein: Double
    var fat: Double
    var carbs: Double
    var imageData: Data?
    
    var image: UIImage? {
        guard let data = imageData else { return nil }
        return UIImage(data: data)
    }
}

struct Ingredient: Identifiable, Codable {
    let id = UUID()
    var name: String
    var amount: String
    var unit: String
}

// MARK: - Diet Manager

class DietManager: ObservableObject {
    @Published var dailyMeals: [Date: DailyMeals] = [:]
    @Published var shoppingItems: [ShoppingItem] = []
    @Published var customDishes: [CustomDish] = []
    @Published var isLoading = false
    
    // Sample shopping categories
    var shoppingCategories: [ShoppingCategory] {
        [
            ShoppingCategory(name: "Pieczywo", items: [
                ShoppingItem(name: "Chleb żytni na zakwasie", quantity: "300", unit: "g", category: "Pieczywo")
            ]),
            ShoppingCategory(name: "Nabiał", items: [
                ShoppingItem(name: "Zott Protein napój mleczny czekoladowy", quantity: "500", unit: "g", category: "Nabiał"),
                ShoppingItem(name: "Jaja kurze całe", quantity: "448", unit: "g", category: "Nabiał")
            ]),
            ShoppingCategory(name: "Owoce i warzywa", items: [
                ShoppingItem(name: "Ogórki, kiszone", quantity: "300", unit: "g", category: "Owoce i warzywa"),
                ShoppingItem(name: "Rukola", quantity: "120", unit: "g", category: "Owoce i warzywa"),
                ShoppingItem(name: "Czosnek", quantity: "40", unit: "g", category: "Owoce i warzywa")
            ]),
            ShoppingCategory(name: "Orzechy i nasiona", items: [
                ShoppingItem(name: "Masło orzechowe", quantity: "70", unit: "g", category: "Orzechy i nasiona")
            ])
        ]
    }
    
    var mealShoppingItems: [MealShoppingGroup] {
        [
            MealShoppingGroup(
                mealName: "Omlet - na słodko a'la sernik",
                servings: 2,
                items: [
                    ShoppingItem(name: "Jaja kurze całe", quantity: "112", unit: "g", category: "Nabiał"),
                    ShoppingItem(name: "Masło orzechowe", quantity: "40", unit: "g", category: "Orzechy")
                ]
            ),
            MealShoppingGroup(
                mealName: "Owsianka - nocna czekoladowa ze śliwkami",
                servings: 2,
                items: [
                    ShoppingItem(name: "Masło orzechowe", quantity: "30", unit: "g", category: "Orzechy")
                ]
            ),
            MealShoppingGroup(
                mealName: "Grzanki - z mozzarellą, fasolką",
                servings: 2,
                items: [
                    ShoppingItem(name: "Chleb żytni na zakwasie", quantity: "120", unit: "g", category: "Pieczywo")
                ]
            ),
            MealShoppingGroup(
                mealName: "Bułka - z twarożkiem i serem",
                servings: 2,
                items: [
                    ShoppingItem(name: "Dynia, pestki, łuskane", quantity: "10", unit: "g", category: "Orzechy")
                ]
            )
        ]
    }
    
    init() {
        loadSampleData()
    }
    
    private func loadSampleData() {
        let today = Date()
        let meal1 = Meal(
            name: "Omlet - na słodko a'la sernik",
            calories: 590,
            protein: 43,
            fat: 22,
            carbs: 60,
            eaten: true
        )
        
        let meal2 = Meal(
            name: "Makaron - z kurczakiem, pieczarkami i ajvarem",
            calories: 580,
            protein: 45,
            fat: 16,
            carbs: 61,
            eaten: true
        )
        
        let meal3 = Meal(
            name: "Tortilla - z serkiem śmietankowym i serem",
            calories: 613,
            protein: 36,
            fat: 35,
            carbs: 40,
            eaten: false
        )
        
        dailyMeals[today] = DailyMeals(
            date: today,
            breakfast: meal1,
            lunch: meal2,
            dinner: nil,
            snack: meal3
        )
    }
    
    func getMeal(for date: Date, mealType: MealType) -> Meal? {
        guard let meals = dailyMeals[Calendar.current.startOfDay(for: date)] else { return nil }
        
        switch mealType {
        case .breakfast:
            return meals.breakfast
        case .lunch:
            return meals.lunch
        case .dinner:
            return meals.dinner
        case .snack:
            return meals.snack
        }
    }
    
    func getMeals(for date: Date) -> [Meal] {
        guard let meals = dailyMeals[Calendar.current.startOfDay(for: date)] else { return [] }
        
        return [meals.breakfast, meals.lunch, meals.dinner, meals.snack].compactMap { $0 }
    }
    
    func toggleMealEaten(for date: Date, mealType: MealType) {
        let dayStart = Calendar.current.startOfDay(for: date)
        
        if dailyMeals[dayStart] == nil {
            dailyMeals[dayStart] = DailyMeals(date: dayStart)
        }
        
        switch mealType {
        case .breakfast:
            dailyMeals[dayStart]?.breakfast?.eaten.toggle()
        case .lunch:
            dailyMeals[dayStart]?.lunch?.eaten.toggle()
        case .dinner:
            dailyMeals[dayStart]?.dinner?.eaten.toggle()
        case .snack:
            dailyMeals[dayStart]?.snack?.eaten.toggle()
        }
    }
    
    func syncData() {
        isLoading = true
        // Simulate network sync
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isLoading = false
        }
    }
    
    // MARK: - PDF Import
    func importDietFromPDF(url: URL) {
        isLoading = true
        
        // Extract text from PDF
        guard let pdfDocument = PDFDocument(url: url) else {
            isLoading = false
            return
        }
        
        var extractedText = ""
        for pageIndex in 0..<pdfDocument.pageCount {
            guard let page = pdfDocument.page(at: pageIndex) else { continue }
            extractedText += page.string ?? ""
        }
        
        // Parse meals from extracted text
        parseMealsFromText(extractedText)
        
        isLoading = false
    }
    
    private func parseMealsFromText(_ text: String) {
        // Implement parsing logic based on PDF structure
        // This would need to be customized based on the specific PDF format
        
        // Example parsing logic:
        let lines = text.components(separatedBy: .newlines)
        
        for line in lines {
            // Look for meal patterns
            if line.contains("Śniadanie") || line.contains("Obiad") || line.contains("Kolacja") {
                // Extract meal details
                // Create Meal objects
                // Add to dailyMeals
            }
            
            // Look for ingredients for shopping list
            if line.contains("g") || line.contains("ml") || line.contains("szt") {
                // Extract ingredient details
                // Create ShoppingItem objects
                // Add to shoppingItems
            }
        }
    }
    
    // MARK: - Custom Dish Management
    func addCustomDish(_ dish: CustomDish) {
        customDishes.append(dish)
        saveCustomDishes()
    }
    
    func deleteCustomDish(_ dish: CustomDish) {
        customDishes.removeAll { $0.id == dish.id }
        saveCustomDishes()
    }
    
    private func saveCustomDishes() {
        // Save to UserDefaults or Core Data
        if let encoded = try? JSONEncoder().encode(customDishes) {
            UserDefaults.standard.set(encoded, forKey: "customDishes")
        }
    }
    
    private func loadCustomDishes() {
        if let data = UserDefaults.standard.data(forKey: "customDishes"),
           let dishes = try? JSONDecoder().decode([CustomDish].self, from: data) {
            customDishes = dishes
        }
    }
}

// MARK: - Chat Support
struct ChatMessage: Identifiable {
    let id = UUID()
    var text: String
    var isUser: Bool
    var timestamp: Date
}

class ChatManager: ObservableObject {
    @Published var messages: [ChatMessage] = [
        ChatMessage(text: "Cześć! Jak mogę Ci pomóc z Twoją dietą?", isUser: false, timestamp: Date())
    ]
    
    func sendMessage(_ text: String) {
        // Add user message
        messages.append(ChatMessage(text: text, isUser: true, timestamp: Date()))
        
        // Simulate bot response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.messages.append(ChatMessage(
                text: "Dziękuję za wiadomość. Analizuję Twoje pytanie...",
                isUser: false,
                timestamp: Date()
            ))
        }
    }
}
