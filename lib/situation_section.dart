import 'package:flutter/material.dart';

// Main entry screen for "¿Cuál es mi situación?"
class SituationSection extends StatelessWidget {
  final String language;
  final String state;

  const SituationSection({
    super.key,
    required this.language,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t('my_situation')),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Icon(
              Icons.help_outline,
              size: 64,
              color: Colors.blue.shade700,
            ),
            const SizedBox(height: 24),
            Text(
              _t('questionnaire_title'),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              _t('questionnaire_desc'),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.amber.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.security, color: Colors.amber.shade800),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _t('privacy_notice'),
                        style: TextStyle(
                          color: Colors.amber.shade900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionnaireFlow(
                      language: language,
                      state: state,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _t('start_questionnaire'),
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StatusOverview(language: language),
                  ),
                );
              },
              child: Text(_t('view_all_statuses')),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  String _t(String key) => SituationText.get(key, language);
}

// ===========================================
// QUESTIONNAIRE FLOW
// ===========================================
class QuestionnaireFlow extends StatefulWidget {
  final String language;
  final String state;

  const QuestionnaireFlow({
    super.key,
    required this.language,
    required this.state,
  });

  @override
  State<QuestionnaireFlow> createState() => _QuestionnaireFlowState();
}

class _QuestionnaireFlowState extends State<QuestionnaireFlow> {
  int _currentQuestion = 0;
  final Map<String, String> _answers = {};
  String? _determinedStatus;

  List<Map<String, dynamic>> get _questions => [
    {
      'id': 'birth_place',
      'question': _t('q_birth_place'),
      'options': [
        {'value': 'us', 'label': _t('q_birth_us')},
        {'value': 'territory', 'label': _t('q_birth_territory')},
        {'value': 'abroad', 'label': _t('q_birth_abroad')},
      ],
    },
    {
      'id': 'parents_citizens',
      'question': _t('q_parents_citizens'),
      'condition': (answers) => answers['birth_place'] == 'abroad',
      'options': [
        {'value': 'yes', 'label': _t('yes')},
        {'value': 'no', 'label': _t('no')},
        {'value': 'unsure', 'label': _t('unsure')},
      ],
    },
    {
      'id': 'naturalized',
      'question': _t('q_naturalized'),
      'condition': (answers) => answers['birth_place'] == 'abroad' && answers['parents_citizens'] != 'yes',
      'options': [
        {'value': 'yes', 'label': _t('yes')},
        {'value': 'no', 'label': _t('no')},
      ],
    },
    {
      'id': 'green_card',
      'question': _t('q_green_card'),
      'condition': (answers) => answers['naturalized'] == 'no',
      'options': [
        {'value': 'yes', 'label': _t('yes')},
        {'value': 'no', 'label': _t('no')},
      ],
    },
    {
      'id': 'green_card_years',
      'question': _t('q_green_card_years'),
      'condition': (answers) => answers['green_card'] == 'yes',
      'options': [
        {'value': 'less_5', 'label': _t('q_less_5_years')},
        {'value': '5_plus', 'label': _t('q_5_plus_years')},
      ],
    },
    {
      'id': 'has_visa',
      'question': _t('q_has_visa'),
      'condition': (answers) => answers['green_card'] == 'no',
      'options': [
        {'value': 'work', 'label': _t('q_visa_work')},
        {'value': 'student', 'label': _t('q_visa_student')},
        {'value': 'tourist', 'label': _t('q_visa_tourist')},
        {'value': 'other', 'label': _t('q_visa_other')},
        {'value': 'none', 'label': _t('q_visa_none')},
      ],
    },
    {
      'id': 'daca',
      'question': _t('q_daca'),
      'condition': (answers) => answers['has_visa'] == 'none',
      'options': [
        {'value': 'yes', 'label': _t('yes')},
        {'value': 'no', 'label': _t('no')},
      ],
    },
    {
      'id': 'tps',
      'question': _t('q_tps'),
      'condition': (answers) => answers['has_visa'] == 'none' && answers['daca'] == 'no',
      'options': [
        {'value': 'yes', 'label': _t('yes')},
        {'value': 'no', 'label': _t('no')},
        {'value': 'unsure', 'label': _t('unsure')},
      ],
    },
    {
      'id': 'asylum',
      'question': _t('q_asylum'),
      'condition': (answers) => answers['tps'] == 'no',
      'options': [
        {'value': 'granted', 'label': _t('q_asylum_granted')},
        {'value': 'pending', 'label': _t('q_asylum_pending')},
        {'value': 'no', 'label': _t('no')},
      ],
    },
  ];

