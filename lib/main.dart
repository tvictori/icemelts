import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'detained_section.dart';
import 'situation_section.dart';
import 'rights_section.dart';
import 'resources_section.dart';
import 'panic_button.dart';

void main() {
  runApp(const IcemeltApp());
}

class IcemeltApp extends StatefulWidget {
  const IcemeltApp({super.key});

  @override
  State<IcemeltApp> createState() => _IcemeltAppState();
}

class _IcemeltAppState extends State<IcemeltApp> {
  String _language = 'es';
  String? _state;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _language = prefs.getString('language') ?? 'es';
      _state = prefs.getString('state');
      _isLoading = false;
    });
  }

  Future<void> _setLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', lang);
    setState(() {
      _language = lang;
    });
  }

  Future<void> _setState(String state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('state', state);
    setState(() {
      _state = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    return MaterialApp(
      title: 'Icemelt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: _state == null
          ? StateSelectionScreen(
        language: _language,
        onLanguageChanged: _setLanguage,
        onStateSelected: _setState,
      )
          : HomeScreen(
        language: _language,
        state: _state!,
        onLanguageChanged: _setLanguage,
        onStateChanged: _setState,
      ),
    );
  }
}

// Bilingual text helper
class AppText {
  static String get(String key, String language) {
    final texts = {
      'app_title': {'es': 'Icemelt', 'en': 'Icemelt'},
      'select_state': {
        'es': 'Selecciona tu estado',
        'en': 'Select your state'
      },
      'select_state_desc': {
        'es': 'Para mostrarte recursos e información relevante a tu área',
        'en': 'To show you resources and information relevant to your area'
      },
      'continue': {'es': 'Continuar', 'en': 'Continue'},
      'my_situation': {
        'es': '¿Cuál es mi situación?',
        'en': 'What\'s my status?'
      },
      'my_situation_desc': {
        'es': 'Entiende tu estatus migratorio',
        'en': 'Understand your immigration status'
      },
      'my_rights': {'es': 'Mis derechos', 'en': 'My rights'},
      'my_rights_desc': {
        'es': 'Conoce tus derechos según tu situación',
        'en': 'Know your rights based on your situation'
      },
      'if_detained': {'es': 'Si me detienen', 'en': 'If I\'m detained'},
      'if_detained_desc': {
        'es': 'Qué hacer y a quién llamar',
        'en': 'What to do and who to call'
      },
      'resources': {'es': 'Recursos cerca de mí', 'en': 'Resources near me'},
      'resources_desc': {
        'es': 'Encuentra ayuda legal y comunitaria',
        'en': 'Find legal and community help'
      },
      'change_state': {'es': 'Cambiar estado', 'en': 'Change state'},
      'coming_soon': {'es': 'Próximamente', 'en': 'Coming soon'},
    };
    return texts[key]?[language] ?? key;
  }
}

// US States list
class USStates {
  static List<Map<String, String>> get list => [
    {'code': 'AL', 'name': 'Alabama'},
    {'code': 'AK', 'name': 'Alaska'},
    {'code': 'AZ', 'name': 'Arizona'},
    {'code': 'AR', 'name': 'Arkansas'},
    {'code': 'CA', 'name': 'California'},
    {'code': 'CO', 'name': 'Colorado'},
    {'code': 'CT', 'name': 'Connecticut'},
    {'code': 'DE', 'name': 'Delaware'},
    {'code': 'FL', 'name': 'Florida'},
    {'code': 'GA', 'name': 'Georgia'},
    {'code': 'HI', 'name': 'Hawaii'},
    {'code': 'ID', 'name': 'Idaho'},
    {'code': 'IL', 'name': 'Illinois'},
    {'code': 'IN', 'name': 'Indiana'},
    {'code': 'IA', 'name': 'Iowa'},
    {'code': 'KS', 'name': 'Kansas'},
    {'code': 'KY', 'name': 'Kentucky'},
    {'code': 'LA', 'name': 'Louisiana'},
    {'code': 'ME', 'name': 'Maine'},
    {'code': 'MD', 'name': 'Maryland'},
    {'code': 'MA', 'name': 'Massachusetts'},
    {'code': 'MI', 'name': 'Michigan'},
    {'code': 'MN', 'name': 'Minnesota'},
    {'code': 'MS', 'name': 'Mississippi'},
    {'code': 'MO', 'name': 'Missouri'},
    {'code': 'MT', 'name': 'Montana'},
    {'code': 'NE', 'name': 'Nebraska'},
    {'code': 'NV', 'name': 'Nevada'},
    {'code': 'NH', 'name': 'New Hampshire'},
    {'code': 'NJ', 'name': 'New Jersey'},
    {'code': 'NM', 'name': 'New Mexico'},
    {'code': 'NY', 'name': 'New York'},
    {'code': 'NC', 'name': 'North Carolina'},
    {'code': 'ND', 'name': 'North Dakota'},
    {'code': 'OH', 'name': 'Ohio'},
    {'code': 'OK', 'name': 'Oklahoma'},
    {'code': 'OR', 'name': 'Oregon'},
    {'code': 'PA', 'name': 'Pennsylvania'},
    {'code': 'RI', 'name': 'Rhode Island'},
    {'code': 'SC', 'name': 'South Carolina'},
    {'code': 'SD', 'name': 'South Dakota'},
    {'code': 'TN', 'name': 'Tennessee'},
    {'code': 'TX', 'name': 'Texas'},
    {'code': 'UT', 'name': 'Utah'},
    {'code': 'VT', 'name': 'Vermont'},
    {'code': 'VA', 'name': 'Virginia'},
    {'code': 'WA', 'name': 'Washington'},
    {'code': 'WV', 'name': 'West Virginia'},
    {'code': 'WI', 'name': 'Wisconsin'},
    {'code': 'WY', 'name': 'Wyoming'},
    {'code': 'DC', 'name': 'Washington D.C.'},
    {'code': 'PR', 'name': 'Puerto Rico'},
  ];
}

// State Selection Screen
class StateSelectionScreen extends StatefulWidget {
  final String language;
  final Function(String) onLanguageChanged;
  final Function(String) onStateSelected;

  const StateSelectionScreen({
    super.key,
    required this.language,
    required this.onLanguageChanged,
    required this.onStateSelected,
  });

  @override
  State<StateSelectionScreen> createState() => _StateSelectionScreenState();
}

class _StateSelectionScreenState extends State<StateSelectionScreen> {
  String? _selectedState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppText.get('app_title', widget.language)),
        actions: [
          // Language toggle
          TextButton(
            onPressed: () {
              widget.onLanguageChanged(widget.language == 'es' ? 'en' : 'es');
            },
            child: Text(
              widget.language == 'es' ? 'EN' : 'ES',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  AppBar().preferredSize.height -
                  MediaQuery.of(context).padding.top - 48,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  Icon(
                    Icons.location_on,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppText.get('select_state', widget.language),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppText.get('select_state_desc', widget.language),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  DropdownButtonFormField<String>(
                    value: _selectedState,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                    ),
                    hint: Text(widget.language == 'es'
                        ? 'Selecciona un estado'
                        : 'Select a state'),
                    items: USStates.list.map((state) {
                      return DropdownMenuItem<String>(
                        value: state['code'],
                        child: Text(state['name']!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedState = value;
                      });
                    },
                  ),
                  const Spacer(),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _selectedState != null
                        ? () => widget.onStateSelected(_selectedState!)
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      AppText.get('continue', widget.language),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Home Screen
class HomeScreen extends StatefulWidget {
  final String language;
  final String state;
  final Function(String) onLanguageChanged;
  final Function(String) onStateChanged;

  const HomeScreen({
    super.key,
    required this.language,
    required this.state,
    required this.onLanguageChanged,
    required this.onStateChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasContacts = true; // Assume true until checked

  @override
  void initState() {
    super.initState();
    _checkContacts();
  }

  Future<void> _checkContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final family1 = prefs.getString('emergency_family_phone') ?? '';
    final family2 = prefs.getString('emergency_family2_phone') ?? '';
    setState(() {
      _hasContacts = family1.isNotEmpty || family2.isNotEmpty;
    });
  }

  void _shareApp() {
    final String message = widget.language == 'es'
        ? 'Descarga Icemelts - App gratuita con información sobre tus derechos si te detiene ICE, botón de pánico con GPS, y recursos de ayuda.\n\nDescarga aquí: https://github.com/tvictori/icemelts/releases'
        : 'Download Icemelts - Free app with information about your rights if ICE detains you, panic button with GPS, and help resources.\n\nDownload here: https://github.com/tvictori/icemelts/releases';

    Share.share(message);
  }

  @override
  Widget build(BuildContext context) {
    final stateName = USStates.list
        .firstWhere((s) => s['code'] == widget.state,
        orElse: () => {'name': widget.state})['name']!;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppText.get('app_title', widget.language)),
        actions: [
          IconButton(
            onPressed: () => _shareApp(),
            icon: const Icon(Icons.share),
            tooltip: widget.language == 'es' ? 'Compartir' : 'Share',
          ),
          TextButton(
            onPressed: () {
              widget.onLanguageChanged(widget.language == 'es' ? 'en' : 'es');
            },
            child: Text(
              widget.language == 'es' ? 'EN' : 'ES',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Setup banner if no contacts
              if (!_hasContacts)
                _buildSetupBanner(context),
              if (!_hasContacts)
                const SizedBox(height: 16),
              // Location indicator
              Card(
                child: ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(stateName),
                  trailing: TextButton(
                    onPressed: () {
                      _showStateChangeDialog(context);
                    },
                    child: Text(AppText.get('change_state', widget.language)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Main menu items - Si me detienen first, highlighted as emergency
              _buildEmergencyCard(
                context,
                icon: Icons.warning_amber_rounded,
                title: AppText.get('if_detained', widget.language),
                description: AppText.get('if_detained_desc', widget.language),
                onTap: () => _navigateTo(context, 'detained'),
              ),
              const SizedBox(height: 16),
              _buildMenuCard(
                context,
                icon: Icons.shield_outlined,
                title: AppText.get('my_rights', widget.language),
                description: AppText.get('my_rights_desc', widget.language),
                color: Colors.green,
                onTap: () => _navigateTo(context, 'rights'),
              ),
              const SizedBox(height: 12),
              _buildMenuCard(
                context,
                icon: Icons.help_outline,
                title: AppText.get('my_situation', widget.language),
                description: AppText.get('my_situation_desc', widget.language),
                color: Colors.blue,
                onTap: () => _navigateTo(context, 'situation'),
              ),
              const SizedBox(height: 12),
              _buildMenuCard(
                context,
                icon: Icons.people_outline,
                title: AppText.get('resources', widget.language),
                description: AppText.get('resources_desc', widget.language),
                color: Colors.purple,
                onTap: () => _navigateTo(context, 'resources'),
              ),
            ],
          ),
          PanicButton(language: widget.language),
        ],
      ),
    );
  }

  Widget _buildMenuCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String description,
        required Color color,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String description,
        required VoidCallback onTap,
      }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.shade700, Colors.red.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Colors.white, size: 40),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white.withOpacity(0.8),
                size: 32,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSetupBanner(BuildContext context) {
    return Card(
      color: Colors.orange.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.orange.shade300),
      ),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetainedSection(
                language: widget.language,
                state: widget.state,
              ),
            ),
          );
          // Recheck contacts when returning
          _checkContacts();
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.warning_amber, color: Colors.orange.shade800, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.language == 'es'
                          ? '¡Configura el botón SOS!'
                          : 'Set up the SOS button!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.orange.shade900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.language == 'es'
                          ? 'Ve a "Si me detienen" → "Mis contactos de emergencia" para guardar tus contactos.'
                          : 'Go to "If I\'m detained" → "My emergency contacts" to save your contacts.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.orange.shade700),
            ],
          ),
        ),
      ),
    );
  }

  void _showStateChangeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String? newState = widget.state;
        return AlertDialog(
          title: Text(AppText.get('change_state', widget.language)),
          content: DropdownButtonFormField<String>(
            value: newState,
            items: USStates.list.map((s) {
              return DropdownMenuItem<String>(
                value: s['code'],
                child: Text(s['name']!),
              );
            }).toList(),
            onChanged: (value) {
              newState = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(widget.language == 'es' ? 'Cancelar' : 'Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (newState != null) {
                  widget.onStateChanged(newState!);
                  Navigator.pop(context);
                }
              },
              child: Text(widget.language == 'es' ? 'Guardar' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  void _navigateTo(BuildContext context, String section) async {
    Widget screen;
    switch (section) {
      case 'detained':
        screen = DetainedSection(language: widget.language, state: widget.state);
        break;
      case 'situation':
        screen = SituationSection(language: widget.language, state: widget.state);
        break;
      case 'rights':
        screen = RightsSection(language: widget.language, state: widget.state);
        break;
      case 'resources':
        screen = ResourcesSection(language: widget.language, state: widget.state);
        break;
      default:
        screen = PlaceholderScreen(title: section, language: widget.language);
    }
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
    // Recheck contacts when returning
    _checkContacts();
  }
}

// Placeholder screen for sections we'll build out
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String language;

  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              AppText.get('coming_soon', language),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    switch (title) {
      case 'situation':
        return AppText.get('my_situation', language);
      case 'rights':
        return AppText.get('my_rights', language);
      case 'detained':
        return AppText.get('if_detained', language);
      case 'resources':
        return AppText.get('resources', language);
      default:
        return title;
    }
  }
}