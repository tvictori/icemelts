import 'package:flutter/material.dart';

// Main entry screen for "Mis derechos"
class RightsSection extends StatelessWidget {
  final String language;
  final String state;

  const RightsSection({
    super.key,
    required this.language,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t('my_rights')),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Universal rights banner
          Card(
            color: Colors.green.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.green.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Icon(
                    Icons.shield,
                    size: 48,
                    color: Colors.green.shade700,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _t('universal_rights_title'),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade800,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _t('universal_rights_desc'),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _t('rights_by_scenario'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // Scenario cards
          _buildScenarioCard(
            context,
            icon: Icons.warning_amber,
            title: _t('scenario_ice'),
            subtitle: _t('scenario_ice_desc'),
            color: Colors.red.shade800,
            onTap: () => _navigateToScenario(context, 'ice'),
          ),
          const SizedBox(height: 12),
          _buildScenarioCard(
            context,
            icon: Icons.local_police,
            title: _t('scenario_police'),
            subtitle: _t('scenario_police_desc'),
            color: Colors.blue,
            onTap: () => _navigateToScenario(context, 'police'),
          ),
          const SizedBox(height: 12),
          _buildScenarioCard(
            context,
            icon: Icons.home,
            title: _t('scenario_home'),
            subtitle: _t('scenario_home_desc'),
            color: Colors.orange,
            onTap: () => _navigateToScenario(context, 'home'),
          ),
          const SizedBox(height: 12),
          _buildScenarioCard(
            context,
            icon: Icons.work,
            title: _t('scenario_work'),
            subtitle: _t('scenario_work_desc'),
            color: Colors.purple,
            onTap: () => _navigateToScenario(context, 'work'),
          ),
          const SizedBox(height: 12),
          _buildScenarioCard(
            context,
            icon: Icons.directions_car,
            title: _t('scenario_traffic'),
            subtitle: _t('scenario_traffic_desc'),
            color: Colors.red,
            onTap: () => _navigateToScenario(context, 'traffic'),
          ),
          const SizedBox(height: 12),
          _buildScenarioCard(
            context,
            icon: Icons.flight,
            title: _t('scenario_airport'),
            subtitle: _t('scenario_airport_desc'),
            color: Colors.teal,
            onTap: () => _navigateToScenario(context, 'airport'),
          ),
          const SizedBox(height: 12),
          _buildScenarioCard(
            context,
            icon: Icons.school,
            title: _t('scenario_school'),
            subtitle: _t('scenario_school_desc'),
            color: Colors.indigo,
            onTap: () => _navigateToScenario(context, 'school'),
          ),
          const SizedBox(height: 24),
          // Constitutional rights section
          Text(
            _t('constitutional_rights'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildRightsCard(
            context,
            amendment: '1',
            title: _t('first_amendment'),
            description: _t('first_amendment_desc'),
          ),
          const SizedBox(height: 12),
          _buildRightsCard(
            context,
            amendment: '4',
            title: _t('fourth_amendment'),
            description: _t('fourth_amendment_desc'),
          ),
          const SizedBox(height: 12),
          _buildRightsCard(
            context,
            amendment: '5',
            title: _t('fifth_amendment'),
            description: _t('fifth_amendment_desc'),
          ),
          const SizedBox(height: 12),
          _buildRightsCard(
            context,
            amendment: '6',
            title: _t('sixth_amendment'),
            description: _t('sixth_amendment_desc'),
          ),
          const SizedBox(height: 12),
          _buildRightsCard(
            context,
            amendment: '14',
            title: _t('fourteenth_amendment'),
            description: _t('fourteenth_amendment_desc'),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildScenarioCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRightsCard(
      BuildContext context, {
        required String amendment,
        required String title,
        required String description,
      }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  amendment,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToScenario(BuildContext context, String scenario) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScenarioDetailScreen(
          scenario: scenario,
          language: language,
        ),
      ),
    );
  }

  String _t(String key) => RightsText.get(key, language);
}

// ===========================================
// SCENARIO DETAIL SCREEN
// ===========================================
class ScenarioDetailScreen extends StatelessWidget {
  final String scenario;
  final String language;

  const ScenarioDetailScreen({
    super.key,
    required this.scenario,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final scenarioData = _getScenarioData();

    return Scaffold(
      appBar: AppBar(
        title: Text(scenarioData['title'] as String),
        backgroundColor: scenarioData['color'] as Color,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: (scenarioData['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  scenarioData['icon'] as IconData,
                  size: 56,
                  color: scenarioData['color'] as Color,
                ),
                const SizedBox(height: 16),
                Text(
                  scenarioData['headline'] as String,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: scenarioData['color'] as Color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Your rights section
          _buildSection(
            context,
            title: _t('your_rights'),
            icon: Icons.check_circle,
            color: Colors.green,
            items: scenarioData['rights'] as List<String>,
          ),
          const SizedBox(height: 16),

          // What to do section
          _buildSection(
            context,
            title: _t('what_to_do'),
            icon: Icons.lightbulb,
            color: Colors.blue,
            items: scenarioData['dos'] as List<String>,
          ),
          const SizedBox(height: 16),

          // What NOT to do section
          _buildSection(
            context,
            title: _t('what_not_to_do'),
            icon: Icons.block,
            color: Colors.red,
            items: scenarioData['donts'] as List<String>,
          ),
          const SizedBox(height: 16),

          // What to say section
          if (scenarioData['phrases'] != null) ...[
            _buildPhrasesSection(
              context,
              phrases: scenarioData['phrases'] as List<Map<String, String>>,
            ),
            const SizedBox(height: 16),
          ],

          // Important note
          Card(
            color: Colors.amber.shade50,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, color: Colors.amber.shade800),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _t('rights_note'),
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
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required List<String> items,
      }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 15, height: 1.4),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildPhrasesSection(
      BuildContext context, {
        required List<Map<String, String>> phrases,
      }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.indigo.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.format_quote, color: Colors.indigo.shade700, size: 24),
                const SizedBox(width: 12),
                Text(
                  _t('what_to_say'),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...phrases.map((phrase) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"${phrase['es']}"',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo.shade800,
                    ),
                  ),
                  if (language == 'en') ...[
                    const SizedBox(height: 8),
                    Text(
                      '"${phrase['en']}"',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _getScenarioData() {
    final scenarios = {
      'ice': {
        'icon': Icons.warning_amber,
        'color': Colors.red.shade800,
        'title': _t('scenario_ice'),
        'headline': _t('ice_headline'),
        'rights': [
          _t('ice_right_1'),
          _t('ice_right_2'),
          _t('ice_right_3'),
          _t('ice_right_4'),
          _t('ice_right_5'),
          _t('ice_right_6'),
        ],
        'dos': [
          _t('ice_do_1'),
          _t('ice_do_2'),
          _t('ice_do_3'),
          _t('ice_do_4'),
          _t('ice_do_5'),
        ],
        'donts': [
          _t('ice_dont_1'),
          _t('ice_dont_2'),
          _t('ice_dont_3'),
          _t('ice_dont_4'),
          _t('ice_dont_5'),
        ],
        'phrases': [
          {'es': 'Estoy ejerciendo mi derecho a guardar silencio.', 'en': 'I am exercising my right to remain silent.'},
          {'es': 'No consiento a ninguna búsqueda.', 'en': 'I do not consent to any searches.'},
          {'es': 'Quiero hablar con un abogado.', 'en': 'I want to speak with a lawyer.'},
          {'es': '¿Tiene una orden judicial firmada por un juez?', 'en': 'Do you have a warrant signed by a judge?'},
          {'es': 'No voy a firmar nada sin mi abogado.', 'en': 'I will not sign anything without my lawyer.'},
        ],
      },
      'police': {
        'icon': Icons.local_police,
        'color': Colors.blue.shade700,
        'title': _t('scenario_police'),
        'headline': _t('police_headline'),
        'rights': [
          _t('police_right_1'),
          _t('police_right_2'),
          _t('police_right_3'),
          _t('police_right_4'),
          _t('police_right_5'),
        ],
        'dos': [
          _t('police_do_1'),
          _t('police_do_2'),
          _t('police_do_3'),
          _t('police_do_4'),
        ],
        'donts': [
          _t('police_dont_1'),
          _t('police_dont_2'),
          _t('police_dont_3'),
          _t('police_dont_4'),
        ],
        'phrases': [
          {'es': 'Estoy ejerciendo mi derecho a guardar silencio.', 'en': 'I am exercising my right to remain silent.'},
          {'es': 'No consiento a ninguna búsqueda.', 'en': 'I do not consent to any searches.'},
          {'es': 'Quiero hablar con un abogado.', 'en': 'I want to speak with a lawyer.'},
          {'es': '¿Estoy libre de irme?', 'en': 'Am I free to leave?'},
        ],
      },
      'home': {
        'icon': Icons.home,
        'color': Colors.orange.shade700,
        'title': _t('scenario_home'),
        'headline': _t('home_headline'),
        'rights': [
          _t('home_right_1'),
          _t('home_right_2'),
          _t('home_right_3'),
          _t('home_right_4'),
        ],
        'dos': [
          _t('home_do_1'),
          _t('home_do_2'),
          _t('home_do_3'),
          _t('home_do_4'),
        ],
        'donts': [
          _t('home_dont_1'),
          _t('home_dont_2'),
          _t('home_dont_3'),
        ],
        'phrases': [
          {'es': 'No abro la puerta. ¿Tiene una orden judicial firmada por un juez?', 'en': 'I don\'t open the door. Do you have a warrant signed by a judge?'},
          {'es': 'Por favor, pase la orden por debajo de la puerta.', 'en': 'Please slide the warrant under the door.'},
          {'es': 'No consiento a que entre a mi casa.', 'en': 'I do not consent to your entry into my home.'},
        ],
      },
      'work': {
        'icon': Icons.work,
        'color': Colors.purple.shade700,
        'title': _t('scenario_work'),
        'headline': _t('work_headline'),
        'rights': [
          _t('work_right_1'),
          _t('work_right_2'),
          _t('work_right_3'),
          _t('work_right_4'),
        ],
        'dos': [
          _t('work_do_1'),
          _t('work_do_2'),
          _t('work_do_3'),
          _t('work_do_4'),
        ],
        'donts': [
          _t('work_dont_1'),
          _t('work_dont_2'),
          _t('work_dont_3'),
        ],
        'phrases': [
          {'es': 'Estoy ejerciendo mi derecho a guardar silencio.', 'en': 'I am exercising my right to remain silent.'},
          {'es': '¿Tienen una orden judicial?', 'en': 'Do you have a warrant?'},
          {'es': 'Quiero hablar con un abogado antes de responder preguntas.', 'en': 'I want to speak with a lawyer before answering questions.'},
        ],
      },
      'traffic': {
        'icon': Icons.directions_car,
        'color': Colors.red.shade700,
        'title': _t('scenario_traffic'),
        'headline': _t('traffic_headline'),
        'rights': [
          _t('traffic_right_1'),
          _t('traffic_right_2'),
          _t('traffic_right_3'),
          _t('traffic_right_4'),
        ],
        'dos': [
          _t('traffic_do_1'),
          _t('traffic_do_2'),
          _t('traffic_do_3'),
          _t('traffic_do_4'),
        ],
        'donts': [
          _t('traffic_dont_1'),
          _t('traffic_dont_2'),
          _t('traffic_dont_3'),
        ],
        'phrases': [
          {'es': 'Estoy ejerciendo mi derecho a guardar silencio.', 'en': 'I am exercising my right to remain silent.'},
          {'es': 'No consiento a una búsqueda de mi vehículo.', 'en': 'I do not consent to a search of my vehicle.'},
        ],
      },
      'airport': {
        'icon': Icons.flight,
        'color': Colors.teal.shade700,
        'title': _t('scenario_airport'),
        'headline': _t('airport_headline'),
        'rights': [
          _t('airport_right_1'),
          _t('airport_right_2'),
          _t('airport_right_3'),
          _t('airport_right_4'),
        ],
        'dos': [
          _t('airport_do_1'),
          _t('airport_do_2'),
          _t('airport_do_3'),
        ],
        'donts': [
          _t('airport_dont_1'),
          _t('airport_dont_2'),
          _t('airport_dont_3'),
        ],
        'phrases': null,
      },
      'school': {
        'icon': Icons.school,
        'color': Colors.indigo.shade700,
        'title': _t('scenario_school'),
        'headline': _t('school_headline'),
        'rights': [
          _t('school_right_1'),
          _t('school_right_2'),
          _t('school_right_3'),
          _t('school_right_4'),
        ],
        'dos': [
          _t('school_do_1'),
          _t('school_do_2'),
          _t('school_do_3'),
        ],
        'donts': [
          _t('school_dont_1'),
          _t('school_dont_2'),
        ],
        'phrases': null,
      },
    };

    return scenarios[scenario] ?? scenarios['police']!;
  }

  String _t(String key) => RightsText.get(key, language);
}

// ===========================================
// BILINGUAL TEXT FOR RIGHTS SECTION
// ===========================================
class RightsText {
  static String get(String key, String language) {
    final texts = {
      // Main screen
      'my_rights': {'es': 'Mis derechos', 'en': 'My rights'},
      'universal_rights_title': {
        'es': 'La Constitución te protege',
        'en': 'The Constitution protects you'
      },
      'universal_rights_desc': {
        'es': 'Sin importar tu estatus migratorio, tienes derechos constitucionales en Estados Unidos.',
        'en': 'Regardless of your immigration status, you have constitutional rights in the United States.'
      },
      'rights_by_scenario': {
        'es': 'Tus derechos por situación',
        'en': 'Your rights by situation'
      },
      'constitutional_rights': {
        'es': 'Derechos constitucionales',
        'en': 'Constitutional rights'
      },

      // Scenarios
      'scenario_ice': {
        'es': 'Si te para ICE',
        'en': 'If ICE stops you'
      },
      'scenario_ice_desc': {
        'es': 'Encuentro con agentes de inmigración',
        'en': 'Encounter with immigration agents'
      },
      'scenario_police': {
        'es': 'Con la policía',
        'en': 'With police'
      },
      'scenario_police_desc': {
        'es': 'Durante un encuentro con la policía local',
        'en': 'During an encounter with local police'
      },
      'scenario_home': {
        'es': 'En tu casa',
        'en': 'At your home'
      },
      'scenario_home_desc': {
        'es': 'Si tocan a tu puerta',
        'en': 'If they knock on your door'
      },
      'scenario_work': {
        'es': 'En el trabajo',
        'en': 'At work'
      },
      'scenario_work_desc': {
        'es': 'Durante una redada en el lugar de trabajo',
        'en': 'During a workplace raid'
      },
      'scenario_traffic': {
        'es': 'Parada de tráfico',
        'en': 'Traffic stop'
      },
      'scenario_traffic_desc': {
        'es': 'Si te detienen mientras manejas',
        'en': 'If you\'re stopped while driving'
      },
      'scenario_airport': {
        'es': 'En el aeropuerto',
        'en': 'At the airport'
      },
      'scenario_airport_desc': {
        'es': 'Al viajar o en puntos de control',
        'en': 'When traveling or at checkpoints'
      },
      'scenario_school': {
        'es': 'En la escuela',
        'en': 'At school'
      },
      'scenario_school_desc': {
        'es': 'Derechos de estudiantes y familias',
        'en': 'Rights of students and families'
      },

      // Constitutional amendments
      'first_amendment': {
        'es': 'Primera Enmienda',
        'en': 'First Amendment'
      },
      'first_amendment_desc': {
        'es': 'Libertad de religión, expresión, prensa, reunión y petición al gobierno.',
        'en': 'Freedom of religion, speech, press, assembly, and to petition the government.'
      },
      'fourth_amendment': {
        'es': 'Cuarta Enmienda',
        'en': 'Fourth Amendment'
      },
      'fourth_amendment_desc': {
        'es': 'Protección contra registros e incautaciones irrazonables. La policía generalmente necesita una orden judicial.',
        'en': 'Protection against unreasonable searches and seizures. Police generally need a warrant.'
      },
      'fifth_amendment': {
        'es': 'Quinta Enmienda',
        'en': 'Fifth Amendment'
      },
      'fifth_amendment_desc': {
        'es': 'Derecho a guardar silencio y no auto-incriminarte. Derecho al debido proceso legal.',
        'en': 'Right to remain silent and not incriminate yourself. Right to due process of law.'
      },
      'sixth_amendment': {
        'es': 'Sexta Enmienda',
        'en': 'Sixth Amendment'
      },
      'sixth_amendment_desc': {
        'es': 'Derecho a un abogado en casos criminales. Derecho a un juicio justo.',
        'en': 'Right to an attorney in criminal cases. Right to a fair trial.'
      },
      'fourteenth_amendment': {
        'es': 'Decimocuarta Enmienda',
        'en': 'Fourteenth Amendment'
      },
      'fourteenth_amendment_desc': {
        'es': 'Igual protección bajo la ley para todas las personas, no solo ciudadanos.',
        'en': 'Equal protection under the law for all persons, not just citizens.'
      },

      // Scenario detail sections
      'your_rights': {'es': 'Tus derechos', 'en': 'Your rights'},
      'what_to_do': {'es': 'Qué hacer', 'en': 'What to do'},
      'what_not_to_do': {'es': 'Qué NO hacer', 'en': 'What NOT to do'},
      'what_to_say': {'es': 'Qué decir', 'en': 'What to say'},
      'rights_note': {
        'es': 'Ejercer tus derechos de manera calmada y respetuosa es la mejor forma de protegerte. Recuerda que todo lo que digas puede usarse en tu contra.',
        'en': 'Exercising your rights calmly and respectfully is the best way to protect yourself. Remember that anything you say can be used against you.'
      },

      // ICE scenario
      'ice_headline': {
        'es': 'Tus derechos ante ICE',
        'en': 'Your rights with ICE'
      },
      'ice_right_1': {
        'es': 'Tienes derecho a guardar silencio - no tienes que decir dónde naciste ni tu estatus migratorio',
        'en': 'You have the right to remain silent - you don\'t have to say where you were born or your immigration status'
      },
      'ice_right_2': {
        'es': 'Tienes derecho a pedir ver una orden judicial (firmada por un juez, no solo de ICE)',
        'en': 'You have the right to ask to see a judicial warrant (signed by a judge, not just from ICE)'
      },
      'ice_right_3': {
        'es': 'Tienes derecho a negarte a abrir la puerta si no tienen orden judicial',
        'en': 'You have the right to refuse to open the door if they don\'t have a judicial warrant'
      },
      'ice_right_4': {
        'es': 'Tienes derecho a hablar con un abogado antes de firmar cualquier documento',
        'en': 'You have the right to speak with a lawyer before signing any documents'
      },
      'ice_right_5': {
        'es': 'Tienes derecho a una audiencia ante un juez de inmigración (en la mayoría de casos)',
        'en': 'You have the right to a hearing before an immigration judge (in most cases)'
      },
      'ice_right_6': {
        'es': 'Tienes derecho a contactar a tu consulado',
        'en': 'You have the right to contact your consulate'
      },
      'ice_do_1': {
        'es': 'Mantén la calma y no corras',
        'en': 'Stay calm and don\'t run'
      },
      'ice_do_2': {
        'es': 'Di claramente: "Quiero ejercer mi derecho a guardar silencio"',
        'en': 'Say clearly: "I want to exercise my right to remain silent"'
      },
      'ice_do_3': {
        'es': 'Pregunta: "¿Tiene una orden judicial firmada por un juez?"',
        'en': 'Ask: "Do you have a warrant signed by a judge?"'
      },
      'ice_do_4': {
        'es': 'Memoriza el número de un abogado o familiar de confianza',
        'en': 'Memorize the phone number of a lawyer or trusted family member'
      },
      'ice_do_5': {
        'es': 'Si te arrestan, di que quieres hablar con un abogado ANTES de contestar preguntas',
        'en': 'If arrested, say you want to speak with a lawyer BEFORE answering questions'
      },
      'ice_dont_1': {
        'es': 'No corras - esto puede empeorar tu caso',
        'en': 'Don\'t run - this can make your case worse'
      },
      'ice_dont_2': {
        'es': 'No mientas ni des información falsa',
        'en': 'Don\'t lie or give false information'
      },
      'ice_dont_3': {
        'es': 'No muestres documentos de otros países (pasaporte, identificación extranjera)',
        'en': 'Don\'t show documents from other countries (passport, foreign ID)'
      },
      'ice_dont_4': {
        'es': 'No firmes NADA sin leerlo completamente y sin un abogado - especialmente la "salida voluntaria"',
        'en': 'Don\'t sign ANYTHING without reading it completely and without a lawyer - especially "voluntary departure"'
      },
      'ice_dont_5': {
        'es': 'No resistas físicamente aunque creas que el arresto es injusto',
        'en': 'Don\'t physically resist even if you believe the arrest is unjust'
      },

      // Police scenario
      'police_headline': {
        'es': 'Tus derechos con la policía',
        'en': 'Your rights with police'
      },
      'police_right_1': {
        'es': 'Tienes derecho a guardar silencio',
        'en': 'You have the right to remain silent'
      },
      'police_right_2': {
        'es': 'Tienes derecho a negarte a búsquedas sin orden judicial',
        'en': 'You have the right to refuse searches without a warrant'
      },
      'police_right_3': {
        'es': 'Tienes derecho a preguntar si eres libre de irte',
        'en': 'You have the right to ask if you are free to leave'
      },
      'police_right_4': {
        'es': 'Tienes derecho a un abogado si te arrestan',
        'en': 'You have the right to an attorney if arrested'
      },
      'police_right_5': {
        'es': 'Tienes derecho a no firmar nada que no entiendas',
        'en': 'You have the right not to sign anything you don\'t understand'
      },
      'police_do_1': {
        'es': 'Mantén la calma y sé respetuoso',
        'en': 'Stay calm and be respectful'
      },
      'police_do_2': {
        'es': 'Mantén tus manos visibles',
        'en': 'Keep your hands visible'
      },
      'police_do_3': {
        'es': 'Identifícate si te lo piden (da tu nombre)',
        'en': 'Identify yourself if asked (give your name)'
      },
      'police_do_4': {
        'es': 'Pide hablar con un abogado si te arrestan',
        'en': 'Ask to speak with a lawyer if arrested'
      },
      'police_dont_1': {
        'es': 'No corras ni huyas',
        'en': 'Don\'t run or flee'
      },
      'police_dont_2': {
        'es': 'No resistas físicamente aunque creas que es injusto',
        'en': 'Don\'t physically resist even if you think it\'s unfair'
      },
      'police_dont_3': {
        'es': 'No mientas ni des documentos falsos',
        'en': 'Don\'t lie or give false documents'
      },
      'police_dont_4': {
        'es': 'No contestes preguntas sobre tu estatus migratorio',
        'en': 'Don\'t answer questions about your immigration status'
      },

      // Home scenario
      'home_headline': {
        'es': 'Tus derechos en tu casa',
        'en': 'Your rights at home'
      },
      'home_right_1': {
        'es': 'No tienes que abrir la puerta a menos que tengan una orden judicial',
        'en': 'You don\'t have to open the door unless they have a warrant'
      },
      'home_right_2': {
        'es': 'Una orden de ICE (administrativa) NO es lo mismo que una orden judicial',
        'en': 'An ICE warrant (administrative) is NOT the same as a judicial warrant'
      },
      'home_right_3': {
        'es': 'Tienes derecho a guardar silencio',
        'en': 'You have the right to remain silent'
      },
      'home_right_4': {
        'es': 'Tienes derecho a hablar con un abogado',
        'en': 'You have the right to speak with a lawyer'
      },
      'home_do_1': {
        'es': 'Pregunta quién es y qué quieren antes de abrir',
        'en': 'Ask who it is and what they want before opening'
      },
      'home_do_2': {
        'es': 'Pide ver la orden judicial por debajo de la puerta o por la ventana',
        'en': 'Ask to see the warrant under the door or through the window'
      },
      'home_do_3': {
        'es': 'Verifica que la orden tenga tu nombre, dirección y firma de un juez',
        'en': 'Verify the warrant has your name, address, and a judge\'s signature'
      },
      'home_do_4': {
        'es': 'Graba el encuentro si es posible (es legal)',
        'en': 'Record the encounter if possible (it\'s legal)'
      },
      'home_dont_1': {
        'es': 'No abras la puerta si no tienen orden judicial válida',
        'en': 'Don\'t open the door if they don\'t have a valid judicial warrant'
      },
      'home_dont_2': {
        'es': 'No firmes nada sin un abogado',
        'en': 'Don\'t sign anything without a lawyer'
      },
      'home_dont_3': {
        'es': 'No mientas - simplemente guarda silencio',
        'en': 'Don\'t lie - simply remain silent'
      },

      // Work scenario
      'work_headline': {
        'es': 'Tus derechos en el trabajo',
        'en': 'Your rights at work'
      },
      'work_right_1': {
        'es': 'Tienes derecho a guardar silencio',
        'en': 'You have the right to remain silent'
      },
      'work_right_2': {
        'es': 'Tienes derecho a un abogado',
        'en': 'You have the right to an attorney'
      },
      'work_right_3': {
        'es': 'ICE necesita una orden judicial para entrar a áreas no públicas',
        'en': 'ICE needs a warrant to enter non-public areas'
      },
      'work_right_4': {
        'es': 'Tienes derecho a no firmar nada',
        'en': 'You have the right not to sign anything'
      },
      'work_do_1': {
        'es': 'Mantén la calma',
        'en': 'Stay calm'
      },
      'work_do_2': {
        'es': 'Pregunta si eres libre de irte',
        'en': 'Ask if you are free to leave'
      },
      'work_do_3': {
        'es': 'Contacta a tu familia o abogado lo antes posible',
        'en': 'Contact your family or lawyer as soon as possible'
      },
      'work_do_4': {
        'es': 'Recuerda nombres y números de placa de los agentes',
        'en': 'Remember names and badge numbers of agents'
      },
      'work_dont_1': {
        'es': 'No corras ni te escondas',
        'en': 'Don\'t run or hide'
      },
      'work_dont_2': {
        'es': 'No contestes preguntas sobre tu estatus o el de otros',
        'en': 'Don\'t answer questions about your status or others\''
      },
      'work_dont_3': {
        'es': 'No muestres documentos de otros países',
        'en': 'Don\'t show documents from other countries'
      },

      // Traffic scenario
      'traffic_headline': {
        'es': 'Tus derechos en una parada de tráfico',
        'en': 'Your rights during a traffic stop'
      },
      'traffic_right_1': {
        'es': 'Tienes derecho a guardar silencio sobre tu estatus migratorio',
        'en': 'You have the right to remain silent about your immigration status'
      },
      'traffic_right_2': {
        'es': 'Tienes derecho a negarte a búsquedas del vehículo',
        'en': 'You have the right to refuse vehicle searches'
      },
      'traffic_right_3': {
        'es': 'Si eres pasajero, tienes derecho a preguntar si puedes irte',
        'en': 'If you\'re a passenger, you have the right to ask if you can leave'
      },
      'traffic_right_4': {
        'es': 'Tienes derecho a grabar el encuentro',
        'en': 'You have the right to record the encounter'
      },
      'traffic_do_1': {
        'es': 'Detente en un lugar seguro y apaga el motor',
        'en': 'Pull over safely and turn off the engine'
      },
      'traffic_do_2': {
        'es': 'Mantén las manos en el volante donde puedan verlas',
        'en': 'Keep your hands on the steering wheel where they can see them'
      },
      'traffic_do_3': {
        'es': 'Proporciona licencia, registro y seguro si te lo piden',
        'en': 'Provide license, registration, and insurance if asked'
      },
      'traffic_do_4': {
        'es': 'Sé cortés pero firme al ejercer tus derechos',
        'en': 'Be polite but firm when exercising your rights'
      },
      'traffic_dont_1': {
        'es': 'No hagas movimientos bruscos',
        'en': 'Don\'t make sudden movements'
      },
      'traffic_dont_2': {
        'es': 'No contestes preguntas sobre de dónde vienes o a dónde vas',
        'en': 'Don\'t answer questions about where you\'re coming from or going to'
      },
      'traffic_dont_3': {
        'es': 'No consientas a búsquedas voluntarias',
        'en': 'Don\'t consent to voluntary searches'
      },

      // Airport scenario
      'airport_headline': {
        'es': 'Tus derechos en el aeropuerto',
        'en': 'Your rights at the airport'
      },
      'airport_right_1': {
        'es': 'Tienes derecho a un intérprete si no hablas inglés',
        'en': 'You have the right to an interpreter if you don\'t speak English'
      },
      'airport_right_2': {
        'es': 'Tienes derecho a contactar a un abogado (aunque puede haber retrasos)',
        'en': 'You have the right to contact a lawyer (though there may be delays)'
      },
      'airport_right_3': {
        'es': 'Residentes permanentes tienen derecho a entrar a EE.UU.',
        'en': 'Permanent residents have the right to enter the U.S.'
      },
      'airport_right_4': {
        'es': 'Ciudadanos no pueden ser negados entrada a EE.UU.',
        'en': 'Citizens cannot be denied entry to the U.S.'
      },
      'airport_do_1': {
        'es': 'Lleva todos tus documentos de viaje válidos',
        'en': 'Carry all your valid travel documents'
      },
      'airport_do_2': {
        'es': 'Responde preguntas básicas sobre tu viaje con calma',
        'en': 'Answer basic questions about your trip calmly'
      },
      'airport_do_3': {
        'es': 'Pide hablar con un supervisor si sientes que te tratan injustamente',
        'en': 'Ask to speak with a supervisor if you feel you\'re being treated unfairly'
      },
      'airport_dont_1': {
        'es': 'No mientas a los agentes de CBP',
        'en': 'Don\'t lie to CBP agents'
      },
      'airport_dont_2': {
        'es': 'No lleves documentos falsos',
        'en': 'Don\'t carry false documents'
      },
      'airport_dont_3': {
        'es': 'No firmes nada que no entiendas completamente',
        'en': 'Don\'t sign anything you don\'t fully understand'
      },

      // School scenario
      'school_headline': {
        'es': 'Derechos en la escuela',
        'en': 'Rights at school'
      },
      'school_right_1': {
        'es': 'Todos los niños tienen derecho a educación pública gratuita, sin importar estatus migratorio',
        'en': 'All children have the right to free public education, regardless of immigration status'
      },
      'school_right_2': {
        'es': 'Las escuelas no pueden preguntar sobre estatus migratorio para inscribir',
        'en': 'Schools cannot ask about immigration status for enrollment'
      },
      'school_right_3': {
        'es': 'ICE generalmente no puede entrar a escuelas sin permiso',
        'en': 'ICE generally cannot enter schools without permission'
      },
      'school_right_4': {
        'es': 'Los registros escolares son confidenciales',
        'en': 'School records are confidential'
      },
      'school_do_1': {
        'es': 'Conoce las políticas de tu escuela sobre visitantes y emergencias',
        'en': 'Know your school\'s policies about visitors and emergencies'
      },
      'school_do_2': {
        'es': 'Designa contactos de emergencia que puedan recoger a tus hijos',
        'en': 'Designate emergency contacts who can pick up your children'
      },
      'school_do_3': {
        'es': 'Prepara un plan familiar en caso de emergencia',
        'en': 'Prepare a family plan in case of emergency'
      },
      'school_dont_1': {
        'es': 'No des información sobre tu estatus a personal escolar que no la necesita',
        'en': 'Don\'t give information about your status to school staff who don\'t need it'
      },
      'school_dont_2': {
        'es': 'No permitas que el miedo te impida enviar a tus hijos a la escuela',
        'en': 'Don\'t let fear prevent you from sending your children to school'
      },
    };
    return texts[key]?[language] ?? key;
  }
}