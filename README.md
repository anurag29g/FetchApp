Fetch Take-Home App

Technical Details - 
Frameworks: SwiftUI, Core Data
Architecture: MVVM (Model-View-ViewModel)
Core Data: Used for local persistence, allowing the app to store and retrieve data even when offline.
Concurrency: Uses Grand Central Dispatch (GCD) to fetch and store data asynchronously, providing a smooth, responsive UI.

Project Structure
1. Models
Item: Represents each data item with properties id, listId, and name.
CachedItem: Core Data entity that mirrors the Item model to store items locally.
2. View Models
ItemViewModel: Manages data-fetching, sorting, and grouping logic. Communicates with Core Data to save and retrieve items.
3. Views
ContentView: Main view displaying grouped items with support for pull-to-refresh and dropdown grouping.
ListSectionView: Displays individual listId sections with items sorted by name within each section.

I chose to utilize Core Data to provide offline access and persistence. 
Once data is fetched from the API, it's saved locally. 
If the app is restarted or there’s no internet connection, data is loaded directly from Core Data, enhancing user experience by reducing dependency on the network.

Notes for Recruiters
This project demonstrates proficiency in iOS development, particularly with:

Data Persistence: Using Core Data for local storage.
Efficient Data Handling: Grouping, sorting, and filtering.
UI Responsiveness: Asynchronous data fetching and smooth UI updates.
Thank you for reviewing my app! I hope it demonstrates my commitment to building high-quality, efficient applications for iOS.
