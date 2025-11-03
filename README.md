# Calorie-Estimation-App-UI-UX-
## Overview
This iOS application estimates calorie intake and generates meal recipes using the iPhone camera. It also allows users to log their daily meals, track progress toward calorie goals, and view personalized insights on a dashboard.

The app includes:
- User authentication (login and signup)
- Home dashboard with live calorie tracking
- Food log
- Camera-based calorie estimation and recipe generation
- Recipe saving and detailed nutrition breakdowns
- Profile and History Tracking
Developed using SwiftUI, SwiftData, and AVFoundation, designed for iPhones running iOS 17 or later.

## Features
- Login / Signup – Simple authentication interface=
- Home Dashboard – Displays calorie progress and quick stats
- Meal Camera – Capture or upload photos for calorie or recipe analysis
- Food Log – Add and view daily meals with macronutrient tracking
- Recipe View – View and save generated recipes
- Goal Tracking – Set daily calorie goals and monitor progress

## Requirements
- macOS 14 (Sonoma) or later
- Xcode 15 or later
- iPhone simulator or physical device running iOS 17+

## Installation
Option 1: Clone the repository
```
git clone https://github.com/jamesduong03/Calorie-Estimation-App-UI-UX-.git
```

Option 2: Download the ZIP file
1. Click the Code button, then select Download ZIP.
2. Unzip the file and open the extracted folder in Finder.
3. Double-click CalorieEstimationApp.xcodeproj (or .xcworkspace if present).
### Build and Run
1. Open the project file in Xcode
2. In Xcode, select your target simulator or connected iPhone.
3. Press Cmd + R or Product/run to build and run.

## Running the App
1. Launch the app.
2. Log in or sign up to access your dashboard.
3. Use the Camera tab to capture or upload meals for analysis.
4. Add results to the Food Log under a specific meal category.
5. Review your progress on the Home page and adjust your daily calorie goal by tapping the pencil icon.

## Current Limitations
- Calorie and recipe results currently use placeholder data.
- Authentication runs locally; backend support not yet connected.
- Local data is cleared on uninstall unless persisted via SwiftData.
