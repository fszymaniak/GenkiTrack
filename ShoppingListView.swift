import SwiftUI

struct ShoppingListView: View {
    @EnvironmentObject var dietManager: DietManager
    @State private var selectedCategory = 0
    @State private var showingAddProduct = false
    
    var categories = ["Według kategorii", "Według potraw"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Category Picker
                Picker("Category", selection: $selectedCategory) {
                    ForEach(0..<categories.count, id: \.self) { index in
                        Text(categories[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                ScrollView {
                    VStack(spacing: 20) {
                        if selectedCategory == 0 {
                            CategoryListView()
                        } else {
                            MealBasedListView()
                        }
                    }
                    .padding()
                }
                
                // Bottom buttons
                HStack(spacing: 20) {
                    Button(action: { showingAddProduct = true }) {
                        Text("Dodaj własny produkt")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.green)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.green, lineWidth: 1.5)
                            )
                    }
                    
                    Button(action: {}) {
                        Text("Dodaj z diety")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.green)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.green, lineWidth: 1.5)
                            )
                    }
                }
                .padding()
            }
            .navigationTitle("Lista zakupów")
            .navigationBarItems(trailing: Button(action: {}) {
                Image(systemName: "ellipsis")
                    .foregroundColor(.green)
            })
            .sheet(isPresented: $showingAddProduct) {
                AddProductView()
            }
        }
    }
}

struct CategoryListView: View {
    @EnvironmentObject var dietManager: DietManager

    var body: some View {
        VStack(spacing: 15) {
            ForEach(dietManager.shoppingCategories, id: \.name) { category in
                VStack(alignment: .leading, spacing: 10) {
                    Text(category.name)
                        .font(.headline)
                        .foregroundColor(.green)

                    ForEach(category.items, id: \.id) { item in
                        ShoppingItemRow(
                            item: item,
                            onToggle: {
                                dietManager.toggleShoppingItemInCategory(
                                    categoryName: category.name,
                                    itemId: item.id
                                )
                            }
                        )
                    }
                }
            }
        }
    }
}

struct MealBasedListView: View {
    @EnvironmentObject var dietManager: DietManager

    var body: some View {
        VStack(spacing: 20) {
            ForEach(dietManager.mealShoppingItems, id: \.mealName) { mealGroup in
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(mealGroup.mealName)
                            .font(.headline)
                            .foregroundColor(.green)
                        Text("(\(mealGroup.servings) porcje)")
                            .font(.caption)
                            .foregroundColor(.gray)

                        Spacer()

                        Button(action: {}) {
                            Image(systemName: "pencil")
                                .foregroundColor(.gray)
                        }

                        Button(action: {}) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }

                    ForEach(mealGroup.items, id: \.id) { item in
                        ShoppingItemRow(
                            item: item,
                            onToggle: {
                                dietManager.toggleShoppingItemInMeal(
                                    mealName: mealGroup.mealName,
                                    itemId: item.id
                                )
                            }
                        )
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.05))
                .cornerRadius(10)
            }
        }
    }
}

struct ShoppingItemRow: View {
    let item: ShoppingItem
    let onToggle: () -> Void

    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(item.isChecked ? .green : .gray)
                    .font(.system(size: 22))
            }

            VStack(alignment: .leading) {
                Text(item.name)
                    .strikethrough(item.isChecked)
                    .foregroundColor(item.isChecked ? .gray : .black)
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text(item.quantity)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(item.unit)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 5)
    }
}

struct AddProductView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var productName = ""
    @State private var quantity = ""
    @State private var selectedCategory = "Nabiał"
    
    let categories = ["Pieczywo", "Nabiał", "Owoce i warzywa", "Mięso", "Ryby", "Przyprawy", "Napoje", "Inne"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Nazwa produktu")) {
                    TextField("Wpisz nazwę produktu", text: $productName)
                }
                
                Section(header: Text("Ilość")) {
                    TextField("Wpisz ilość", text: $quantity)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Kategoria")) {
                    Picker("Kategoria", selection: $selectedCategory) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                }
            }
            .navigationTitle("Dodaj produkt")
            .navigationBarItems(
                leading: Button("Anuluj") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Dodaj") {
                    // Add product logic
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(productName.isEmpty || quantity.isEmpty)
            )
        }
    }
}
