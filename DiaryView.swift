import SwiftUI

struct DiaryView: View {
    @EnvironmentObject var dietManager: DietManager
    @State private var selectedDate = Date()
    @State private var showingAddMeal = false
    @State private var showingSearchMeal = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Week calendar
                    WeekCalendarView(selectedDate: $selectedDate)
                        .padding(.horizontal)
                        .padding(.top, 10)
                    
                    // Meals list
                    VStack(spacing: 20) {
                        MealCardView(
                            mealType: "Śniadanie",
                            time: "10:30",
                            meal: dietManager.getMeal(for: selectedDate, mealType: .breakfast),
                            onEdit: { /* Edit meal */ },
                            onToggleEaten: {
                                dietManager.toggleMealEaten(for: selectedDate, mealType: .breakfast)
                            }
                        )
                        
                        MealCardView(
                            mealType: "Obiad",
                            time: "14:00",
                            meal: dietManager.getMeal(for: selectedDate, mealType: .lunch),
                            onEdit: { /* Edit meal */ },
                            onToggleEaten: {
                                dietManager.toggleMealEaten(for: selectedDate, mealType: .lunch)
                            }
                        )
                        
                        MealCardView(
                            mealType: "Przekąska",
                            time: "17:00",
                            meal: dietManager.getMeal(for: selectedDate, mealType: .snack),
                            onEdit: { /* Edit meal */ },
                            onToggleEaten: {
                                dietManager.toggleMealEaten(for: selectedDate, mealType: .snack)
                            }
                        )
                    }
                    .padding()
                    
                    // Daily summary
                    DailySummaryView(meals: dietManager.getMeals(for: selectedDate))
                        .padding()
                }
            }
            .navigationTitle("Cześć Filip!")
            .navigationBarTitleDisplayMode(.large)
            .overlay(
                VStack {
                    Spacer()
                    if showingSearchMeal {
                        SearchMealOverlay(
                            isPresented: $showingSearchMeal,
                            onAddMeal: { meal in
                                // Add meal logic
                            }
                        )
                    }
                }
            )
        }
    }
}

struct WeekCalendarView: View {
    @Binding var selectedDate: Date
    
    var body: some View {
        HStack(spacing: 15) {
            ForEach(getDaysOfWeek(), id: \.self) { date in
                VStack(spacing: 5) {
                    Text(dayLetter(from: date))
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("\(Calendar.current.component(.day, from: date))")
                        .font(.title3)
                        .fontWeight(isToday(date) ? .bold : .regular)
                        .foregroundColor(isToday(date) ? .white : .black)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(isToday(date) ? Color.green : Color.gray.opacity(0.1))
                        )
                        .onTapGesture {
                            selectedDate = date
                        }
                }
            }
        }
        .padding(.vertical, 10)
    }
    
    func getDaysOfWeek() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let daysFromMonday = (weekday + 5) % 7
        
        guard let weekStart = calendar.date(byAdding: .day, value: -daysFromMonday, to: today) else {
            return []
        }
        
        return (0..<7).compactMap { day in
            calendar.date(byAdding: .day, value: day, to: weekStart)
        }
    }
    
    func dayLetter(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pl_PL")
        formatter.dateFormat = "EEEEE"
        return formatter.string(from: date).uppercased()
    }
    
    func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }
}

struct MealCardView: View {
    let mealType: String
    let time: String
    let meal: Meal?
    let onEdit: () -> Void
    let onToggleEaten: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(time)
                    .foregroundColor(.gray)
                Text(mealType)
                    .font(.headline)
                    .foregroundColor(.gray)
            }
            
            if let meal = meal {
                HStack {
                    if let image = meal.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 100)
                            .cornerRadius(10)
                    } else {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "fork.knife")
                                    .foregroundColor(.gray)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text(meal.name)
                            .font(.headline)
                            .lineLimit(2)
                        
                        HStack(spacing: 10) {
                            Text("\(Int(meal.calories)) kcal")
                            Text("B: \(Int(meal.protein)) g")
                            Text("T: \(Int(meal.fat)) g")
                            Text("W: \(Int(meal.carbs)) g")
                        }
                        .font(.caption)
                        .foregroundColor(.gray)
                        
                        HStack(spacing: 20) {
                            Button(action: onToggleEaten) {
                                HStack {
                                    Image(systemName: meal.eaten ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(.green)
                                    Text("Zjedzone")
                                        .foregroundColor(.green)
                                }
                            }
                            
                            Button(action: onEdit) {
                                HStack {
                                    Image(systemName: "arrow.triangle.2.circlepath")
                                        .foregroundColor(.blue)
                                    Text("Wymień")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .font(.system(size: 14))
                    }
                    
                    Spacer()
                }
            } else {
                Button(action: { /* Add meal */ }) {
                    HStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "plus")
                                    .foregroundColor(.gray)
                            )
                        
                        Text("Dodaj posiłek")
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.gray.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct DailySummaryView: View {
    let meals: [Meal]
    
    var totalCalories: Double {
        meals.reduce(0) { $0 + ($1.eaten ? $1.calories : 0) }
    }
    
    var totalProtein: Double {
        meals.reduce(0) { $0 + ($1.eaten ? $1.protein : 0) }
    }
    
    var totalFat: Double {
        meals.reduce(0) { $0 + ($1.eaten ? $1.fat : 0) }
    }
    
    var totalCarbs: Double {
        meals.reduce(0) { $0 + ($1.eaten ? $1.carbs : 0) }
    }
    
    var body: some View {
        HStack(spacing: 20) {
            MacroView(value: totalCalories, total: 2400, unit: "kcal", label: "")
            MacroView(value: totalProtein, total: 150, unit: "g", label: "")
            MacroView(value: totalFat, total: 77, unit: "g", label: "")
            MacroView(value: totalCarbs, total: 276, unit: "g", label: "")
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(10)
    }
}

struct MacroView: View {
    let value: Double
    let total: Double
    let unit: String
    let label: String
    
    var body: some View {
        VStack(spacing: 5) {
            Text("\(Int(value))")
                .font(.headline)
            Text("/ \(Int(total)) \(unit)")
                .font(.caption)
                .foregroundColor(.gray)
            if !label.isEmpty {
                Text(label)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
    }
}

struct SearchMealOverlay: View {
    @Binding var isPresented: Bool
    let onAddMeal: (Meal) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 5)
                .padding(.top, 10)
            
            VStack(spacing: 20) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Wyszukaj potrawę")
                    }
                    .font(.headline)
                    .foregroundColor(.green)
                }
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "plus")
                        Text("Stwórz potrawę")
                    }
                    .font(.headline)
                    .foregroundColor(.green)
                }
                
                Button(action: {}) {
                    HStack {
                        Image(systemName: "barcode")
                        Text("Zeskanuj kod")
                    }
                    .font(.headline)
                    .foregroundColor(.green)
                }
                
                Button(action: { isPresented = false }) {
                    HStack {
                        Image(systemName: "xmark")
                        Text("Anuluj")
                    }
                    .font(.headline)
                    .foregroundColor(.green)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .shadow(radius: 10)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
