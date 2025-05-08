import 'package:flutter/material.dart';
import '../services/exercise_record_service.dart'; // hypothetical service

class ExerciseScreen extends StatefulWidget {
  final DateTime selectedDate;

  const ExerciseScreen({super.key, required this.selectedDate});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class RecordedExercise {
  final String name;
  int sets;
  int reps;
  double? weight;

  RecordedExercise({required this.name, this.sets = 0, this.reps = 0, this.weight});
}

class _ExerciseScreenState extends State<ExerciseScreen> with TickerProviderStateMixin {
  String? _selectedExercise;

  final List<Map<String, String>> allExercises = [
    {'ko': '벤치프레스', 'en': 'Bench Press', 'cat': '상체'},
    {'ko': '푸쉬업', 'en': 'Push-up', 'cat': '상체'},
    {'ko': '숄더프레스', 'en': 'Shoulder Press', 'cat': '상체'},
    {'ko': '바벨 컬', 'en': 'Barbell Curl', 'cat': '상체'},
    {'ko': '랫풀다운', 'en': 'Lat Pulldown', 'cat': '상체'},
    {'ko': '트라이셉스 익스텐션', 'en': 'Triceps Extension', 'cat': '상체'},
    {'ko': '스쿼트', 'en': 'Squat', 'cat': '하체'},
    {'ko': '런지', 'en': 'Lunge', 'cat': '하체'},
    {'ko': '레그프레스', 'en': 'Leg Press', 'cat': '하체'},
    {'ko': '힙쓰러스트', 'en': 'Hip Thrust', 'cat': '하체'},
    {'ko': '카프레이즈', 'en': 'Calf Raise', 'cat': '하체'},
    {'ko': '크런치', 'en': 'Crunch', 'cat': '코어'},
    {'ko': '플랭크', 'en': 'Plank', 'cat': '코어'},
    {'ko': '러시안 트위스트', 'en': 'Russian Twist', 'cat': '코어'},
    {'ko': '레그 레이즈', 'en': 'Leg Raise', 'cat': '코어'},
    {'ko': '버드독', 'en': 'Bird Dog', 'cat': '코어'},
  ];

  final Set<String> noWeightExercises = {
    '스쿼트', '푸쉬업', '플랭크', '런지', '크런치', '버드독', '러시안 트위스트', '레그 레이즈'
  };

  final Map<String, String> emojiMap = {
    '벤치프레스': '🏋️‍♂️',
    '푸쉬업': '🙆‍♂️',
    '숄더프레스': '💪',
    '바벨 컬': '🏋️',
    '랫풀다운': '🔽',
    '트라이셉스 익스텐션': '💪',
    '스쿼트': '🦵',
    '런지': '🚶',
    '레그프레스': '🪑',
    '힙쓰러스트': '🍑',
    '카프레이즈': '🦶',
    '크런치': '🔁',
    '플랭크': '🧘',
    '러시안 트위스트': '🔄',
    '레그 레이즈': '🔼',
    '버드독': '🐕',
  };

  List<RecordedExercise> _recordedExercises = [];

  late TabController _mainTabController;

  @override
  void initState() {
    super.initState();
    _mainTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _mainTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.selectedDate.year}-${widget.selectedDate.month}-${widget.selectedDate.day} 운동 기록'),
        centerTitle: true,
        leading: BackButton(onPressed: () => Navigator.pop(context, true)),
        bottom: TabBar(
          controller: _mainTabController,
          tabs: const [
            Tab(text: '헬스'),
            Tab(text: '유산소'),
            Tab(text: '기타'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _mainTabController,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: DropdownButton<String>(
                  value: allExercises.any((e) => _selectedExercise == e['ko']) ? _selectedExercise : null,
                  hint: Text('운동을 선택하세요'),
                  isExpanded: true,
                  items: allExercises.map((exercise) {
                    final emoji = emojiMap[exercise['ko']] ?? '';
                    final label = '(${exercise['cat']}) $emoji ${exercise['ko']} (${exercise['en']})';
                    return DropdownMenuItem(value: exercise['ko'], child: Text(label));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null && !_recordedExercises.any((e) => e.name == value)) {
                      setState(() {
                        _selectedExercise = value;
                        _recordedExercises.add(RecordedExercise(name: value));
                      });
                    }
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _recordedExercises.length,
                  itemBuilder: (context, index) {
                    final ex = _recordedExercises[index];
                    final showWeight = !noWeightExercises.contains(ex.name);

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    ex.name,
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete_outline),
                                  onPressed: () {
                                    setState(() {
                                      _recordedExercises.removeAt(index);
                                    });
                                  },
                                ),
                              ],
                            ),
                            // 🔁 Bottom sheet numeric input button row
                            TextButton(
                              onPressed: () => _openExerciseInputSheet(index), // ⚠️ If _recordedExercises is not accessible here, it's most likely due to a scope or state issue: ensure _recordedExercises is declared in the State class and used consistently (e.g., not shadowed or redeclared elsewhere).
                              child: Text('세부 입력 (무게/횟수/세트)', style: TextStyle(color: Colors.blue)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Center(child: Text('유산소 탭 준비 중')),
          Center(child: Text('기타 탭 준비 중')),
        ],
      ),
    );
  }
}

// 🔁 Reusable NumberInputDialog widget
class NumberInputDialog extends StatefulWidget {
  final int initialValue;
  final String title;

  const NumberInputDialog({required this.initialValue, required this.title});

  @override
  _NumberInputDialogState createState() => _NumberInputDialogState();
}

class _NumberInputDialogState extends State<NumberInputDialog> {
  late int value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () => setState(() => value = (value - 1).clamp(0, 999)),
          ),
          Text('$value', style: TextStyle(fontSize: 24)),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => setState(() => value = (value + 1).clamp(0, 999)),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('취소'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, value),
          child: Text('확인'),
        ),
      ],
    );
  }
}

// === Moved methods inside _ExerciseScreenState ===

extension _ExerciseScreenStateBottomSheet on _ExerciseScreenState {
  // 🔁 Bottom sheet for editing exercise details (무게/횟수/세트) at once
  void _openExerciseInputSheet(int index) {
    final ex = _recordedExercises[index];
    int tempSets = ex.sets;
    int tempReps = ex.reps;
    double tempWeight = ex.weight ?? 0;
    final showWeight = !noWeightExercises.contains(ex.name);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showWeight)
                _buildCounterRow('무게 (kg)', tempWeight.toInt(), (v) {
                  setState(() => tempWeight = v.toDouble());
                }),
              _buildCounterRow('반복 횟수', tempReps, (v) {
                setState(() => tempReps = v);
              }),
              _buildCounterRow('세트 수', tempSets, (v) {
                setState(() => tempSets = v);
              }),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    ex.weight = showWeight ? tempWeight : null;
                    ex.reps = tempReps;
                    ex.sets = tempSets;
                  });
                  Navigator.pop(context);
                },
                child: Text('확인'),
              ),
            ],
          ),
        );
      },
    );
  }

  // 🔁 Helper widget to build a counter row for bottom sheet
  Widget _buildCounterRow(String label, int value, void Function(int) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16)),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove),
                onPressed: () => onChanged((value - 1).clamp(0, 999)),
              ),
              Text('$value', style: TextStyle(fontSize: 18)),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => onChanged((value + 1).clamp(0, 999)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}