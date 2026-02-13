import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'panic_button.dart';

// Main entry screen for "Si me detienen"
class DetainedSection extends StatelessWidget {
  final String language;
  final String state;

  const DetainedSection({
    super.key,
    required this.language,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t('if_detained')),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // PANIC MODE BUTTON
            Expanded(
              child: _buildModeCard(
                context,
                icon: Icons.warning_rounded,
                title: _t('emergency_now'),
                subtitle: _t('emergency_now_desc'),
                color: Colors.red.shade700,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PanicMode(
                        language: language,
                        state: state,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // PREPARE MODE BUTTON
            Expanded(
              child: _buildModeCard(
                context,
                icon: Icons.menu_book_rounded,
                title: _t('prepare_ahead'),
                subtitle: _t('prepare_ahead_desc'),
                color: Colors.blue.shade700,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrepareMode(
                        language: language,
                        state: state,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // EMERGENCY CONTACTS
            Expanded(
              child: _buildModeCard(
                context,
                icon: Icons.contacts_rounded,
                title: _t('my_contacts'),
                subtitle: _t('my_contacts_desc'),
                color: Colors.green.shade700,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmergencyContactsScreen(
                        language: language,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Color color,
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
              colors: [color, color.withOpacity(0.8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Colors.white),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _t(String key) {
    return DetainedText.get(key, language);
  }
}

// ===========================================
// PANIC MODE - High contrast, minimal text
// ===========================================
class PanicMode extends StatefulWidget {
  final String language;
  final String state;

  const PanicMode({
    super.key,
    required this.language,
    required this.state,
  });

  @override
  State<PanicMode> createState() => _PanicModeState();
}

class _PanicModeState extends State<PanicMode> {
  int _currentStep = 0;
  Map<String, String> _emergencyContacts = {};

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _emergencyContacts = {
        'family_name': prefs.getString('emergency_family_name') ?? '',
        'family_phone': prefs.getString('emergency_family_phone') ?? '',
        'lawyer_name': prefs.getString('emergency_lawyer_name') ?? '',
        'lawyer_phone': prefs.getString('emergency_lawyer_phone') ?? '',
      };
    });
  }

  List<Map<String, dynamic>> get _steps => [
    {
      'icon': Icons.pause_circle_filled,
      'title': _t('panic_stay_calm'),
      'subtitle': _t('panic_stay_calm_detail'),
      'color': Colors.blue.shade800,
    },
    {
      'icon': Icons.volume_off,
      'title': _t('panic_stay_silent'),
      'subtitle': _t('panic_stay_silent_detail'),
      'color': Colors.purple.shade800,
    },
    {
      'icon': Icons.edit_off,
      'title': _t('panic_dont_sign'),
      'subtitle': _t('panic_dont_sign_detail'),
      'color': Colors.orange.shade800,
    },
    {
      'icon': Icons.gavel,
      'title': _t('panic_ask_lawyer'),
      'subtitle': _t('panic_ask_lawyer_detail'),
      'color': Colors.green.shade800,
    },
    {
      'icon': Icons.phone,
      'title': _t('panic_call'),
      'subtitle': _t('panic_call_detail'),
      'color': Colors.red.shade800,
      'showContacts': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStep];

    return Scaffold(
      backgroundColor: step['color'] as Color,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        title: Text('${_currentStep + 1} / ${_steps.length}'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragEnd: (details) {
            if (details.primaryVelocity! < 0 && _currentStep < _steps.length - 1) {
              setState(() => _currentStep++);
            } else if (details.primaryVelocity! > 0 && _currentStep > 0) {
              setState(() => _currentStep--);
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  step['icon'] as IconData,
                  size: 100,
                  color: Colors.white,
                ),
                const SizedBox(height: 40),
                Text(
                  step['title'] as String,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  step['subtitle'] as String,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                if (step['showContacts'] == true) ...[
                  const SizedBox(height: 32),
                  _buildQuickContacts(),
                ],
                const Spacer(),
                _buildNavigation(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickContacts() {
    final hasFamily = _emergencyContacts['family_phone']?.isNotEmpty ?? false;
    final hasLawyer = _emergencyContacts['lawyer_phone']?.isNotEmpty ?? false;

    return Column(
      children: [
        if (hasFamily)
          _buildCallButton(
            _emergencyContacts['family_name'] ?? _t('family'),
            _emergencyContacts['family_phone']!,
            Icons.family_restroom,
          ),
        if (hasFamily) const SizedBox(height: 12),
        if (hasLawyer)
          _buildCallButton(
            _emergencyContacts['lawyer_name'] ?? _t('lawyer'),
            _emergencyContacts['lawyer_phone']!,
            Icons.gavel,
          ),
        if (hasLawyer) const SizedBox(height: 12),
        _buildCallButton(
          'United We Dream',
          '1-844-363-1423',
          Icons.people,
        ),
        if (!hasFamily && !hasLawyer) ...[
          const SizedBox(height: 16),
          Text(
            _t('no_contacts_saved'),
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  Widget _buildCallButton(String name, String phone, IconData icon) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _makeCall(phone),
        icon: Icon(icon),
        label: Text(
          '$name\n$phone',
          textAlign: TextAlign.center,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }

  Future<void> _makeCall(String phone) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri.parse('tel:$cleanPhone');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // Could not launch phone
    }
  }

  Widget _buildNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (_currentStep > 0)
          IconButton(
            onPressed: () => setState(() => _currentStep--),
            icon: const Icon(Icons.arrow_back_rounded, size: 40),
            color: Colors.white,
          )
        else
          const SizedBox(width: 56),
        Row(
          children: List.generate(
            _steps.length,
                (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: index == _currentStep ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: index == _currentStep
                    ? Colors.white
                    : Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        if (_currentStep < _steps.length - 1)
          IconButton(
            onPressed: () => setState(() => _currentStep++),
            icon: const Icon(Icons.arrow_forward_rounded, size: 40),
            color: Colors.white,
          )
        else
          const SizedBox(width: 56),
      ],
    );
  }

  String _t(String key) => DetainedText.get(key, widget.language);
}

// ===========================================
// PREPARE MODE - Detailed information
// ===========================================
class PrepareMode extends StatelessWidget {
  final String language;
  final String state;

  const PrepareMode({
    super.key,
    required this.language,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_t('prepare_ahead')),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context,
            title: _t('your_rights_title'),
            icon: Icons.shield,
            color: Colors.green,
            items: [
              _t('right_silent'),
              _t('right_lawyer'),
              _t('right_call'),
              _t('right_hearing'),
              _t('right_consulate'),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: _t('dont_do_title'),
            icon: Icons.block,
            color: Colors.red,
            items: [
              _t('dont_run'),
              _t('dont_resist'),
              _t('dont_lie'),
              _t('dont_sign'),
              _t('dont_fake_docs'),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: _t('prepare_now_title'),
            icon: Icons.checklist,
            color: Colors.orange,
            items: [
              _t('prepare_contacts'),
              _t('prepare_lawyer'),
              _t('prepare_docs'),
              _t('prepare_plan'),
              _t('prepare_money'),
            ],
          ),
          const SizedBox(height: 16),
          _buildSection(
            context,
            title: _t('family_should_title'),
            icon: Icons.family_restroom,
            color: Colors.purple,
            items: [
              _t('family_locator'),
              _t('family_lawyer'),
              _t('family_docs'),
              _t('family_bond'),
            ],
          ),
          const SizedBox(height: 16),
          _buildHotlinesCard(context),
          const SizedBox(height: 24),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                  Icon(Icons.check_circle, color: color, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 15),
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

  Widget _buildHotlinesCard(BuildContext context) {
    final hotlines = [
      {'name': 'United We Dream', 'phone': '1-844-363-1423'},
      {'name': 'National Immigration Law Center', 'phone': '213-639-3900'},
      {'name': 'ACLU Immigrants\' Rights', 'phone': '212-549-2500'},
      {'name': 'ICE Detainee Locator', 'phone': '1-888-351-4024'},
    ];

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.phone, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Text(
                  _t('hotlines_title'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...hotlines.map((h) => _buildHotlineItem(context, h['name']!, h['phone']!)),
          ],
        ),
      ),
    );
  }

  Widget _buildHotlineItem(BuildContext context, String name, String phone) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () async {
          final uri = Uri.parse('tel:$phone');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        },
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    phone,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(Icons.call, color: Colors.blue.shade700),
          ],
        ),
      ),
    );
  }

  String _t(String key) => DetainedText.get(key, language);
}

// ===========================================
// EMERGENCY CONTACTS SCREEN
// ===========================================
class EmergencyContactsScreen extends StatefulWidget {
  final String language;

  const EmergencyContactsScreen({
    super.key,
    required this.language,
  });

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final _familyNameController = TextEditingController();
  final _familyPhoneController = TextEditingController();
  final _family2NameController = TextEditingController();
  final _family2PhoneController = TextEditingController();
  final _lawyerNameController = TextEditingController();
  final _lawyerPhoneController = TextEditingController();
  final _consulateController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _familyNameController.text = prefs.getString('emergency_family_name') ?? '';
      _familyPhoneController.text = prefs.getString('emergency_family_phone') ?? '';
      _family2NameController.text = prefs.getString('emergency_family2_name') ?? '';
      _family2PhoneController.text = prefs.getString('emergency_family2_phone') ?? '';
      _lawyerNameController.text = prefs.getString('emergency_lawyer_name') ?? '';
      _lawyerPhoneController.text = prefs.getString('emergency_lawyer_phone') ?? '';
      _consulateController.text = prefs.getString('emergency_consulate') ?? '';
      _isLoading = false;
    });
  }

  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('emergency_family_name', _familyNameController.text);
    await prefs.setString('emergency_family_phone', _familyPhoneController.text);
    await prefs.setString('emergency_family2_name', _family2NameController.text);
    await prefs.setString('emergency_family2_phone', _family2PhoneController.text);
    await prefs.setString('emergency_lawyer_name', _lawyerNameController.text);
    await prefs.setString('emergency_lawyer_phone', _lawyerPhoneController.text);
    await prefs.setString('emergency_consulate', _consulateController.text);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_t('contacts_saved')),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _familyNameController.dispose();
    _familyPhoneController.dispose();
    _family2NameController.dispose();
    _family2PhoneController.dispose();
    _lawyerNameController.dispose();
    _lawyerPhoneController.dispose();
    _consulateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text(_t('my_contacts'))),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_t('my_contacts')),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _saveContacts,
            icon: const Icon(Icons.save),
            tooltip: _t('save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            _t('contacts_intro'),
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          _buildContactCard(
            title: _t('family_contact'),
            subtitle: _t('family_contact_desc'),
            icon: Icons.family_restroom,
            color: Colors.blue,
            nameController: _familyNameController,
            phoneController: _familyPhoneController,
          ),
          const SizedBox(height: 16),
          _buildContactCard(
            title: _t('family_contact_2'),
            subtitle: _t('family_contact_2_desc'),
            icon: Icons.person,
            color: Colors.teal,
            nameController: _family2NameController,
            phoneController: _family2PhoneController,
          ),
          const SizedBox(height: 16),
          _buildContactCard(
            title: _t('lawyer_contact'),
            subtitle: _t('lawyer_contact_desc'),
            icon: Icons.gavel,
            color: Colors.purple,
            nameController: _lawyerNameController,
            phoneController: _lawyerPhoneController,
          ),
          const SizedBox(height: 16),
          _buildConsulateCard(),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _saveContacts,
            icon: const Icon(Icons.save),
            label: Text(_t('save_contacts')),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TestPanicButtonScreen(
                    language: widget.language,
                  ),
                ),
              );
            },
            icon: Icon(Icons.sos, color: Colors.red.shade700),
            label: Text(
              _t('test_panic_button'),
              style: TextStyle(color: Colors.red.shade700),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.red.shade700),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required TextEditingController nameController,
    required TextEditingController phoneController,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
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
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: _t('name'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(
                labelText: _t('phone'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-() ]')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsulateCard() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.flag, color: Colors.orange),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _t('consulate_contact'),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _t('consulate_contact_desc'),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _consulateController,
              decoration: InputDecoration(
                labelText: _t('consulate_phone'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-() ]')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _t(String key) => DetainedText.get(key, widget.language);
}

// ===========================================
// BILINGUAL TEXT FOR DETAINED SECTION
// ===========================================
class DetainedText {
  static String get(String key, String language) {
    final texts = {
      // Main section
      'if_detained': {'es': 'Si me detienen', 'en': 'If I\'m detained'},
      'emergency_now': {'es': '¡EMERGENCIA!', 'en': 'EMERGENCY!'},
      'emergency_now_desc': {
        'es': 'Me están deteniendo ahora',
        'en': 'I\'m being detained right now'
      },
      'prepare_ahead': {'es': 'Prepárate', 'en': 'Prepare'},
      'prepare_ahead_desc': {
        'es': 'Lee esta información antes de una emergencia',
        'en': 'Read this information before an emergency'
      },
      'my_contacts': {
        'es': 'Mis contactos de emergencia',
        'en': 'My emergency contacts'
      },
      'my_contacts_desc': {
        'es': 'Guarda tus contactos importantes',
        'en': 'Save your important contacts'
      },

      // Panic mode steps
      'panic_stay_calm': {'es': 'MANTÉN LA CALMA', 'en': 'STAY CALM'},
      'panic_stay_calm_detail': {
        'es': 'Respira profundo. No corras. No te resistas.',
        'en': 'Breathe deeply. Don\'t run. Don\'t resist.'
      },
      'panic_stay_silent': {
        'es': 'GUARDA SILENCIO',
        'en': 'REMAIN SILENT'
      },
      'panic_stay_silent_detail': {
        'es': 'Tienes derecho a no contestar preguntas. Di: "Quiero hablar con un abogado"',
        'en': 'You have the right not to answer questions. Say: "I want to speak with a lawyer"'
      },
      'panic_dont_sign': {'es': 'NO FIRMES NADA', 'en': 'DON\'T SIGN ANYTHING'},
      'panic_dont_sign_detail': {
        'es': 'No firmes ningún documento sin un abogado presente',
        'en': 'Don\'t sign any documents without a lawyer present'
      },
      'panic_ask_lawyer': {'es': 'PIDE UN ABOGADO', 'en': 'ASK FOR A LAWYER'},
      'panic_ask_lawyer_detail': {
        'es': 'Repite: "Quiero un abogado" - No digas nada más',
        'en': 'Repeat: "I want a lawyer" - Don\'t say anything else'
      },
      'panic_call': {'es': 'HAZ TU LLAMADA', 'en': 'MAKE YOUR CALL'},
      'panic_call_detail': {
        'es': 'Tienes derecho a hacer una llamada telefónica',
        'en': 'You have the right to make a phone call'
      },
      'no_contacts_saved': {
        'es': 'No tienes contactos guardados. Añádelos en la sección de contactos.',
        'en': 'You don\'t have saved contacts. Add them in the contacts section.'
      },
      'family': {'es': 'Familia', 'en': 'Family'},
      'lawyer': {'es': 'Abogado', 'en': 'Lawyer'},

      // Prepare mode
      'your_rights_title': {'es': 'Tus derechos', 'en': 'Your rights'},
      'right_silent': {
        'es': 'Derecho a guardar silencio - no tienes que contestar preguntas',
        'en': 'Right to remain silent - you don\'t have to answer questions'
      },
      'right_lawyer': {
        'es': 'Derecho a un abogado - puedes pedir hablar con uno',
        'en': 'Right to an attorney - you can ask to speak with one'
      },
      'right_call': {
        'es': 'Derecho a una llamada telefónica',
        'en': 'Right to a phone call'
      },
      'right_hearing': {
        'es': 'Derecho a una audiencia ante un juez de inmigración',
        'en': 'Right to a hearing before an immigration judge'
      },
      'right_consulate': {
        'es': 'Derecho a contactar tu consulado',
        'en': 'Right to contact your consulate'
      },

      'dont_do_title': {'es': 'Lo que NO debes hacer', 'en': 'What NOT to do'},
      'dont_run': {
        'es': 'No corras ni huyas - puede empeorar tu situación',
        'en': 'Don\'t run or flee - it can worsen your situation'
      },
      'dont_resist': {
        'es': 'No te resistas físicamente',
        'en': 'Don\'t physically resist'
      },
      'dont_lie': {
        'es': 'No mientas ni des información falsa',
        'en': 'Don\'t lie or give false information'
      },
      'dont_sign': {
        'es': 'No firmes documentos que no entiendas',
        'en': 'Don\'t sign documents you don\'t understand'
      },
      'dont_fake_docs': {
        'es': 'No presentes documentos falsos',
        'en': 'Don\'t present fake documents'
      },

      'prepare_now_title': {
        'es': 'Prepárate ahora',
        'en': 'Prepare now'
      },
      'prepare_contacts': {
        'es': 'Guarda contactos de emergencia en esta app',
        'en': 'Save emergency contacts in this app'
      },
      'prepare_lawyer': {
        'es': 'Busca un abogado de inmigración ahora, antes de necesitarlo',
        'en': 'Find an immigration lawyer now, before you need one'
      },
      'prepare_docs': {
        'es': 'Ten copias de documentos importantes en un lugar seguro',
        'en': 'Keep copies of important documents in a safe place'
      },
      'prepare_plan': {
        'es': 'Haz un plan con tu familia sobre qué hacer si te detienen',
        'en': 'Make a plan with your family about what to do if you\'re detained'
      },
      'prepare_money': {
        'es': 'Guarda dinero para emergencias y posible fianza',
        'en': 'Save money for emergencies and possible bond'
      },

      'family_should_title': {
        'es': 'Qué debe hacer tu familia',
        'en': 'What your family should do'
      },
      'family_locator': {
        'es': 'Usar el localizador de detenidos de ICE: 1-888-351-4024',
        'en': 'Use the ICE detainee locator: 1-888-351-4024'
      },
      'family_lawyer': {
        'es': 'Contactar a un abogado de inmigración inmediatamente',
        'en': 'Contact an immigration lawyer immediately'
      },
      'family_docs': {
        'es': 'Reunir documentos: acta de nacimiento, identificación, prueba de residencia',
        'en': 'Gather documents: birth certificate, ID, proof of residence'
      },
      'family_bond': {
        'es': 'Preparar dinero para la fianza si es elegible',
        'en': 'Prepare money for bond if eligible'
      },

      'hotlines_title': {
        'es': 'Líneas de ayuda',
        'en': 'Help hotlines'
      },

      // Emergency contacts screen
      'contacts_intro': {
        'es': 'Guarda los contactos de las personas que deben saber si te detienen. Esta información se guarda solo en tu teléfono.',
        'en': 'Save the contacts of people who should know if you\'re detained. This information is saved only on your phone.'
      },
      'family_contact': {
        'es': 'Contacto familiar 1',
        'en': 'Family contact 1'
      },
      'family_contact_desc': {
        'es': 'Persona de confianza que debe saber si te detienen',
        'en': 'Trusted person who should know if you\'re detained'
      },
      'family_contact_2': {
        'es': 'Contacto familiar 2',
        'en': 'Family contact 2'
      },
      'family_contact_2_desc': {
        'es': 'Segunda persona de confianza (respaldo)',
        'en': 'Second trusted person (backup)'
      },
      'lawyer_contact': {
        'es': 'Abogado',
        'en': 'Lawyer'
      },
      'lawyer_contact_desc': {
        'es': 'Abogado de inmigración o legal',
        'en': 'Immigration or legal attorney'
      },
      'consulate_contact': {
        'es': 'Consulado',
        'en': 'Consulate'
      },
      'consulate_contact_desc': {
        'es': 'El consulado de tu país de origen',
        'en': 'Your home country\'s consulate'
      },
      'name': {'es': 'Nombre', 'en': 'Name'},
      'phone': {'es': 'Teléfono', 'en': 'Phone'},
      'consulate_phone': {
        'es': 'Teléfono del consulado',
        'en': 'Consulate phone'
      },
      'save': {'es': 'Guardar', 'en': 'Save'},
      'save_contacts': {
        'es': 'Guardar contactos',
        'en': 'Save contacts'
      },
      'contacts_saved': {
        'es': '¡Contactos guardados!',
        'en': 'Contacts saved!'
      },
      'test_panic_button': {
        'es': 'Probar botón de pánico',
        'en': 'Test panic button'
      },
    };
    return texts[key]?[language] ?? key;
  }
}