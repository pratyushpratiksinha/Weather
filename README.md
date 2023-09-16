# Weather Project README

The Weather Project is a user-friendly mobile application that provides real-time weather information for iOS devices. This README.md file serves as a guide to help you understand how to use the app effectively and provides information about its features and functionality.

## Table of Contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Requirements](#requirements)
- [Technologies Used](#technologies-used)
- [Installation](#installation)
- [Usage](#usage)
- [Contributing](#contributing)
- [Roadmap](#roadmap)
- [License](#license)

## Features

- **Current Weather:** Get up-to-date weather information for available locations in [Weather API Provider](https://openweathermap.org/api).
- **7-Day Forecast:** Check the weather forecast for the next seven days to prepare for the week ahead.
- **Multiple Locations:** Easily save and switch between different locations to check the weather of locations available in [Weather API Provider](https://openweathermap.org/api). You can store up to 10 cities in the list. You can remove the unessential city by left-swiping.  
- **Search Functionality:** Search for a location by postal code.
- **Customization:** Personalize your weather app experience by setting your preferred units (Celsius or Fahrenheit).

## Screenshots

| List of cities | City details |
|--------------|-------------|
|![List of cities](https://github.com/pratyushpratik/Weather/assets/17877604/eee76ef2-ba77-4e2a-803a-d2ff310ba532)|![City details](https://github.com/pratyushpratik/Weather/assets/17877604/936c8282-78ba-4027-a863-f12bc48a1a84)|
  
## Requirements

To run the Weather Project application, you'll need:

- Xcode 14.2 or higher
- iOS 15 or higher
- Swift 5 or higher

## Technologies Used

- **Swift:** The programming language used for iOS app development.
- **UIKit:** The UI framework for building iOS user interfaces.
- **Core Location:** Used to access location data for weather information.
- **Core Data:** Used to store and retrieve data for offline storage.
- **API Integration:** We integrate with [Weather API Provider](https://openweathermap.org/api)(free version) to fetch weather data. So, the data might not be accurate in different API's because of the free version. Alternatively, you can test the response from the below API's(appid is available in configuration files inside the project):
  
1. Check Geo:
   
   ```
   https://api.openweathermap.org/geo/1.0/zip?zip=Zipcode&appid=appid
   ```
   
2. Get Weather:
   
   ```
   https://api.openweathermap.org/data/2.5/weather?lat=latitude&lon=longitude&appid=appid
   ```
   
3. Get Weather Forecast:
   
   ```
   https://api.openweathermap.org/data/2.5/forecast?lat=latitude&lon=longitude&appid=appid&cnt=count
   ```
   
## Installation

1. Clone the repository to your local machine:

   ```
   git clone https://github.com/pratyushpratik/Weather.git
   ```

2. Open the project in Xcode:

   ```
   cd Weather
   open Weather.xcodeproj
   ```
   
## Usage

1. Open Weather.xcodeproj file in Xcode.

2. Build and run the project on the iOS Simulator or your physical device.     

## Contributing

Contributions to the Weather Project are welcome! If you'd like to contribute, please follow these steps:

1. Fork the repository.

2. Create a new branch for your feature or bug fix:

   ```
   git checkout -b feature/your-feature-name
   ```

3. Make your changes and test them thoroughly.

4. Commit your changes with descriptive commit messages:

   ```
   git commit -m "Add your commit message"
   ```

5. Push your branch to your forked repository:

   ```
   git push origin feature/your-feature-name
   ```

6. Open a pull request on the main repository and provide a clear description of your changes.

## Roadmap

We are continuously working to improve the Weather Project and plan to add the following features in future updates:

- **Weather Radar:** Real-time weather radar maps.
- **Notifications:** Weather alerts and notifications.
- **Weather Widgets:** Widgets for your device's home screen.

Stay tuned for updates!

## License

Weather Project is licensed under the [MIT License](LICENSE). Feel free to modify and distribute it as per the terms of the license.
