import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

class QuizProvider with ChangeNotifier {
  int _currentQuestionIndex = 0;
  int _score = 0;
  String _selectedCategory = 'Culture Générale';
  bool _quizCompleted = false;
  int _timeLeft = 20; // Temps en secondes par question
  Timer? _timer;
  bool _isAnswered = false;
  int? _selectedAnswerIndex;
  List<int> _timePerQuestion = [];
  List<Map<String, dynamic>> _currentQuestions = [];

  final List<Map<String, dynamic>> _allQuestions = [
    // Culture Générale
    {
      'category': 'Culture Générale',
      'question': 'Quelle est la capitale de la France ?',
      'options': ['Lyon', 'Paris', 'Marseille', 'Bordeaux'],
      'correctAnswer': 1,
      'explanation': 'Paris est la capitale de la France depuis 508.',
    },
    {
      'category': 'Culture Générale',
      'question': 'Qui a peint la Joconde ?',
      'options': ['Van Gogh', 'Leonard de Vinci', 'Picasso', 'Michel-Ange'],
      'correctAnswer': 1,
      'explanation':
          'La Joconde a été peinte par Leonard de Vinci entre 1503 et 1519.',
    },
    {
      'category': 'Culture Générale',
      'question': 'Quel est le plus grand océan du monde ?',
      'options': ['Atlantique', 'Pacifique', 'Indien', 'Arctique'],
      'correctAnswer': 1,
      'explanation': 'L\'océan Pacifique est le plus grand océan du monde.',
    },
    {
      'category': 'Culture Générale',
      'question': 'Quelle est la plus haute montagne du monde ?',
      'options': ['K2', 'Mont Blanc', 'Everest', 'Kilimandjaro'],
      'correctAnswer': 2,
      'explanation': 'L\'Everest culmine à 8 848 mètres d\'altitude.',
    },
    {
      'category': 'Culture Générale',
      'question': 'Qui a écrit "Les Misérables" ?',
      'options': [
        'Victor Hugo',
        'Émile Zola',
        'Gustave Flaubert',
        'Honoré de Balzac'
      ],
      'correctAnswer': 0,
      'explanation': 'Victor Hugo a écrit Les Misérables en 1862.',
    },
    {
      'category': 'Culture Générale',
      'question': 'Quel est le symbole chimique de l\'or ?',
      'options': ['Ag', 'Fe', 'Au', 'Cu'],
      'correctAnswer': 2,
      'explanation': 'Au vient du latin "aurum" qui signifie or.',
    },
    {
      'category': 'Culture Générale',
      'question': 'Quelle est la planète la plus proche du Soleil ?',
      'options': ['Vénus', 'Mars', 'Mercure', 'Jupiter'],
      'correctAnswer': 2,
      'explanation': 'Mercure est la planète la plus proche du Soleil.',
    },
    {
      'category': 'Culture Générale',
      'question': 'Qui a découvert la pénicilline ?',
      'options': [
        'Louis Pasteur',
        'Alexander Fleming',
        'Marie Curie',
        'Albert Einstein'
      ],
      'correctAnswer': 1,
      'explanation': 'Alexander Fleming a découvert la pénicilline en 1928.',
    },
    {
      'category': 'Culture Générale',
      'question': 'Quel est le plus grand désert du monde ?',
      'options': ['Gobi', 'Sahara', 'Antarctique', 'Atacama'],
      'correctAnswer': 2,
      'explanation': 'L\'Antarctique est le plus grand désert du monde.',
    },
    {
      'category': 'Culture Générale',
      'question': 'Qui a peint "La Nuit étoilée" ?',
      'options': [
        'Claude Monet',
        'Vincent van Gogh',
        'Pablo Picasso',
        'Salvador Dalí'
      ],
      'correctAnswer': 1,
      'explanation':
          'La Nuit étoilée a été peinte par Vincent van Gogh en 1889.',
    },
    // Flutter
    {
      'category': 'Flutter',
      'question': 'Quel widget est utilisé pour créer une liste défilante ?',
      'options': ['Container', 'ListView', 'Column', 'Row'],
      'correctAnswer': 1,
      'explanation':
          'ListView est le widget idéal pour créer des listes défilantes en Flutter.',
    },
    {
      'category': 'Flutter',
      'question': 'Qu\'est-ce que le "Hot Reload" en Flutter ?',
      'options': [
        'Un café chaud',
        'Mise à jour instantanée du code',
        'Un type d\'animation',
        'Un widget'
      ],
      'correctAnswer': 1,
      'explanation':
          'Hot Reload permet de voir les changements de code instantanément sans redémarrer l\'application.',
    },
    {
      'category': 'Flutter',
      'question':
          'Quel est le langage de programmation principal utilisé pour Flutter ?',
      'options': ['Java', 'Kotlin', 'Dart', 'Swift'],
      'correctAnswer': 2,
      'explanation':
          'Dart est le langage principal de Flutter, créé par Google.',
    },
    {
      'category': 'Flutter',
      'question': 'Qu\'est-ce qu\'un StatefulWidget ?',
      'options': [
        'Un widget qui ne change jamais',
        'Un widget qui peut changer d\'état',
        'Un widget pour les statistiques',
        'Un widget pour les animations'
      ],
      'correctAnswer': 1,
      'explanation':
          'Un StatefulWidget est un widget qui peut changer d\'état pendant son cycle de vie.',
    },
    {
      'category': 'Flutter',
      'question':
          'Quel widget est utilisé pour gérer l\'état global de l\'application ?',
      'options': ['Provider', 'Container', 'Text', 'Image'],
      'correctAnswer': 0,
      'explanation':
          'Provider est un widget populaire pour la gestion d\'état en Flutter.',
    },
    {
      'category': 'Flutter',
      'question': 'Qu\'est-ce que le "Material Design" ?',
      'options': [
        'Un langage de programmation',
        'Un système de design créé par Google',
        'Un framework JavaScript',
        'Une base de données'
      ],
      'correctAnswer': 1,
      'explanation':
          'Material Design est un système de design créé par Google pour créer des interfaces utilisateur cohérentes.',
    },
    {
      'category': 'Flutter',
      'question': 'Quel widget est utilisé pour créer une grille ?',
      'options': ['ListView', 'GridView', 'Column', 'Stack'],
      'correctAnswer': 1,
      'explanation':
          'GridView est utilisé pour créer des layouts en grille en Flutter.',
    },
    {
      'category': 'Flutter',
      'question': 'Qu\'est-ce que le "pubspec.yaml" ?',
      'options': [
        'Un fichier de configuration',
        'Un widget',
        'Une animation',
        'Un plugin'
      ],
      'correctAnswer': 0,
      'explanation':
          'Le pubspec.yaml est le fichier de configuration principal d\'un projet Flutter.',
    },
    {
      'category': 'Flutter',
      'question': 'Quel widget est utilisé pour créer des animations ?',
      'options': ['AnimatedContainer', 'Text', 'Image', 'Button'],
      'correctAnswer': 0,
      'explanation':
          'AnimatedContainer est un widget qui permet de créer des animations fluides.',
    },
    {
      'category': 'Flutter',
      'question': 'Qu\'est-ce que le "Flutter SDK" ?',
      'options': [
        'Un éditeur de code',
        'Un framework de développement',
        'Un système d\'exploitation',
        'Une base de données'
      ],
      'correctAnswer': 1,
      'explanation':
          'Le Flutter SDK est le framework de développement complet pour créer des applications multiplateformes.',
    },
  ];