  List<Map<String, dynamic>> get _activeQuestions {
    return _questions.where((q) {
      if (q['condition'] == null) return true;
      return (q['condition'] as Function)(_answers);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_determinedStatus != null) {
      return _buildResultScreen();
    }

    final activeQuestions = _activeQuestions;

    if (_currentQuestion >= activeQuestions.length) {
      _determineStatus();
      return _buildResultScreen();
    }

    final question = activeQuestions[_currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: Text('${_currentQuestion + 1} / ${activeQuestions.length}'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestion + 1) / activeQuestions.length,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700),
            ),
            const SizedBox(height: 40),
            Text(
              question['question'] as String,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ...(question['options'] as List).map((option) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildOptionButton(
                  question['id'] as String,
                  option['value'] as String,
                  option['label'] as String,
                ),
              );
            }),
            const Spacer(),
            if (_currentQuestion > 0)
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _currentQuestion--;
                  });
                },
                icon: const Icon(Icons.arrow_back),
                label: Text(_t('back')),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(String questionId, String value, String label) {
    final isSelected = _answers[questionId] == value;

    return OutlinedButton(
      onPressed: () {
        setState(() {
          _answers[questionId] = value;
          // Small delay to show selection before moving on
          Future.delayed(const Duration(milliseconds: 200), () {
            if (mounted) {
              setState(() {
                _currentQuestion++;
                // Re-check if we've reached the end with new answers
                if (_currentQuestion >= _activeQuestions.length) {
                  _determineStatus();
                }
              });
            }
          });
        });
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        side: BorderSide(
          color: isSelected ? Colors.blue.shade700 : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        backgroundColor: isSelected ? Colors.blue.shade50 : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          color: isSelected ? Colors.blue.shade700 : Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  void _determineStatus() {
    String status;

    if (_answers['birth_place'] == 'us' || _answers['birth_place'] == 'territory') {
      status = 'citizen_birth';
    } else if (_answers['parents_citizens'] == 'yes') {
      status = 'citizen_parents';
    } else if (_answers['naturalized'] == 'yes') {
      status = 'citizen_naturalized';
    } else if (_answers['green_card'] == 'yes') {
      if (_answers['green_card_years'] == '5_plus') {
        status = 'green_card_5plus';
      } else {
        status = 'green_card';
      }
    } else if (_answers['has_visa'] == 'work') {
      status = 'visa_work';
    } else if (_answers['has_visa'] == 'student') {
      status = 'visa_student';
    } else if (_answers['has_visa'] == 'tourist') {
      status = 'visa_tourist';
    } else if (_answers['has_visa'] == 'other') {
      status = 'visa_other';
    } else if (_answers['daca'] == 'yes') {
      status = 'daca';
    } else if (_answers['tps'] == 'yes') {
      status = 'tps';
    } else if (_answers['asylum'] == 'granted') {
      status = 'asylee';
    } else if (_answers['asylum'] == 'pending') {
      status = 'asylum_pending';
    } else {
      status = 'undocumented';
    }

    setState(() {
      _determinedStatus = status;
    });
  }

  Widget _buildResultScreen() {
    final statusInfo = _getStatusInfo(_determinedStatus!);

    return Scaffold(
      appBar: AppBar(
        title: Text(_t('your_situation')),
        backgroundColor: statusInfo['color'] as Color,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: (statusInfo['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: (statusInfo['color'] as Color).withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  statusInfo['icon'] as IconData,
                  size: 64,
                  color: statusInfo['color'] as Color,
                ),
                const SizedBox(height: 16),
                Text(
                  statusInfo['title'] as String,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: statusInfo['color'] as Color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            statusInfo['description'] as String,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 24),
          Text(
            _t('key_points'),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...(statusInfo['points'] as List<String>).map((point) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: statusInfo['color'] as Color,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 32),
          if (statusInfo['canNaturalize'] == true) ...[
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.green.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _t('can_naturalize'),
                        style: TextStyle(color: Colors.green.shade900),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Card(
            color: Colors.amber.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.warning_amber, color: Colors.amber.shade800),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _t('disclaimer'),
                      style: TextStyle(
                        color: Colors.amber.shade900,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Pop back to home and could navigate to rights section
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: statusInfo['color'] as Color,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _t('back_to_home'),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () {
              setState(() {
                _currentQuestion = 0;
                _answers.clear();
                _determinedStatus = null;
              });
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _t('retake_questionnaire'),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Map<String, dynamic> _getStatusInfo(String status) {
    final statuses = {
      'citizen_birth': {
        'icon': Icons.flag,
        'color': Colors.green.shade700,
        'title': _t('status_citizen_birth'),
        'description': _t('status_citizen_birth_desc'),
        'points': [
          _t('citizen_point_1'),
          _t('citizen_point_2'),
          _t('citizen_point_3'),
          _t('citizen_point_4'),
        ],
        'canNaturalize': false,
      },
      'citizen_parents': {
        'icon': Icons.flag,
        'color': Colors.green.shade700,
        'title': _t('status_citizen_parents'),
        'description': _t('status_citizen_parents_desc'),
        'points': [
          _t('citizen_point_1'),
          _t('citizen_point_2'),
          _t('citizen_point_3'),
          _t('citizen_parents_point'),
        ],
        'canNaturalize': false,
      },
      'citizen_naturalized': {
        'icon': Icons.flag,
        'color': Colors.green.shade700,
        'title': _t('status_citizen_naturalized'),
        'description': _t('status_citizen_naturalized_desc'),
        'points': [
          _t('citizen_point_1'),
          _t('citizen_point_2'),
          _t('citizen_point_3'),
          _t('naturalized_point'),
        ],
        'canNaturalize': false,
      },
      'green_card': {
        'icon': Icons.card_membership,
        'color': Colors.blue.shade700,
        'title': _t('status_green_card'),
        'description': _t('status_green_card_desc'),
        'points': [
          _t('green_card_point_1'),
          _t('green_card_point_2'),
          _t('green_card_point_3'),
          _t('green_card_point_4'),
        ],
        'canNaturalize': false,
      },
      'green_card_5plus': {
        'icon': Icons.card_membership,
        'color': Colors.blue.shade700,
        'title': _t('status_green_card_5plus'),
        'description': _t('status_green_card_5plus_desc'),
        'points': [
          _t('green_card_point_1'),
          _t('green_card_point_2'),
          _t('green_card_point_3'),
          _t('green_card_5plus_point'),
        ],
        'canNaturalize': true,
      },
      'visa_work': {
        'icon': Icons.work,
        'color': Colors.purple.shade700,
        'title': _t('status_visa_work'),
        'description': _t('status_visa_work_desc'),
        'points': [
          _t('visa_work_point_1'),
          _t('visa_work_point_2'),
          _t('visa_work_point_3'),
          _t('visa_point_rights'),
        ],
        'canNaturalize': false,
      },
      'visa_student': {
        'icon': Icons.school,
        'color': Colors.purple.shade700,
        'title': _t('status_visa_student'),
        'description': _t('status_visa_student_desc'),
        'points': [
          _t('visa_student_point_1'),
          _t('visa_student_point_2'),
          _t('visa_student_point_3'),
          _t('visa_point_rights'),
        ],
        'canNaturalize': false,
      },
      'visa_tourist': {
        'icon': Icons.flight,
        'color': Colors.purple.shade700,
        'title': _t('status_visa_tourist'),
        'description': _t('status_visa_tourist_desc'),
        'points': [
          _t('visa_tourist_point_1'),
          _t('visa_tourist_point_2'),
          _t('visa_tourist_point_3'),
        ],
        'canNaturalize': false,
      },
      'visa_other': {
        'icon': Icons.description,
        'color': Colors.purple.shade700,
        'title': _t('status_visa_other'),
        'description': _t('status_visa_other_desc'),
        'points': [
          _t('visa_other_point_1'),
          _t('visa_other_point_2'),
          _t('visa_point_rights'),
        ],
        'canNaturalize': false,
      },
      'daca': {
        'icon': Icons.shield,
        'color': Colors.orange.shade700,
        'title': _t('status_daca'),
        'description': _t('status_daca_desc'),
        'points': [
          _t('daca_point_1'),
          _t('daca_point_2'),
          _t('daca_point_3'),
          _t('daca_point_4'),
        ],
        'canNaturalize': false,
      },
      'tps': {
        'icon': Icons.shield,
        'color': Colors.orange.shade700,
        'title': _t('status_tps'),
        'description': _t('status_tps_desc'),
        'points': [
          _t('tps_point_1'),
          _t('tps_point_2'),
          _t('tps_point_3'),
          _t('tps_point_4'),
        ],
        'canNaturalize': false,
      },
      'asylee': {
        'icon': Icons.home,
        'color': Colors.teal.shade700,
        'title': _t('status_asylee'),
        'description': _t('status_asylee_desc'),
        'points': [
          _t('asylee_point_1'),
          _t('asylee_point_2'),
          _t('asylee_point_3'),
          _t('asylee_point_4'),
        ],
        'canNaturalize': false,
      },
      'asylum_pending': {
        'icon': Icons.hourglass_empty,
        'color': Colors.teal.shade700,
        'title': _t('status_asylum_pending'),
        'description': _t('status_asylum_pending_desc'),
        'points': [
          _t('asylum_pending_point_1'),
          _t('asylum_pending_point_2'),
          _t('asylum_pending_point_3'),
        ],
        'canNaturalize': false,
      },
      'undocumented': {
        'icon': Icons.info_outline,
        'color': Colors.red.shade700,
        'title': _t('status_undocumented'),
        'description': _t('status_undocumented_desc'),
        'points': [
          _t('undocumented_point_1'),
          _t('undocumented_point_2'),
          _t('undocumented_point_3'),
          _t('undocumented_point_4'),
        ],
        'canNaturalize': false,
      },
    };

    return statuses[status] ?? statuses['undocumented']!;
  }

  String _t(String key) => SituationText.get(key, widget.language);
}

// ===========================================
// STATUS OVERVIEW - View all statuses
// ===========================================
class StatusOverview extends StatelessWidget {
  final String language;

  const StatusOverview({
    super.key,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final statuses = [
      {
        'id': 'citizen',
        'icon': Icons.flag,
        'color': Colors.green.shade700,
        'title': _t('overview_citizen'),
        'desc': _t('overview_citizen_desc'),
      },
      {
        'id': 'green_card',
        'icon': Icons.card_membership,
        'color': Colors.blue.shade700,
        'title': _t('overview_green_card'),
        'desc': _t('overview_green_card_desc'),
      },
      {
        'id': 'visa',
        'icon': Icons.description,
        'color': Colors.purple.shade700,
        'title': _t('overview_visa'),
        'desc': _t('overview_visa_desc'),
      },
      {
        'id': 'daca',
        'icon': Icons.shield,
        'color': Colors.orange.shade700,
        'title': _t('overview_daca'),
        'desc': _t('overview_daca_desc'),
      },
      {
        'id': 'tps',
        'icon': Icons.shield_outlined,
        'color': Colors.orange.shade600,
        'title': _t('overview_tps'),
        'desc': _t('overview_tps_desc'),
      },
      {
        'id': 'asylum',
        'icon': Icons.home,
        'color': Colors.teal.shade700,
        'title': _t('overview_asylum'),
        'desc': _t('overview_asylum_desc'),
      },
      {
        'id': 'undocumented',
        'icon': Icons.info_outline,
        'color': Colors.red.shade700,
        'title': _t('overview_undocumented'),
        'desc': _t('overview_undocumented_desc'),
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_t('all_statuses')),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          final status = statuses[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (status['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  status['icon'] as IconData,
                  color: status['color'] as Color,
                ),
              ),
              title: Text(
                status['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(status['desc'] as String),
              ),
            ),
          );
        },
      ),
    );
  }

  String _t(String key) => SituationText.get(key, language);
}

// ===========================================
// BILINGUAL TEXT FOR SITUATION SECTION
// ===========================================
class SituationText {
  static String get(String key, String language) {
    final texts = {
      // Main screen
      'my_situation': {'es': '¿Cuál es mi situación?', 'en': 'What\'s my status?'},
      'questionnaire_title': {
        'es': '¿Cuál es tu situación migratoria?',
        'en': 'What\'s your immigration status?'
      },
      'questionnaire_desc': {
        'es': 'Responde algunas preguntas simples para entender mejor tu situación y tus derechos.',
        'en': 'Answer a few simple questions to better understand your situation and your rights.'
      },
      'privacy_notice': {
        'es': 'Tus respuestas NO se guardan. Esta información desaparece cuando cierras la app.',
        'en': 'Your answers are NOT saved. This information disappears when you close the app.'
      },
      'start_questionnaire': {'es': 'Comenzar', 'en': 'Start'},
      'view_all_statuses': {
        'es': 'Ver todos los estatus migratorios',
        'en': 'View all immigration statuses'
      },

      // Questions
      'q_birth_place': {'es': '¿Dónde naciste?', 'en': 'Where were you born?'},
      'q_birth_us': {
        'es': 'En Estados Unidos (cualquier estado)',
        'en': 'In the United States (any state)'
      },
      'q_birth_territory': {
        'es': 'En un territorio de EE.UU. (Puerto Rico, Guam, etc.)',
        'en': 'In a U.S. territory (Puerto Rico, Guam, etc.)'
      },
      'q_birth_abroad': {
        'es': 'Fuera de Estados Unidos',
        'en': 'Outside the United States'
      },
      'q_parents_citizens': {
        'es': '¿Alguno de tus padres era ciudadano de EE.UU. cuando naciste?',
        'en': 'Was either of your parents a U.S. citizen when you were born?'
      },
      'q_naturalized': {
        'es': '¿Te has naturalizado como ciudadano de EE.UU.?',
        'en': 'Have you naturalized as a U.S. citizen?'
      },
      'q_green_card': {
        'es': '¿Tienes una tarjeta verde (residencia permanente)?',
        'en': 'Do you have a green card (permanent residence)?'
      },
      'q_green_card_years': {
        'es': '¿Cuánto tiempo has tenido tu tarjeta verde?',
        'en': 'How long have you had your green card?'
      },
      'q_less_5_years': {'es': 'Menos de 5 años', 'en': 'Less than 5 years'},
      'q_5_plus_years': {'es': '5 años o más', 'en': '5 years or more'},
      'q_has_visa': {
        'es': '¿Qué tipo de visa tienes?',
        'en': 'What type of visa do you have?'
      },
      'q_visa_work': {'es': 'Visa de trabajo (H-1B, L-1, etc.)', 'en': 'Work visa (H-1B, L-1, etc.)'},
      'q_visa_student': {'es': 'Visa de estudiante (F-1, J-1)', 'en': 'Student visa (F-1, J-1)'},
      'q_visa_tourist': {'es': 'Visa de turista (B-1/B-2)', 'en': 'Tourist visa (B-1/B-2)'},
      'q_visa_other': {'es': 'Otra visa', 'en': 'Other visa'},
      'q_visa_none': {'es': 'No tengo visa', 'en': 'I don\'t have a visa'},
      'q_daca': {
        'es': '¿Tienes DACA (Acción Diferida)?',
        'en': 'Do you have DACA (Deferred Action)?'
      },
      'q_tps': {
        'es': '¿Tienes TPS (Estatus de Protección Temporal)?',
        'en': 'Do you have TPS (Temporary Protected Status)?'
      },
      'q_asylum': {
        'es': '¿Has solicitado o recibido asilo?',
        'en': 'Have you applied for or received asylum?'
      },
      'q_asylum_granted': {'es': 'Sí, me dieron asilo', 'en': 'Yes, I was granted asylum'},
      'q_asylum_pending': {'es': 'Tengo un caso pendiente', 'en': 'I have a pending case'},

      'yes': {'es': 'Sí', 'en': 'Yes'},
      'no': {'es': 'No', 'en': 'No'},
      'unsure': {'es': 'No estoy seguro', 'en': 'I\'m not sure'},
      'back': {'es': 'Atrás', 'en': 'Back'},

      // Results
      'your_situation': {'es': 'Tu situación', 'en': 'Your situation'},
      'key_points': {'es': 'Puntos clave', 'en': 'Key points'},
      'can_naturalize': {
        'es': '¡Podrías ser elegible para la ciudadanía! Consulta con un abogado de inmigración.',
        'en': 'You may be eligible for citizenship! Consult with an immigration lawyer.'
      },
      'disclaimer': {
        'es': 'Esta información es solo educativa y no constituye consejo legal. Consulta con un abogado de inmigración para tu caso específico.',
        'en': 'This information is educational only and does not constitute legal advice. Consult with an immigration lawyer for your specific case.'
      },
      'back_to_home': {'es': 'Volver al inicio', 'en': 'Back to home'},
      'retake_questionnaire': {'es': 'Responder de nuevo', 'en': 'Retake questionnaire'},

      // Status results
      'status_citizen_birth': {'es': 'Ciudadano por nacimiento', 'en': 'Citizen by birth'},
      'status_citizen_birth_desc': {
        'es': 'Si naciste en Estados Unidos o en un territorio de EE.UU., eres ciudadano estadounidense por nacimiento. Esto está protegido por la 14ª Enmienda de la Constitución.',
        'en': 'If you were born in the United States or a U.S. territory, you are a U.S. citizen by birth. This is protected by the 14th Amendment of the Constitution.'
      },
      'status_citizen_parents': {
        'es': 'Ciudadano por padres',
        'en': 'Citizen through parents'
      },
      'status_citizen_parents_desc': {
        'es': 'Aunque naciste fuera de EE.UU., puedes ser ciudadano si al menos uno de tus padres era ciudadano cuando naciste. Esto se llama ciudadanía derivada.',
        'en': 'Even though you were born outside the U.S., you may be a citizen if at least one parent was a citizen when you were born. This is called derivative citizenship.'
      },
      'status_citizen_naturalized': {
        'es': 'Ciudadano naturalizado',
        'en': 'Naturalized citizen'
      },
      'status_citizen_naturalized_desc': {
        'es': 'Completaste el proceso de naturalización y ahora eres ciudadano de EE.UU. Tienes casi todos los mismos derechos que un ciudadano por nacimiento.',
        'en': 'You completed the naturalization process and are now a U.S. citizen. You have almost all the same rights as a citizen by birth.'
      },
      'citizen_point_1': {
        'es': 'No puedes ser deportado',
        'en': 'You cannot be deported'
      },
      'citizen_point_2': {
        'es': 'Puedes votar en todas las elecciones',
        'en': 'You can vote in all elections'
      },
      'citizen_point_3': {
        'es': 'Puedes solicitar pasaporte de EE.UU.',
        'en': 'You can apply for a U.S. passport'
      },
      'citizen_point_4': {
        'es': 'Tienes todos los derechos constitucionales',
        'en': 'You have all constitutional rights'
      },
      'citizen_parents_point': {
        'es': 'Podrías necesitar documentar tu ciudadanía con un Certificado de Ciudadanía',
        'en': 'You may need to document your citizenship with a Certificate of Citizenship'
      },
      'naturalized_point': {
        'es': 'Tu ciudadanía puede revocarse solo en casos raros de fraude',
        'en': 'Your citizenship can be revoked only in rare cases of fraud'
      },

      'status_green_card': {
        'es': 'Residente permanente',
        'en': 'Permanent resident'
      },
      'status_green_card_desc': {
        'es': 'Tienes autorización para vivir y trabajar permanentemente en EE.UU. Tu tarjeta verde debe renovarse cada 10 años, pero tu estatus es permanente.',
        'en': 'You are authorized to live and work permanently in the U.S. Your green card must be renewed every 10 years, but your status is permanent.'
      },
      'status_green_card_5plus': {
        'es': 'Residente permanente (5+ años)',
        'en': 'Permanent resident (5+ years)'
      },
      'status_green_card_5plus_desc': {
        'es': 'Has sido residente permanente por más de 5 años. Probablemente eres elegible para solicitar la ciudadanía a través de la naturalización.',
        'en': 'You have been a permanent resident for more than 5 years. You are likely eligible to apply for citizenship through naturalization.'
      },
      'green_card_point_1': {
        'es': 'Puedes vivir y trabajar en cualquier lugar de EE.UU.',
        'en': 'You can live and work anywhere in the U.S.'
      },
      'green_card_point_2': {
        'es': 'Tienes derecho a la protección de las leyes de EE.UU.',
        'en': 'You have the right to protection under U.S. laws'
      },
      'green_card_point_3': {
        'es': 'Puedes viajar fuera del país (con limitaciones)',
        'en': 'You can travel outside the country (with limitations)'
      },
      'green_card_point_4': {
        'es': 'Ciertos delitos pueden poner en riesgo tu estatus',
        'en': 'Certain crimes can put your status at risk'
      },
      'green_card_5plus_point': {
        'es': 'Podrías ser elegible para la ciudadanía ahora',
        'en': 'You may be eligible for citizenship now'
      },

      'status_visa_work': {'es': 'Visa de trabajo', 'en': 'Work visa'},
      'status_visa_work_desc': {
        'es': 'Estás autorizado para trabajar en EE.UU. temporalmente con tu empleador patrocinador. Tu estatus depende de mantener tu empleo.',
        'en': 'You are authorized to work in the U.S. temporarily with your sponsoring employer. Your status depends on maintaining your employment.'
      },
      'visa_work_point_1': {
        'es': 'Tu visa está ligada a tu empleador',
        'en': 'Your visa is tied to your employer'
      },
      'visa_work_point_2': {
        'es': 'Debes mantener estatus válido para permanecer legalmente',
        'en': 'You must maintain valid status to stay legally'
      },
      'visa_work_point_3': {
        'es': 'Podrías ser elegible para una tarjeta verde a través de tu empleador',
        'en': 'You may be eligible for a green card through your employer'
      },
      'visa_point_rights': {
        'es': 'Tienes derechos constitucionales mientras estés en EE.UU.',
        'en': 'You have constitutional rights while in the U.S.'
      },

      'status_visa_student': {'es': 'Visa de estudiante', 'en': 'Student visa'},
      'status_visa_student_desc': {
        'es': 'Estás autorizado para estudiar en EE.UU. Debes mantener estatus de tiempo completo y seguir las reglas de tu visa.',
        'en': 'You are authorized to study in the U.S. You must maintain full-time status and follow your visa rules.'
      },
      'visa_student_point_1': {
        'es': 'Debes estar inscrito como estudiante de tiempo completo',
        'en': 'You must be enrolled as a full-time student'
      },
      'visa_student_point_2': {
        'es': 'Trabajo limitado permitido (CPT, OPT)',
        'en': 'Limited work permitted (CPT, OPT)'
      },
      'visa_student_point_3': {
        'es': 'Debes reportar cambios a tu escuela',
        'en': 'You must report changes to your school'
      },

      'status_visa_tourist': {'es': 'Visa de turista', 'en': 'Tourist visa'},
      'status_visa_tourist_desc': {
        'es': 'Estás autorizado para visitar EE.UU. temporalmente. No puedes trabajar con esta visa y debes salir antes de que expire tu estadía autorizada.',
        'en': 'You are authorized to visit the U.S. temporarily. You cannot work on this visa and must leave before your authorized stay expires.'
      },
      'visa_tourist_point_1': {
        'es': 'No puedes trabajar en EE.UU.',
        'en': 'You cannot work in the U.S.'
      },
      'visa_tourist_point_2': {
        'es': 'Estadía típica de 6 meses o menos',
        'en': 'Typical stay of 6 months or less'
      },
      'visa_tourist_point_3': {
        'es': 'Quedarse más tiempo de lo autorizado tiene consecuencias serias',
        'en': 'Overstaying has serious consequences'
      },

      'status_visa_other': {'es': 'Otra visa', 'en': 'Other visa'},
      'status_visa_other_desc': {
        'es': 'Tienes algún tipo de visa que te autoriza a estar en EE.UU. Es importante entender las condiciones específicas de tu visa.',
        'en': 'You have some type of visa authorizing you to be in the U.S. It\'s important to understand the specific conditions of your visa.'
      },
      'visa_other_point_1': {
        'es': 'Cada visa tiene reglas específicas',
        'en': 'Each visa has specific rules'
      },
      'visa_other_point_2': {
        'es': 'Consulta con un abogado sobre tu situación específica',
        'en': 'Consult a lawyer about your specific situation'
      },

      'status_daca': {'es': 'DACA', 'en': 'DACA'},
      'status_daca_desc': {
        'es': 'Tienes Acción Diferida para los Llegados en la Infancia. Esto te protege temporalmente de la deportación y te permite trabajar, pero no es un estatus legal permanente.',
        'en': 'You have Deferred Action for Childhood Arrivals. This temporarily protects you from deportation and allows you to work, but it\'s not permanent legal status.'
      },
      'daca_point_1': {
        'es': 'Protección temporal contra deportación',
        'en': 'Temporary protection from deportation'
      },
      'daca_point_2': {
        'es': 'Permiso de trabajo renovable cada 2 años',
        'en': 'Work permit renewable every 2 years'
      },
      'daca_point_3': {
        'es': 'Puedes obtener licencia de conducir en la mayoría de estados',
        'en': 'You can get a driver\'s license in most states'
      },
      'daca_point_4': {
        'es': 'El programa puede cambiar - mantente informado',
        'en': 'The program can change - stay informed'
      },

      'status_tps': {'es': 'TPS', 'en': 'TPS'},
      'status_tps_desc': {
        'es': 'Tienes Estatus de Protección Temporal debido a condiciones en tu país de origen. Esto te permite vivir y trabajar en EE.UU. mientras las condiciones lo justifiquen.',
        'en': 'You have Temporary Protected Status due to conditions in your home country. This allows you to live and work in the U.S. as long as conditions warrant.'
      },
      'tps_point_1': {
        'es': 'Protección temporal basada en condiciones de tu país',
        'en': 'Temporary protection based on your country\'s conditions'
      },
      'tps_point_2': {
        'es': 'Permiso de trabajo mientras mantengas TPS',
        'en': 'Work permit while maintaining TPS'
      },
      'tps_point_3': {
        'es': 'Debes re-registrarte cuando se requiera',
        'en': 'You must re-register when required'
      },
      'tps_point_4': {
        'es': 'El TPS puede extenderse o terminarse',
        'en': 'TPS can be extended or terminated'
      },

      'status_asylee': {'es': 'Asilado', 'en': 'Asylee'},
      'status_asylee_desc': {
        'es': 'Te concedieron asilo en EE.UU. Tienes derecho a vivir y trabajar aquí, y después de un año puedes solicitar la tarjeta verde.',
        'en': 'You were granted asylum in the U.S. You have the right to live and work here, and after one year you can apply for a green card.'
      },
      'asylee_point_1': {
        'es': 'Derecho a vivir y trabajar en EE.UU.',
        'en': 'Right to live and work in the U.S.'
      },
      'asylee_point_2': {
        'es': 'Puedes solicitar tarjeta verde después de 1 año',
        'en': 'You can apply for green card after 1 year'
      },
      'asylee_point_3': {
        'es': 'Puedes traer a familiares cercanos',
        'en': 'You can bring close family members'
      },
      'asylee_point_4': {
        'es': 'No debes viajar a tu país de origen',
        'en': 'You should not travel to your home country'
      },

      'status_asylum_pending': {
        'es': 'Asilo pendiente',
        'en': 'Asylum pending'
      },
      'status_asylum_pending_desc': {
        'es': 'Tienes una solicitud de asilo en proceso. Mientras esperas, tienes ciertos derechos pero también obligaciones que debes cumplir.',
        'en': 'You have a pending asylum application. While waiting, you have certain rights but also obligations you must fulfill.'
      },
      'asylum_pending_point_1': {
        'es': 'Puedes solicitar permiso de trabajo después de cierto tiempo',
        'en': 'You can apply for work permit after certain time'
      },
      'asylum_pending_point_2': {
        'es': 'Debes asistir a todas las citas y audiencias',
        'en': 'You must attend all appointments and hearings'
      },
      'asylum_pending_point_3': {
        'es': 'Mantén actualizada tu dirección con el tribunal',
        'en': 'Keep your address updated with the court'
      },

      'status_undocumented': {'es': 'Sin estatus legal', 'en': 'Without legal status'},
      'status_undocumented_desc': {
        'es': 'Actualmente no tienes un estatus migratorio legal. Aunque esto te pone en riesgo de deportación, aún tienes derechos constitucionales en EE.UU.',
        'en': 'You currently don\'t have legal immigration status. While this puts you at risk of deportation, you still have constitutional rights in the U.S.'
      },
      'undocumented_point_1': {
        'es': 'Tienes derechos constitucionales (silencio, abogado, etc.)',
        'en': 'You have constitutional rights (silence, attorney, etc.)'
      },
      'undocumented_point_2': {
        'es': 'Tus hijos nacidos aquí son ciudadanos',
        'en': 'Your children born here are citizens'
      },
      'undocumented_point_3': {
        'es': 'Consulta con un abogado sobre posibles opciones',
        'en': 'Consult with a lawyer about possible options'
      },
      'undocumented_point_4': {
        'es': 'Prepárate para emergencias (ver "Si me detienen")',
        'en': 'Prepare for emergencies (see "If I\'m detained")'
      },

      // Overview screen
      'all_statuses': {'es': 'Estatus migratorios', 'en': 'Immigration statuses'},
      'overview_citizen': {'es': 'Ciudadano', 'en': 'Citizen'},
      'overview_citizen_desc': {
        'es': 'Por nacimiento, por padres, o naturalizado',
        'en': 'By birth, through parents, or naturalized'
      },
      'overview_green_card': {'es': 'Residente permanente', 'en': 'Permanent resident'},
      'overview_green_card_desc': {
        'es': 'Tarjeta verde - puede vivir y trabajar permanentemente',
        'en': 'Green card - can live and work permanently'
      },
      'overview_visa': {'es': 'Visa temporal', 'en': 'Temporary visa'},
      'overview_visa_desc': {
        'es': 'Trabajo, estudiante, turista u otra visa',
        'en': 'Work, student, tourist, or other visa'
      },
      'overview_daca': {'es': 'DACA', 'en': 'DACA'},
      'overview_daca_desc': {
        'es': 'Acción Diferida para los Llegados en la Infancia',
        'en': 'Deferred Action for Childhood Arrivals'
      },
      'overview_tps': {'es': 'TPS', 'en': 'TPS'},
      'overview_tps_desc': {
        'es': 'Estatus de Protección Temporal',
        'en': 'Temporary Protected Status'
      },
      'overview_asylum': {'es': 'Asilo', 'en': 'Asylum'},
      'overview_asylum_desc': {
        'es': 'Concedido o pendiente',
        'en': 'Granted or pending'
      },
      'overview_undocumented': {'es': 'Sin estatus', 'en': 'Without status'},
      'overview_undocumented_desc': {
        'es': 'Sin autorización legal actual',
        'en': 'Without current legal authorization'
      },
    };
    return texts[key]?[language] ?? key;
  }
}