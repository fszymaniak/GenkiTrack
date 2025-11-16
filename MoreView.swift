import SwiftUI

struct MoreView: View {
    @EnvironmentObject var dietManager: DietManager
    @State private var darkMode = false
    @State private var notifications = true
    @State private var vibrations = true
    @State private var showingPDFImport = false
    @State private var showingDietHistory = false
    @State private var showingMeasurements = false
    @State private var showingRecommendations = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    // Main sections
                    VStack(spacing: 1) {
                        SettingRow(
                            title: "Jadłospisy",
                            subtitle: "Podgląd wszystkich jadłospisów",
                            icon: "doc.text",
                            action: { showingDietHistory = true }
                        )
                        
                        SettingRow(
                            title: "Pomiary",
                            subtitle: "Sprawdź swoje postępy",
                            icon: "chart.line.uptrend.xyaxis",
                            action: { showingMeasurements = true }
                        )
                        
                        SettingRow(
                            title: "Zalecenia",
                            subtitle: "Materiały dodatkowe",
                            icon: "book",
                            action: { showingRecommendations = true }
                        )
                        
                        SettingRow(
                            title: "Synchronizuj",
                            subtitle: "Pobierz najnowsze dane",
                            icon: "arrow.triangle.2.circlepath",
                            action: {
                                dietManager.syncData()
                            }
                        )
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.vertical, 20)
                    
                    // Settings section
                    VStack(spacing: 1) {
                        ToggleRow(
                            title: "Ciemny motyw",
                            subtitle: "Daj swoim oczom odpocząć",
                            isOn: $darkMode
                        )
                        
                        ToggleRow(
                            title: "Wibracje",
                            subtitle: nil,
                            isOn: $vibrations
                        )
                        
                        ToggleRow(
                            title: "Powiadomienia",
                            subtitle: nil,
                            isOn: $notifications
                        )
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.vertical, 20)
                    
                    // Import PDF section
                    Button(action: { showingPDFImport = true }) {
                        HStack {
                            Image(systemName: "doc.badge.plus")
                                .font(.title2)
                                .foregroundColor(.green)
                            
                            VStack(alignment: .leading) {
                                Text("Importuj jadłospis z PDF")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text("Dodaj swój własny plan żywieniowy")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                    .padding(.vertical, 10)
                    
                    // Custom dishes section
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "fork.knife.circle")
                                .font(.title2)
                                .foregroundColor(.green)
                            
                            VStack(alignment: .leading) {
                                Text("Własne potrawy")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Text("Zarządzaj swoimi przepisami")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                }
                .padding()
            }
            .background(Color.gray.opacity(0.05))
            .navigationTitle("Więcej")
            .sheet(isPresented: $showingPDFImport) {
                PDFImportView()
            }
            .sheet(isPresented: $showingDietHistory) {
                DietHistoryView()
            }
            .sheet(isPresented: $showingMeasurements) {
                MeasurementsView()
            }
            .sheet(isPresented: $showingRecommendations) {
                RecommendationsView()
            }
        }
    }
}

struct SettingRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.green)
                    .frame(width: 30)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.body)
                        .foregroundColor(.black)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
        }
    }
}

struct ToggleRow: View {
    let title: String
    let subtitle: String?
    @Binding var isOn: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.body)
                    .foregroundColor(.black)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(.green)
        }
        .padding()
        .background(Color.white)
    }
}

struct PDFImportView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedPDF: URL?
    @State private var isImporting = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "doc.badge.arrow.up")
                    .font(.system(size: 60))
                    .foregroundColor(.green)
                
                Text("Importuj jadłospis z PDF")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Wybierz plik PDF zawierający Twój plan żywieniowy. Aplikacja automatycznie rozpozna posiłki i utworzy listę zakupów.")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                Button(action: {
                    // Open document picker
                }) {
                    Label("Wybierz plik PDF", systemImage: "folder")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                
                if let pdfURL = selectedPDF {
                    HStack {
                        Image(systemName: "doc.fill")
                            .foregroundColor(.green)
                        Text(pdfURL.lastPathComponent)
                            .font(.caption)
                        Spacer()
                        Button(action: { selectedPDF = nil }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    Button(action: {
                        isImporting = true
                        // Import PDF logic
                    }) {
                        if isImporting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        } else {
                            Text("Importuj")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Import PDF")
            .navigationBarItems(trailing: Button("Zamknij") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct DietHistoryView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<5) { index in
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Jadłospis \(index + 1)")
                            .font(.headline)
                        Text("Data: \(Date(), style: .date)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 5)
                }
            }
            .navigationTitle("Historia jadłospisów")
            .navigationBarItems(trailing: Button("Zamknij") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct MeasurementsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var weight = ""
    @State private var height = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Aktualne pomiary")) {
                    HStack {
                        Text("Waga")
                        Spacer()
                        TextField("kg", text: $weight)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                    
                    HStack {
                        Text("Wzrost")
                        Spacer()
                        TextField("cm", text: $height)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }
                }
                
                Section(header: Text("Historia pomiarów")) {
                    // Chart would go here
                    Text("Wykres postępów")
                        .foregroundColor(.gray)
                        .padding(.vertical, 40)
                        .frame(maxWidth: .infinity)
                }
            }
            .navigationTitle("Pomiary")
            .navigationBarItems(trailing: Button("Zapisz") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct RecommendationsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Zalecenia dietetyka")) {
                    Text("• Pij minimum 2 litry wody dziennie")
                    Text("• Jedz regularne posiłki co 3-4 godziny")
                    Text("• Unikaj słodkich napojów")
                    Text("• Zwiększ spożycie warzyw")
                }
                
                Section(header: Text("Materiały edukacyjne")) {
                    HStack {
                        Image(systemName: "doc.text")
                            .foregroundColor(.green)
                        Text("Przewodnik zdrowego żywienia")
                    }
                    HStack {
                        Image(systemName: "play.circle")
                            .foregroundColor(.green)
                        Text("Video: Przygotowanie posiłków")
                    }
                    HStack {
                        Image(systemName: "book")
                            .foregroundColor(.green)
                        Text("E-book: Przepisy fit")
                    }
                }
            }
            .navigationTitle("Zalecenia")
            .navigationBarItems(trailing: Button("Zamknij") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
