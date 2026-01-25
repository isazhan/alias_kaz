import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Ойын деректері
  List<String> _words = [];
  int _currentIndex = 0;
  int _timeLeft = 60;
  Timer? _timer;
  int targetScore = 0;
  
  bool _isRoundActive = false; // Раунд жүріп жатыр ма?
  bool _isInitialized = false;

  // Командалар мен ұпайлар
  late List<String> teams;
  int currentTeamIndex = 0;
  Map<String, int> teamScores = {};

  double _swipeOffset = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final args = ModalRoute.of(context)!.settings.arguments as Map;
      teams = List<String>.from(args['teams']);
      targetScore = args['targetScore'];
      for (var team in teams) {
        teamScores[team] = 0;
      }
      _loadWords(args['difficulty']);
      _isInitialized = true;
    }
  }

  // Обязательно добавляем dispose
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateScore(bool isCorrect) {
    HapticFeedback.lightImpact(); // Добавим тактильную отдачу при свайпе
    setState(() {
      String currentTeam = teams[currentTeamIndex];
      if (isCorrect) {
        teamScores[currentTeam] = (teamScores[currentTeam] ?? 0) + 1;
        
        // Жеңісті тексеру
        if (teamScores[currentTeam]! >= targetScore) {
          _showWinnerDialog(currentTeam);
        }
      } else {
        teamScores[currentTeam] = (teamScores[currentTeam] ?? 0) - 1;
      }
      
      // Чтобы слова не заканчивались резко
      if (_currentIndex < _words.length - 1) {
        _currentIndex++;
      } else {
        _words.shuffle();
        _currentIndex = 0;
      }
    });
  }

  void _showWinnerDialog(String winner) {
    _timer?.cancel(); // Таймерді тоқтату
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('ЖЕҢІС! 🎉'),
        content: Text('$winner командасы бірінші болып $targetScore ұпай жинады!'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/')), 
            child: const Text('Мәзірге қайту'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadWords(String difficulty) async {
    final String response = await rootBundle.loadString('assets/data.json');
    final data = json.decode(response);
    String key = difficulty == 'Оңай' ? 'easy' : (difficulty == 'Орташа' ? 'medium' : 'hard');
    
    setState(() {
      _words = List<String>.from(data[key]);
      _words.shuffle();
    });
  }

  void _startRound() {
    setState(() {
      _isRoundActive = true;
      _timeLeft = 60;
    });
    _timer?.cancel(); // На всякий случай отменяем старый таймер
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        timer.cancel();
        _finishRound();
      }
    });
  }

  void _finishRound() {
    setState(() => _isRoundActive = false);
    HapticFeedback.heavyImpact(); // Раунд біткенде діріл
  }

  void _nextTurn() {
    setState(() {
      currentTeamIndex = (currentTeamIndex + 1) % teams.length;
      _currentIndex = (_currentIndex + 1) % _words.length; // Жаңа сөзден бастау
    });
  }

  void _handleSwipeEnd() {
    if (_swipeOffset < -120) {
      _updateScore(true); // Жоғары - дұрыс
    } else if (_swipeOffset > 120) {
      _updateScore(false); // Төмен - қате
    }
    setState(() => _swipeOffset = 0);
  }

  @override
  Widget build(BuildContext context) {
    // Безопасная проверка на пустой список команд
    if (teams.isEmpty) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    
    String currentTeam = teams[currentTeamIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: AnimatedSwitcher( // Добавляем плавный переход между экранами
          duration: const Duration(milliseconds: 300),
          child: _isRoundActive ? _buildGameUI(currentTeam) : _buildScoreboardUI(currentTeam),
        ),
      ),
    );
  }

  // Ойын барысы (Свайп-круг)
  Widget _buildGameUI(String teamName) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _badge("Уақыт: $_timeLeft", Colors.orange),
              _badge(teamName, Colors.blue),
              _badge("Ұпай: ${teamScores[teamName]}", Colors.green),
            ],
          ),
        ),
        Expanded(
          child: GestureDetector(
            onVerticalDragUpdate: (d) => setState(() => _swipeOffset += d.delta.dy),
            onVerticalDragEnd: (d) => _handleSwipeEnd(),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  _swipeIndicator(),
                  AnimatedContainer( // Плавное движение круга
                    duration: const Duration(milliseconds: 50),
                    transform: Matrix4.translationValues(0, _swipeOffset, 0),
                    child: Container(
                      width: 280, height: 280,
                      decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _swipeOffset < -50 ? Colors.green.withOpacity(0.5) : 
                                   _swipeOffset > 50 ? Colors.red.withOpacity(0.5) : Colors.white24, 
                            blurRadius: 30
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        _words.isEmpty ? "Жүктеу..." : _words[_currentIndex],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 40),
          child: Text("⬆ Дұрыс | Төмен ⬇ Қате", style: TextStyle(color: Colors.white38)),
        )
      ],
    );
  }

  // Раунд арасындағы экран (Ұпайлар кестесі)
  Widget _buildScoreboardUI(String currentTeam) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("ЖАЛПЫ ЕСЕП", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
          ...teams.map((team) => Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: team == currentTeam ? Colors.blue.withOpacity(0.3) : Colors.white10,
              borderRadius: BorderRadius.circular(15),
              border: team == currentTeam ? Border.all(color: Colors.blue) : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(team, style: const TextStyle(color: Colors.white, fontSize: 20)),
                Text("${teamScores[team]}", style: const TextStyle(color: Colors.greenAccent, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          )),
          const SizedBox(height: 50),
          Text("Келесі кезек: $currentTeam", style: const TextStyle(color: Colors.amber, fontSize: 20)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _timeLeft == 0 ? () { _nextTurn(); _startRound(); } : _startRound,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15)),
            child: Text(_timeLeft == 60 ? "БАСТАУ" : "КЕЛЕСІ РАУНД", style: const TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(10), border: Border.all(color: color)),
      child: Text(text, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
    );
  }

  Widget _swipeIndicator() {
    if (_swipeOffset.abs() < 50) return const SizedBox();
    return Text(_swipeOffset < 0 ? "ДҰРЫС +1" : "ӨТКІЗУ -1",
        style: TextStyle(color: _swipeOffset < 0 ? Colors.green : Colors.red, fontSize: 28, fontWeight: FontWeight.bold));
  }
}