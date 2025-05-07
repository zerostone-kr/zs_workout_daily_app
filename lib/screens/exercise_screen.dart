import 'package:flutter/material.dart';

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
                            Row(
                              children: [
                                if (showWeight) ...[
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(labelText: '무게 (kg)'),
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) => ex.weight = double.tryParse(val),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                ],
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(labelText: '반복 횟수'),
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) => ex.reps = int.tryParse(val) ?? 0,
                                  ),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    decoration: InputDecoration(labelText: '세트 수'),
                                    keyboardType: TextInputType.number,
                                    onChanged: (val) => ex.sets = int.tryParse(val) ?? 0,
                                  ),
                                ),
                              ],
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