  int get currentQuestionIndex => _currentQuestionIndex;
  int get score => _score;
  String get selectedCategory => _selectedCategory;
  bool get quizCompleted => _quizCompleted;
  int get timeLeft => _timeLeft;
  bool get isAnswered => _isAnswered;
  int? get selectedAnswerIndex => _selectedAnswerIndex;
  List<int> get timePerQuestion => _timePerQuestion;
  double get averageTimePerQuestion {
    if (_timePerQuestion.isEmpty) return 0;
    return _timePerQuestion.reduce((a, b) => a + b) / _timePerQuestion.length;
  }

  List<Map<String, dynamic>> get questions => _currentQuestions;

  void _shuffleQuestions() {
    final categoryQuestions =
        _allQuestions.where((q) => q['category'] == _selectedCategory).toList();
    categoryQuestions.shuffle(Random());
    _currentQuestions = categoryQuestions.take(10).toList();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    resetQuiz();
    notifyListeners();
  }

  void startTimer() {
    _timer?.cancel();
    _timeLeft = 20;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0 && !_isAnswered) {
        _timeLeft--;
        notifyListeners();
      } else if (_timeLeft == 0 && !_isAnswered) {
        answerQuestion(-1); // Temps écoulé
      }
    });
  }

  void answerQuestion(int selectedOption) {
    if (_isAnswered) return;

    _isAnswered = true;
    _selectedAnswerIndex = selectedOption;
    _timePerQuestion.add(20 - _timeLeft);
    _timer?.cancel();

    if (selectedOption == questions[_currentQuestionIndex]['correctAnswer']) {
      _score++;
    }

    notifyListeners();

    // Attendre 2 secondes avant de passer à la question suivante
    Future.delayed(const Duration(seconds: 2), () {
      if (_currentQuestionIndex < questions.length - 1) {
        _currentQuestionIndex++;
        _isAnswered = false;
        _selectedAnswerIndex = null;
        startTimer();
      } else {
        _quizCompleted = true;
        _timer?.cancel();
      }
      notifyListeners();
    });
  }

  void resetQuiz() {
    _currentQuestionIndex = 0;
    _score = 0;
    _quizCompleted = false;
    _isAnswered = false;
    _selectedAnswerIndex = null;
    _timePerQuestion = [];
    _timer?.cancel();
    _shuffleQuestions();
    startTimer();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
