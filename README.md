# Flutter Quiz App

A modern, interactive quiz application built with Flutter that offers an engaging user experience with beautiful animations and dynamic content.

![Flutter Quiz App](assets/images/app_preview.png)

## Features

### 🎯 Core Features
- Multiple quiz categories (General Knowledge, Flutter)
- 20 unique questions per category
- Random question selection for each game
- 20-second timer per question
- Detailed explanations for each answer
- Score tracking and statistics
- Beautiful animations and transitions

### 🎨 UI/UX Features
- Modern dark theme with gradient backgrounds
- Animated text and transitions
- Interactive buttons with feedback
- Progress tracking
- Confetti celebration for high scores
- Responsive design for all screen sizes

### 📊 Game Mechanics
- Randomized questions for each game
- 10 questions per game session
- Immediate feedback on answers
- Time tracking per question
- Average response time calculation
- Final score with percentage

## Getting Started

### Prerequisites
- Flutter SDK (latest version)
- Dart SDK (latest version)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone https://github.com/Oumllack/Flutter-Mobile-Quiz-Application.git
```

2. Navigate to the project directory:
```bash
cd Flutter-Mobile-Quiz-Application
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart
├── providers/
│   └── quiz_provider.dart
├── screens/
│   ├── home_screen.dart
│   └── quiz_screen.dart
└── theme/
    └── app_theme.dart
```

### Key Components

- **QuizProvider**: Manages the game state, questions, and scoring
- **HomeScreen**: Displays category selection with animations
- **QuizScreen**: Handles the quiz interface and user interactions
- **AppTheme**: Defines the app's visual style and theme

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  google_fonts: ^6.1.0
  animated_text_kit: ^4.2.2
  lottie: ^2.7.0
  flutter_animate: ^4.3.0
  confetti: ^0.7.0
```

## Features in Detail

### Question Management
- Questions are stored in the QuizProvider
- Each question includes:
  - Question text
  - Multiple choice options
  - Correct answer
  - Detailed explanation
- Questions are randomly selected for each game

### Scoring System
- Points awarded for correct answers
- Time tracking for each question
- Final score calculation with percentage
- Average response time statistics

### Animations and Effects
- Entrance animations for questions
- Button press animations
- Timer animations
- Confetti celebration for high scores
- Smooth transitions between screens

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Flutter team for the amazing framework
- All contributors who have helped improve the app
- The open-source community for the wonderful packages used in this project

## Contact

Oumllack - [GitHub Profile](https://github.com/Oumllack)

Project Link: [https://github.com/Oumllack/Flutter-Mobile-Quiz-Application](https://github.com/Oumllack/Flutter-Mobile-Quiz-Application)
