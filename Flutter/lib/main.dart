
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// عنوان اللابتوب الذي يعمل عليه Node-RED.
// إذا تغيّر IP اللابتوب لاحقاً غيّر هذا السطر فقط.
const String nodeRedBaseUrl = 'http://192.168.0.102:1880';

class ApiService {
  static Future<Map<String, dynamic>> getScores() async {
    final response = await http
        .get(Uri.parse('$nodeRedBaseUrl/api/scores'))
        .timeout(const Duration(seconds: 5));

    if (response.statusCode != 200) {
      throw Exception('GET /api/scores failed: ${response.statusCode}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  static Future<Map<String, dynamic>> resetRound() async {
    final response = await http
        .post(Uri.parse('$nodeRedBaseUrl/api/reset-round'))
        .timeout(const Duration(seconds: 5));

    if (response.statusCode != 200) {
      throw Exception('POST /api/reset-round failed: ${response.statusCode}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مسابقة الضغطة الأولى',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.purple,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.purple,
          accentColor: const Color(0xFFE1BEE7),
          backgroundColor: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/admin': (context) => const AdminPage(),
        '/players': (context) => const PlayersPage(),
        '/results': (context) => const ResultsPage(),
        '/about': (context) => const AboutPage(),
      },
    );
  }
}

// قائمة الأسئلة الكاملة (بدون تصنيف)
final List<Map<String, dynamic>> allQuestions = [
  {
    'id': 1,
    'question': 'ما هو نظام التشغيل مفتوح المصدر ؟',
    'options': ['Windows', 'Linux', 'macOS', 'Android'],
    'correct': 1,
  },
  {
    'id': 2,
    'question': 'أي لغة برمجة تستخدم لتطوير تطبيقات Android ؟',
    'options': ['Java', 'Python', 'C++', 'Swift'],
    'correct': 0,
  },
  {
    'id': 3,
    'question': 'ما هي لغة ترميز النصوص التشعبية ؟',
    'options': ['HTML', 'CSS', 'JavaScript', 'PHP'],
    'correct': 0,
  },
  {
    'id': 4,
    'question': 'أي من هذه ليست لغة برمجة ؟',
    'options': ['Python', 'HTML', 'Java', 'C++'],
    'correct': 1,
  },
  {
    'id': 5,
    'question': 'ما هو بروتوكول نقل النص التشعبي ؟',
    'options': ['HTTPS', 'FTP', 'HTTP', 'SMTP'],
    'correct': 2,
  },
  {
    'id': 6,
    'question': 'أي من هذه قواعد بيانات علائقية ؟',
    'options': ['MongoDB', 'MySQL', 'Redis', 'Firebase'],
    'correct': 1,
  },
  {
    'id': 7,
    'question': 'ما هو الـ IP المعروف باسم localhost ؟',
    'options': ['192.168.1.1', '10.0.0.1', '127.0.0.1', '172.16.0.1'],
    'correct': 2,
  },
  {
    'id': 8,
    'question': 'أي من هذه ليس نظام تشغيل للهواتف ؟',
    'options': ['iOS', 'Android', 'Windows Phone', 'Linux Desktop'],
    'correct': 3,
  },
  {
    'id': 9,
    'question': '  تستخدم لغة الـ CSS لـ ؟',
    'options': ['تصميم الواجهات', 'البرمجة المنطقية', 'قواعد البيانات', 'الذكاء الاصطناعي'],
    'correct': 0,
  },
  {
    'id': 10,
    'question': 'أي من هذه ليس لغة برمجة نصية ؟',
    'options': ['JavaScript', 'Python', 'PHP', 'C#'],
    'correct': 3,
  },
  {
    'id': 11,
    'question': 'ما هو بروتوكول البريد الإلكتروني ؟',
    'options': ['SMTP', 'HTTP', 'FTP', 'TCP'],
    'correct': 0,
  },
  {
    'id': 12,
    'question': 'أي من هذه هو إطار عمل جافا سكريبت ؟',
    'options': ['React', 'Django', 'Laravel', 'Spring'],
    'correct': 0,
  },
  {
    'id': 13,
    'question': 'ما هي وحدة المعالجة المركزية ؟',
    'options': ['الذاكرة', 'القرص الصلب', 'المعالج', 'كارت الشاشة'],
    'correct': 2,
  },
  {
    'id': 14,
    'question': 'أي من هذه ليس نوع من الذاكرة ؟',
    'options': ['RAM', 'ROM', 'CPU', 'Cache'],
    'correct': 2,
  },
  {
    'id': 15,
    'question': 'ما هو الـ DNS ؟',
    'options': ['خادم أسماءالنطاقات', 'بروتوكول نقل', 'لغة برمجة', 'نظام تشغيل'],
    'correct': 0,
  },
  {
    'id': 16,
    'question': 'أي من هذه يستخدم للتحكم بالإصدارات ؟',
    'options': ['Git', 'Docker', 'Kubernetes', 'Jenkins'],
    'correct': 0,
  },
  {
    'id': 17,
    'question': 'ما هو نظام التشغيل من Apple ؟',
    'options': ['Windows', 'Linux', 'macOS', 'Android'],
    'correct': 2,
  },
  {
    'id': 18,
    'question': 'أي من هذه ليس نوع من قواعد البيانات ؟',
    'options': ['علائقية', 'وثائقية', 'بيانية', 'خطية'],
    'correct': 3,
  },
  {
    'id': 19,
    'question': 'ما هو الـ API ؟',
    'options': ['واجهةبرمجةالتطبيقات', 'لغة برمجة', 'نظام تشغيل', 'خادم ويب'],
    'correct': 0,
  },
  {
    'id': 20,
    'question': 'أي من هذه هو نظام إدارة محتوى ؟',
    'options': ['WordPress', 'React', 'Angular', 'Node.js'],
    'correct': 0,
  },
];

// ------------------- الصفحة الرئيسية -------------------
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'مرحباً بك في',
              style: TextStyle(
                fontSize: 28,
                color: Color(0xFF7B1FA2),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'مسابقة الضغطة الأولى للأفضل',
              style: TextStyle(
                fontSize: 32,
                color: Color(0xFF7B1FA2),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            _buildVerticalButton(
              context: context,
              icon: Icons.admin_panel_settings,
              label: 'الإدارة',
              color: const Color(0xFFE1BEE7),
              onPressed: () => Navigator.pushNamed(context, '/admin'),
            ),
            const SizedBox(height: 20),
            _buildVerticalButton(
              context: context,
              icon: Icons.people,
              label: 'اللاعبين',
              color: const Color(0xFFE1BEE7),
              onPressed: () => Navigator.pushNamed(context, '/players'),
            ),
            const SizedBox(height: 20),
            _buildVerticalButton(
              context: context,
              icon: Icons.leaderboard,
              label: 'النتائج',
              color: const Color(0xFFE1BEE7),
              onPressed: () => Navigator.pushNamed(context, '/results'),
            ),
            const SizedBox(height: 20),
            _buildVerticalButton(
              context: context,
              icon: Icons.lightbulb_outline,
              label: ' فكرة اللعبة',
              color: const Color(0xFFE1BEE7),
              onPressed: () => Navigator.pushNamed(context, '/about'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(40),
          boxShadow: const [
            BoxShadow(
              color: Colors.white,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------- صفحة الإدارة (معدلة) -------------------
class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  bool isRoundActive = false;
  bool buttonsEnabled = true;
  int currentQuestionIndex = 0;
  int totalQuestions = allQuestions.length;
  String selectedAnswer = '';

// أسماء اللاعبين
  List<TextEditingController> nameControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void initState() {
    super.initState();
    _loadPlayerNames();
  }

  Future<void> _loadPlayerNames() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < nameControllers.length; i++) {
      String savedName = prefs.getString('playerName_$i') ?? 'لاعب ${i + 1}';
      nameControllers[i].text = savedName;
    }
    setState(() {});
  }

  Future<void> _savePlayerName(int index, String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('playerName_$index', name.trim().isEmpty ? 'لاعب ${index + 1}' : name);
  }

  Future<void> _resetRoundFromNodeRed() async {
    try {
      final data = await ApiService.resetRound();

      if (!mounted) return;

      setState(() {
        isRoundActive = true;
        buttonsEnabled = true;
        selectedAnswer = '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            data['message']?.toString() ?? 'تم فتح الجولة من جديد',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تعذر الاتصال بـ Node-RED: $e',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  Map<String, dynamic> get currentQuestion {
    if (currentQuestionIndex < allQuestions.length) {
      return allQuestions[currentQuestionIndex];
    }
    return allQuestions[0];
  }

  @override
  Widget build(BuildContext context) {
    const Color lightPurple = Color(0xFFE1BEE7);
    final Color lightPurpleHalf = Color.fromARGB(
      (0.5 * 255).round().clamp(0, 255),
      (lightPurple.r * 255).round().clamp(0, 255),
      (lightPurple.g * 255).round().clamp(0, 255),
      (lightPurple.b * 255).round().clamp(0, 255),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('لوحة تحكم الإدارة', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: lightPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('حالة الجولة', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Switch(
                          value: isRoundActive,
                          onChanged: (value) => setState(() => isRoundActive = value),
                          activeThumbColor: lightPurple,
                          activeTrackColor: lightPurpleHalf,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('السؤال ${currentQuestionIndex + 1} من $totalQuestions', style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(currentQuestion['question'], style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
// أزرار التحكم (مصغرة)
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.8,
              children: [
                _buildSmallControlButton('بدء الجولة', Icons.play_arrow, () async {
                  await _resetRoundFromNodeRed();
                }),
                _buildSmallControlButton('إيقاف الجولة', Icons.stop, () {
                  setState(() => isRoundActive = false);
                }),
                _buildSmallControlButton('إعادة التهيئة', Icons.refresh, () async {
                  setState(() {
                    currentQuestionIndex = 0;
                    selectedAnswer = '';
                    buttonsEnabled = true;
                  });
                  await _resetRoundFromNodeRed();
                }),
                _buildSmallControlButton('السؤال التالي', Icons.arrow_forward, () {
                  if (currentQuestionIndex < totalQuestions - 1) {
                    setState(() => currentQuestionIndex++);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('هذا آخر سؤال', style: TextStyle(fontWeight: FontWeight.bold))),
                    );
                  }
                }),
              ],
            ),
            const SizedBox(height: 20),
// كارد إدارة اللاعبين (إدخال الأسماء)
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('إدارة اللاعبين', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    for (int i = 0; i < nameControllers.length; i++)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TextField(
                          controller: nameControllers[i],
                          decoration: InputDecoration(
                            labelText: 'اسم اللاعب ${i + 1}',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.save, size: 20),
                              onPressed: () => _savePlayerName(i, nameControllers[i].text),
                            ),
                          ),
                          onChanged: (value) => _savePlayerName(i, value),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'سيتم حفظ الأسماء تلقائياً',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: 45,
        height: 45,
        child: FloatingActionButton(
          mini: true,
          onPressed: () => Navigator.pop(context),
          backgroundColor: lightPurple,
          child: const Icon(Icons.home, size: 24),
        ),
      ),
    );
  }

// زر تحكم صغير الحجم
  Widget _buildSmallControlButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFE1BEE7),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        minimumSize: const Size(0, 36),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// ------------------- صفحة اللاعبين (المعدلة لاستخدام الأسماء المخزنة وحفظ النقاط) -------------------
class PlayersPage extends StatefulWidget {
  const PlayersPage({Key? key}) : super(key: key);

  @override
  _PlayersPageState createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  String firstPlayer = 'لم يضغط أحد';
  String roundStatus = 'بانتظار الجولة';
  int currentQuestionIndex = 0;
  int timeLeft = 20;
  Timer? timer;
  bool roundActive = true;
  bool answerSubmitted = false;
  bool isCorrect = false;
  int? answeringPlayer;
  List<int> playerScores = [0, 0, 0];
  bool timerPaused = false;
  List<String> playerNames = ['لاعب 1', 'لاعب 2', 'لاعب 3'];

  @override
  void initState() {
    super.initState();
    _loadPlayerNames();
    _loadSavedScores();
    _startTimer();
  }

  Future<void> _loadPlayerNames() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> names = [];
    for (int i = 0; i < 3; i++) {
      names.add(prefs.getString('playerName_$i') ?? 'لاعب ${i + 1}');
    }
    if (!mounted) return;

    setState(() {
      playerNames = names;
    });
  }

  Future<void> _loadSavedScores() async {
    final prefs = await SharedPreferences.getInstance();

    final scores = [
      prefs.getInt('playerScore_0') ?? 0,
      prefs.getInt('playerScore_1') ?? 0,
      prefs.getInt('playerScore_2') ?? 0,
    ];

    if (!mounted) return;

    setState(() {
      playerScores = scores;
    });
  }

  Future<void> _savePlayerScores() async {
    final prefs = await SharedPreferences.getInstance();

    for (int i = 0; i < 3; i++) {
      await prefs.setInt('playerScore_$i', playerScores[i]);
    }
  }

  Map<String, dynamic> get currentQuestion {
    if (currentQuestionIndex < allQuestions.length) {
      return allQuestions[currentQuestionIndex];
    }
    return allQuestions[0];
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!timerPaused && roundActive && !answerSubmitted) {
        if (timeLeft > 0) {
          setState(() => timeLeft--);
        } else {
          timer.cancel();
          _timeOut();
        }
      }
    });
  }

  void _pauseTimer() {
    setState(() {
      timerPaused = true;
    });
  }

  void _resumeTimer() {
    setState(() {
      timerPaused = false;
    });
  }

  void _timeOut() {
    setState(() {
      roundActive = false;
      if (!answerSubmitted) {
        answerSubmitted = true;
        isCorrect = false;
        answeringPlayer = null;
      }
    });
  }

  Future<void> _onOptionPressed(int optionIndex) async {
    if (!roundActive) return;
    if (answerSubmitted) return;

    final int? playerId = await _showPlayerDialog();
    if (playerId == null) return;

    int correctIndex = currentQuestion['correct'] as int;
    bool correct = (optionIndex == correctIndex);

    setState(() {
      answerSubmitted = true;
      roundActive = false;
      isCorrect = correct;
      answeringPlayer = playerId;

// إضافة نقطة واحدة فقط للاعب الذي أجاب إجابة صحيحة.
      if (correct) {
        playerScores[playerId] += 1;
      }
    });

// حفظ النتائج مباشرة حتى تظهر بنفس القيم في صفحة النتائج.
    await _savePlayerScores();
    timer?.cancel();
  }

  Future<int?> _showPlayerDialog() {
    return showDialog<int>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('من أنت؟', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('اختر اسمك:'),
              const SizedBox(height: 20),
              ...List.generate(3, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE1BEE7),
                      minimumSize: const Size(150, 45),
                    ),
                    child: Text(
                      playerNames[index],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _nextQuestion() {
    if (currentQuestionIndex < allQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        timeLeft = 20;
        answerSubmitted = false;
        roundActive = true;
        isCorrect = false;
        answeringPlayer = null;
        timerPaused = false;
      });
      _startTimer();
      ApiService.resetRound().catchError((e) {
        debugPrint('تعذر فتح الجولة الجديدة في Node-RED: $e');
        return <String, dynamic>{};
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('نهاية المسابقة!', style: TextStyle(fontWeight: FontWeight.bold))),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color lightPurple = Color(0xFFE1BEE7);
    const double buttonWidth = 130;
    const double buttonHeight = 50;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(' واجهة اللاعبين ', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: lightPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Column(
                children: [
                  const Text('الوقت المتبقي', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: timeLeft <= 5 ? Colors.redAccent : lightPurple,
                    ),
                    child: Center(
                      child: Text('$timeLeft', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  IconButton(
                    icon: Icon(timerPaused ? Icons.play_arrow : Icons.pause),
                    onPressed: timerPaused ? _resumeTimer : _pauseTimer,
                    color: lightPurple,
                    iconSize: 36,
                  ),
                ],
              ),
            ),
            Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  currentQuestion['question'],
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (!answerSubmitted && roundActive)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: List.generate(currentQuestion['options'].length, (index) {
                    return SizedBox(
                      width: buttonWidth,
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: () => _onOptionPressed(index),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: lightPurple,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(
                          '${String.fromCharCode(65 + index)}. ${currentQuestion['options'][index]}',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            if (answerSubmitted)
              Card(
                color: isCorrect ? Colors.green[100] : Colors.red[100],
                margin: const EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      Icon(isCorrect ? Icons.check_circle : Icons.cancel, size: 50, color: isCorrect ? Colors.green : Colors.red),
                      Text(isCorrect ? 'إجابة صحيحة!' : 'إجابة خاطئة', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      if (isCorrect && answeringPlayer != null)
                        Text('الإجابة الصحيحة بواسطة ${playerNames[answeringPlayer!]}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('الإجابة الصحيحة: ${String.fromCharCode(65 + (currentQuestion['correct'] as int))}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.only(bottom: 30, top: 10, left: 16, right: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('نتائج اللاعبين', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  for (int i = 0; i < 3; i++) ...[
                    Text(
                      playerNames[i],
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${playerScores[i]} نقطة',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                    const SizedBox(height: 14),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 45,
            height: 45,
            child: FloatingActionButton(
              mini: true,
              onPressed: (answerSubmitted || !roundActive) ? _nextQuestion : null,
              backgroundColor: lightPurple,
              child: const Icon(Icons.arrow_forward, size: 24),
              heroTag: 'next',
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 45,
            height: 45,
            child: FloatingActionButton(
              mini: true,
              onPressed: () => Navigator.pop(context),
              backgroundColor: lightPurple,
              child: const Icon(Icons.home, size: 24),
              heroTag: 'home',
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------- صفحة النتائج -------------------
class ResultsPage extends StatefulWidget {
  const ResultsPage({Key? key}) : super(key: key);

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  List<Map<String, dynamic>> results = [];

  List<String> playerNames = [
    'لاعب 1',
    'لاعب 2',
    'لاعب 3',
  ];

  List<int> playerScores = [0, 0, 0];

  Timer? _updateTimer;

  @override
  void initState() {
    super.initState();

    // تحميل النتائج مباشرة عند فتح الصفحة.
    _loadData();

    // تحديث النتائج تلقائياً كل ثانية من القيم المحفوظة في صفحة اللاعبين.
    _updateTimer = Timer.periodic(
      const Duration(seconds: 1),
          (timer) {
        _loadData();
      },
    );
  }

  @override
  void dispose() {
    _updateTimer?.cancel();
    super.dispose();
  }

  // تحميل أسماء اللاعبين والنقاط المحفوظة من صفحة اللاعبين.
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();

    final names = [
      prefs.getString('playerName_0') ?? 'لاعب 1',
      prefs.getString('playerName_1') ?? 'لاعب 2',
      prefs.getString('playerName_2') ?? 'لاعب 3',
    ];

    final scores = [
      prefs.getInt('playerScore_0') ?? 0,
      prefs.getInt('playerScore_1') ?? 0,
      prefs.getInt('playerScore_2') ?? 0,
    ];

    if (!mounted) return;

    playerNames = names;
    playerScores = scores;

    _updateResults();
  }

  // حفظ نتائج اللاعبين من صفحة النتائج.
  Future<void> _saveResults() async {
    final prefs = await SharedPreferences.getInstance();

    for (int i = 0; i < 3; i++) {
      await prefs.setString('playerName_$i', playerNames[i]);
      await prefs.setInt('playerScore_$i', playerScores[i]);
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'تم حفظ نتائج اللاعبين بنجاح ✅',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ترتيب اللاعبين من أعلى نقاط إلى أقل نقاط.
  void _updateResults() {
    final newResults = List<Map<String, dynamic>>.generate(
      3,
          (index) => {
        'name': playerNames[index],
        'score': playerScores[index],
      },
    );

    newResults.sort(
          (a, b) => (b['score'] as int).compareTo(a['score'] as int),
    );

    if (!mounted) return;

    setState(() {
      results = newResults;
    });
  }

  Color _getRankColor(int index) {
    if (index == 0) {
      return const Color(0xFFCE93D8);
    }

    return const Color(0xFFE0E0E0);
  }

  @override
  Widget build(BuildContext context) {
    const Color lightPurple = Color(0xFFE1BEE7);

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          'نتائج المسابقة',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: lightPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveResults,
            tooltip: 'حفظ النتائج',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'تحديث النتائج',
          ),
        ],
      ),

      body: Column(
        children: [
          // عرض صاحب أعلى نقاط كفائز.
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const Icon(
                  Icons.emoji_events,
                  size: 70,
                  color: Color(0xFFCE93D8),
                ),

                const SizedBox(height: 8),

                const Text(
                  'الفائز',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                if (results.isNotEmpty &&
                    (results[0]['score'] as int) > 0) ...[
                  Text(
                    results[0]['name'].toString(),
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7B1FA2),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    '${results[0]['score']} نقطة',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ] else ...[
                  const Text(
                    'لا يوجد فائز حتى الآن',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const Divider(),

          // ترتيب جميع اللاعبين.
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final player = results[index];

                return Card(
                  elevation: index == 0 ? 5 : 2,
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),

                    leading: CircleAvatar(
                      backgroundColor: _getRankColor(index),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    title: Text(
                      player['name'].toString(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: index == 0
                            ? FontWeight.bold
                            : FontWeight.w600,
                      ),
                    ),

                    subtitle: index == 0 &&
                        (player['score'] as int) > 0
                        ? const Text(
                      '🏆 المركز الأول',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    )
                        : null,

                    trailing: Text(
                      '${player['score']} نقطة',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      floatingActionButton: SizedBox(
        width: 45,
        height: 45,
        child: FloatingActionButton(
          mini: true,
          onPressed: () => Navigator.pop(context),
          backgroundColor: lightPurple,
          child: const Icon(Icons.home),
        ),
      ),
    );
  }
}

// ------------------- صفحة فكرة اللعبة -------------------
class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color lightPurple = Color(0xFFE1BEE7);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('فكرة اللعبة', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: lightPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(Icons.lightbulb_outline, size: 80, color: Color(0xFFCE93D8)),
              const SizedBox(height: 20),
              const Text('فكرة مسابقة الضغطة الأولى', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                    'لعبة مسابقة سريعة بين 3 لاعبين\n\n'
                        'يظهر سؤال لكل جولة مع خيارات الإجابة مباشرة.\n\n'
                        'أول لاعب يضغط على أي خيار، يظهر له مربع حوار لاختيار اسمه.\n\n'
                        'يتم تسجيل إجابته فوراً وإضافة النقاط إذا كانت صحيحة.\n\n'
                        'يمكن إيقاف المؤقت مؤقتاً باستخدام الزر أسفله.\n\n'
                        'إذا انتهى الوقت دون ضغط أي لاعب، تعتبر الإجابة خاطئة.\n\n'
                        'الفائز هو من يحصل على أعلى النقاط في نهاية المسابقة.',
                    style: TextStyle(fontSize: 18, height: 1.5, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text('مميزات اللعبة:', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: const Column(
                    children: [
                      ListTile(leading: Icon(Icons.group, color: Color(0xFFE1BEE7)), title: Text('3 لاعبين', style: TextStyle(fontWeight: FontWeight.bold))),
                      ListTile(leading: Icon(Icons.timer, color: Color(0xFFE1BEE7)), title: Text('20 ثانية لكل سؤال', style: TextStyle(fontWeight: FontWeight.bold))),
                      ListTile(leading: Icon(Icons.question_answer, color: Color(0xFFE1BEE7)), title: Text('20 سؤال متنوع', style: TextStyle(fontWeight: FontWeight.bold))),
                      ListTile(leading: Icon(Icons.emoji_events, color: Color(0xFFE1BEE7)), title: Text('نظام نقاط واضح', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: SizedBox(
        width: 45,
        height: 45,
        child: FloatingActionButton(
          mini: true,
          onPressed: () => Navigator.pop(context),
          backgroundColor: lightPurple,
          child: const Icon(Icons.home, size: 24),
        ),
      ),
    );
  }
}
