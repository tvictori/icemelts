import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class PanicButton extends StatefulWidget {
  final String language;

  const PanicButton({
    super.key,
    required this.language,
  });

  @override
  State<PanicButton> createState() => _PanicButtonState();
}

class _PanicButtonState extends State<PanicButton> with SingleTickerProviderStateMixin {
  bool _isSending = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _sendPanicAlert() async {
    if (_isSending) return;

    setState(() => _isSending = true);
    _animationController.forward().then((_) => _animationController.reverse());

    try {
      // Get emergency contacts
      final prefs = await SharedPreferences.getInstance();
      final family1Phone = prefs.getString('emergency_family_phone') ?? '';
      final family2Phone = prefs.getString('emergency_family2_phone') ?? '';

      // Check if at least one contact exists
      if (family1Phone.isEmpty && family2Phone.isEmpty) {
        _showNoContactsDialog();
        setState(() => _isSending = false);
        return;
      }

      // Get location
      Position? position;
      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) {
            _showLocationDeniedDialog();
            setState(() => _isSending = false);
            return;
          }
        }

        if (permission == LocationPermission.deniedForever) {
          _showLocationDeniedDialog();
          setState(() => _isSending = false);
          return;
        }

        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
          timeLimit: const Duration(seconds: 10),
        );
      } catch (e) {
        position = null;
      }

      // Build message
      String message;
      String? lat;
      String? lng;
      String? mapsLink;

      if (position != null) {
        lat = position.latitude.toStringAsFixed(6);
        lng = position.longitude.toStringAsFixed(6);
        mapsLink = 'https://maps.google.com/?q=$lat,$lng';
        message = 'Me lleva el ICE. Estoy aquí en este momento: $mapsLink';
      } else {
        message = 'Me lleva el ICE. No pude obtener mi ubicación.';
      }

      // Collect phone numbers
      final phoneNumbers = <String>[];
      if (family1Phone.isNotEmpty) {
        phoneNumbers.add(_cleanPhone(family1Phone));
      }
      if (family2Phone.isNotEmpty) {
        phoneNumbers.add(_cleanPhone(family2Phone));
      }

      // Try to send SMS
      bool smsOpened = await _trySendSms(phoneNumbers, message);

      // Vibrate
      HapticFeedback.heavyImpact();

      // If SMS didn't open, show fallback with copy option
      if (!smsOpened && mounted) {
        _showFallbackDialog(message, lat, lng, mapsLink, phoneNumbers);
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.language == 'es'
                  ? 'Error al enviar alerta'
                  : 'Error sending alert',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    setState(() => _isSending = false);
  }

  String _cleanPhone(String phone) {
    return phone.replaceAll(RegExp(r'[^\d+]'), '');
  }

  Future<bool> _trySendSms(List<String> phoneNumbers, String message) async {
    try {
      final recipients = phoneNumbers.join(';');
      final uri = Uri.parse('sms:$recipients?body=${Uri.encodeComponent(message)}');
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      return false;
    }
  }

  void _showNoContactsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          widget.language == 'es'
              ? 'Sin contactos de emergencia'
              : 'No emergency contacts',
        ),
        content: Text(
          widget.language == 'es'
              ? 'Primero debes guardar al menos un contacto familiar en "Si me detienen" → "Mis contactos de emergencia".'
              : 'You must first save at least one family contact in "If I\'m detained" → "My emergency contacts".',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(widget.language == 'es' ? 'Entendido' : 'Got it'),
          ),
        ],
      ),
    );
  }

  void _showLocationDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          widget.language == 'es'
              ? 'Permiso de ubicación necesario'
              : 'Location permission needed',
        ),
        content: Text(
          widget.language == 'es'
              ? 'Para enviar tu ubicación a tus contactos, necesitas permitir el acceso a la ubicación.'
              : 'To send your location to your contacts, you need to allow location access.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(widget.language == 'es' ? 'Cancelar' : 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openAppSettings();
            },
            child: Text(widget.language == 'es' ? 'Abrir ajustes' : 'Open settings'),
          ),
        ],
      ),
    );
  }

  void _showFallbackDialog(String message, String? lat, String? lng, String? mapsLink, List<String> phones) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange.shade700),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.language == 'es'
                    ? 'Copia este mensaje'
                    : 'Copy this message',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: SelectableText(
                  message,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              if (lat != null && lng != null) ...[
                const SizedBox(height: 16),
                Text(
                  widget.language == 'es' ? 'Coordenadas:' : 'Coordinates:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  'Lat: $lat\nLng: $lng',
                  style: const TextStyle(fontFamily: 'monospace'),
                ),
              ],
              const SizedBox(height: 16),
              Text(
                widget.language == 'es'
                    ? 'Enviar a:'
                    : 'Send to:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 4),
              ...phones.map((p) => SelectableText(p)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(widget.language == 'es' ? 'Cerrar' : 'Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: message));
              HapticFeedback.mediumImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    widget.language == 'es'
                        ? '¡Mensaje copiado!'
                        : 'Message copied!',
                  ),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.copy),
            label: Text(widget.language == 'es' ? 'Copiar' : 'Copy'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20,
      right: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scaleAnimation,
            child: GestureDetector(
              onTap: _sendPanicAlert,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade600, Colors.red.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: _isSending
                    ? const Center(
                  child: SizedBox(
                    width: 28,
                    height: 28,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                )
                    : const Icon(
                  Icons.sos,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              widget.language == 'es'
                  ? 'Presiona de nuevo\npara actualizar'
                  : 'Press again\nto update',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================
// TEST PANIC BUTTON SCREEN
// ===========================================
class TestPanicButtonScreen extends StatefulWidget {
  final String language;

  const TestPanicButtonScreen({
    super.key,
    required this.language,
  });

  @override
  State<TestPanicButtonScreen> createState() => _TestPanicButtonScreenState();
}

class _TestPanicButtonScreenState extends State<TestPanicButtonScreen> {
  String? _family1Phone;
  String? _family2Phone;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _family1Phone = prefs.getString('emergency_family_phone') ?? '';
      _family2Phone = prefs.getString('emergency_family2_phone') ?? '';
    });
  }

  Future<void> _sendTestToContact(String phone) async {
    final testMessage = widget.language == 'es'
        ? 'Prueba de Icemelts. Si recibes este mensaje, el botón de pánico funciona.'
        : 'Icemelts test. If you receive this message, the panic button works.';

    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    final uri = Uri.parse('sms:$cleanPhone?body=${Uri.encodeComponent(testMessage)}');

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // Show copy fallback
      if (mounted) {
        _showCopyDialog(testMessage, cleanPhone);
      }
    }
  }

  void _showCopyDialog(String message, String phone) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.language == 'es' ? 'Copiar mensaje' : 'Copy message'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.language == 'es' ? 'Enviar a: $phone' : 'Send to: $phone'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(message),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(widget.language == 'es' ? 'Cerrar' : 'Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: message));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(widget.language == 'es' ? '¡Copiado!' : 'Copied!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            icon: const Icon(Icons.copy),
            label: Text(widget.language == 'es' ? 'Copiar' : 'Copy'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasContacts = (_family1Phone?.isNotEmpty ?? false) || (_family2Phone?.isNotEmpty ?? false);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.language == 'es' ? 'Probar botón de pánico' : 'Test panic button'),
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // How it works
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.language == 'es'
                          ? 'Cómo funciona'
                          : 'How it works',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildStep('1', widget.language == 'es'
                        ? 'Presiona el botón rojo SOS'
                        : 'Press the red SOS button'),
                    _buildStep('2', widget.language == 'es'
                        ? 'La app obtiene tu ubicación'
                        : 'App gets your location'),
                    _buildStep('3', widget.language == 'es'
                        ? 'Se abre tu app de mensajes'
                        : 'Your messaging app opens'),
                    _buildStep('4', widget.language == 'es'
                        ? 'Presiona Enviar'
                        : 'Press Send'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Test section
            Text(
              widget.language == 'es'
                  ? 'Enviar mensaje de prueba'
                  : 'Send test message',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),

            if (!hasContacts)
              Card(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    widget.language == 'es'
                        ? 'Primero guarda al menos un contacto familiar.'
                        : 'First save at least one family contact.',
                    style: TextStyle(color: Colors.orange.shade900),
                  ),
                ),
              ),

            if (_family1Phone?.isNotEmpty ?? false) ...[
              _buildContactTestCard(
                widget.language == 'es' ? 'Contacto 1' : 'Contact 1',
                _family1Phone!,
              ),
              const SizedBox(height: 12),
            ],

            if (_family2Phone?.isNotEmpty ?? false) ...[
              _buildContactTestCard(
                widget.language == 'es' ? 'Contacto 2' : 'Contact 2',
                _family2Phone!,
              ),
              const SizedBox(height: 12),
            ],

            const SizedBox(height: 24),

            // Tip
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.lightbulb, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.language == 'es'
                            ? 'Practica para estar listo en una emergencia real.'
                            : 'Practice to be ready in a real emergency.',
                        style: TextStyle(color: Colors.blue.shade900),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildContactTestCard(String label, String phone) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red.shade100,
          child: Icon(Icons.person, color: Colors.red.shade700),
        ),
        title: Text(label),
        subtitle: Text(phone),
        trailing: ElevatedButton(
          onPressed: () => _sendTestToContact(phone),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade700,
            foregroundColor: Colors.white,
          ),
          child: Text(widget.language == 'es' ? 'Probar' : 'Test'),
        ),
      ),
    );
  }
}