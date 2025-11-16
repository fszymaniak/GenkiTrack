# Diet Tracker iOS App

A comprehensive iOS diet tracking application built with SwiftUI, designed to help users manage their meal plans, track nutrition, and maintain shopping lists.

## Features

### 📱 Core Features
- **Meal Diary**: Track daily meals with nutritional information (calories, protein, fats, carbs)
- **Shopping Lists**: Auto-generated shopping lists from meal plans
- **PDF Import**: Import diet plans directly from PDF documents
- **Custom Dishes**: Create and save your own recipes
- **Chat Support**: Built-in chat with dietitian support
- **Progress Tracking**: Monitor weight and measurements over time

### 🎯 Key Functionality

#### Meal Management
- Daily meal planning with breakfast, lunch, dinner, and snacks
- Nutritional tracking (calories, protein, fat, carbohydrates)
- Mark meals as eaten/not eaten
- Swap meals with alternatives
- Visual meal calendar view

#### Shopping Lists
- Organized by category (Dairy, Bread, Vegetables, etc.)
- Or organized by meals
- Check off items as purchased
- Add custom products
- Automatic quantity calculations for servings

#### PDF Diet Import
- Extract meal plans from PDF documents
- Automatic text recognition and parsing
- Generate shopping lists from imported plans
- Support for various diet plan formats

#### Settings & More
- Dark mode support
- Notifications for meal reminders
- Vibration feedback
- Data synchronization
- Dietary recommendations
- Progress measurements

## Technical Stack

- **Language**: Swift 5.5+
- **Framework**: SwiftUI
- **Minimum iOS**: 15.0
- **Architecture**: MVVM
- **Data Storage**: UserDefaults (can be upgraded to Core Data)

## Project Structure

```
DietTracker/
├── DietTrackerApp.swift       # Main app entry point
├── ContentView.swift           # Tab navigation container
├── DiaryView.swift            # Meal diary and calendar
├── ShoppingListView.swift     # Shopping list management
├── ChatView.swift             # Chat support interface
├── MoreView.swift             # Settings and additional features
├── Models.swift               # Data models and managers
└── Info.plist                 # App configuration
```

## Setup Instructions

### Prerequisites
- Xcode 14.0 or later
- iOS 15.0+ deployment target
- Swift 5.5+

### Installation Steps

1. **Create a new Xcode project**:
   - Open Xcode
   - File → New → Project
   - Choose "iOS" → "App"
   - Product Name: "DietTracker"
   - Interface: SwiftUI
   - Language: Swift

2. **Add the source files**:
   - Copy all `.swift` files to your project
   - Replace the default `ContentView.swift`
   - Update `Info.plist` with provided configuration

3. **Configure capabilities**:
   - Enable Push Notifications (for meal reminders)
   - Enable Background Modes (for data sync)

4. **Add required packages** (if needed):
   ```swift
   // In Xcode: File → Add Packages
   // Add any required SPM packages for PDF handling
   ```

5. **Build and run**:
   - Select your target device/simulator
   - Press Cmd+R to build and run

## Customization

### Language Localization
The app is currently in Polish. To localize:
1. Add Localizable.strings files
2. Replace hardcoded strings with NSLocalizedString calls
3. Add language-specific resources

### Theme Customization
Modify colors in the views:
- Primary color: Green (`.green`)
- Background: Gray (`.gray.opacity(0.05)`)
- Accent colors can be customized in each view

### Adding Features

#### To add a new meal type:
1. Update `MealType` enum in Models.swift
2. Add corresponding UI in DiaryView.swift
3. Update meal calculations

#### To integrate with a backend:
1. Create API service class
2. Replace UserDefaults with network calls
3. Add authentication if needed

## Polish → English UI Translation

Key terms used in the app:
- Dzienniczek → Diary
- Czat → Chat
- Zakupy → Shopping
- Więcej → More
- Śniadanie → Breakfast
- Obiad → Lunch
- Kolacja → Dinner
- Przekąska → Snack
- Zjedzone → Eaten
- Wymień → Replace
- Jadłospisy → Meal Plans
- Pomiary → Measurements
- Zalecenia → Recommendations

## Future Enhancements

- [ ] Core Data integration for persistent storage
- [ ] CloudKit sync for multi-device support
- [ ] HealthKit integration
- [ ] Barcode scanning for products
- [ ] Recipe recommendations based on preferences
- [ ] Meal photo capture and storage
- [ ] Export reports (PDF, CSV)
- [ ] Apple Watch companion app
- [ ] Widget support for quick meal logging
- [ ] AI-powered meal suggestions

## Testing

The app includes sample data for testing. Real data integration would require:
- Backend API implementation
- User authentication
- Data validation
- Error handling enhancements

## Support

For questions or issues with the implementation, consider:
- Reviewing SwiftUI documentation
- Testing on multiple device sizes
- Adding proper error handling
- Implementing data persistence

## License

This is a sample implementation for educational purposes. Customize and extend as needed for your specific requirements.
