import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Main entry screen for "Recursos cerca de mí"
class ResourcesSection extends StatelessWidget {
  final String language;
  final String state;

  const ResourcesSection({
    super.key,
    required this.language,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final stateName = _getStateName(state);
    final stateResources = _getStateResources(state);
    final nationalResources = _getNationalResources();

    return Scaffold(
      appBar: AppBar(
        title: Text(_t('resources_near_me')),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // State header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple.shade700, Colors.purple.shade500],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: Colors.white, size: 32),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _t('resources_in'),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        stateName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // State-specific resources
          if (stateResources.isNotEmpty) ...[
            Text(
              _t('state_resources'),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Hotlines first
            if (_hasCategory(stateResources, 'hotline')) ...[
              _buildCategorySection(
                context,
                title: _t('hotlines'),
                icon: Icons.phone_in_talk,
                color: Colors.red,
                resources: _filterByCategory(stateResources, 'hotline'),
              ),
              const SizedBox(height: 16),
            ],

            // Legal aid
            if (_hasCategory(stateResources, 'legal')) ...[
              _buildCategorySection(
                context,
                title: _t('legal_aid'),
                icon: Icons.gavel,
                color: Colors.blue,
                resources: _filterByCategory(stateResources, 'legal'),
              ),
              const SizedBox(height: 16),
            ],

            // Community organizations
            if (_hasCategory(stateResources, 'community')) ...[
              _buildCategorySection(
                context,
                title: _t('community_orgs'),
                icon: Icons.people,
                color: Colors.green,
                resources: _filterByCategory(stateResources, 'community'),
              ),
              const SizedBox(height: 16),
            ],

            // Consulates
            if (_hasCategory(stateResources, 'consulate')) ...[
              _buildCategorySection(
                context,
                title: _t('consulates'),
                icon: Icons.flag,
                color: Colors.orange,
                resources: _filterByCategory(stateResources, 'consulate'),
              ),
              const SizedBox(height: 16),
            ],

            const Divider(height: 32),
          ],

          // National resources
          Text(
            _t('national_resources'),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // National Hotlines
          _buildCategorySection(
            context,
            title: _t('hotlines'),
            icon: Icons.phone_in_talk,
            color: Colors.red,
            resources: _filterByCategory(nationalResources, 'hotline'),
          ),
          const SizedBox(height: 16),

          // National Legal aid
          _buildCategorySection(
            context,
            title: _t('legal_aid'),
            icon: Icons.gavel,
            color: Colors.blue,
            resources: _filterByCategory(nationalResources, 'legal'),
          ),
          const SizedBox(height: 16),

          // National Community organizations
          _buildCategorySection(
            context,
            title: _t('community_orgs'),
            icon: Icons.people,
            color: Colors.green,
            resources: _filterByCategory(nationalResources, 'community'),
          ),
          const SizedBox(height: 24),

          // Disclaimer
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
                      _t('resources_disclaimer'),
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

  Widget _buildCategorySection(
      BuildContext context, {
        required String title,
        required IconData icon,
        required Color color,
        required List<Map<String, String>> resources,
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
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
            ...resources.map((resource) => _buildResourceItem(context, resource, color)),
          ],
        ),
      ),
    );
  }

  Widget _buildResourceItem(BuildContext context, Map<String, String> resource, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            resource['name'] ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          if (resource['description'] != null) ...[
            const SizedBox(height: 4),
            Text(
              language == 'es'
                  ? (resource['description_es'] ?? resource['description']!)
                  : resource['description']!,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (resource['phone'] != null)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _makeCall(resource['phone']!),
                    icon: const Icon(Icons.phone, size: 18),
                    label: Text(
                      resource['phone']!,
                      style: const TextStyle(fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              if (resource['phone'] != null && resource['website'] != null)
                const SizedBox(width: 8),
              if (resource['website'] != null)
                IconButton(
                  onPressed: () => _openWebsite(resource['website']!),
                  icon: Icon(Icons.language, color: color),
                  tooltip: 'Website',
                ),
            ],
          ),
        ],
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

  Future<void> _openWebsite(String url) async {
    final uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      // Could not launch website
    }
  }

  bool _hasCategory(List<Map<String, String>> resources, String category) {
    return resources.any((r) => r['category'] == category);
  }

  List<Map<String, String>> _filterByCategory(List<Map<String, String>> resources, String category) {
    return resources.where((r) => r['category'] == category).toList();
  }

  String _getStateName(String code) {
    final states = {
      'AL': 'Alabama', 'AK': 'Alaska', 'AZ': 'Arizona', 'AR': 'Arkansas',
      'CA': 'California', 'CO': 'Colorado', 'CT': 'Connecticut', 'DE': 'Delaware',
      'FL': 'Florida', 'GA': 'Georgia', 'HI': 'Hawaii', 'ID': 'Idaho',
      'IL': 'Illinois', 'IN': 'Indiana', 'IA': 'Iowa', 'KS': 'Kansas',
      'KY': 'Kentucky', 'LA': 'Louisiana', 'ME': 'Maine', 'MD': 'Maryland',
      'MA': 'Massachusetts', 'MI': 'Michigan', 'MN': 'Minnesota', 'MS': 'Mississippi',
      'MO': 'Missouri', 'MT': 'Montana', 'NE': 'Nebraska', 'NV': 'Nevada',
      'NH': 'New Hampshire', 'NJ': 'New Jersey', 'NM': 'New Mexico', 'NY': 'New York',
      'NC': 'North Carolina', 'ND': 'North Dakota', 'OH': 'Ohio', 'OK': 'Oklahoma',
      'OR': 'Oregon', 'PA': 'Pennsylvania', 'RI': 'Rhode Island', 'SC': 'South Carolina',
      'SD': 'South Dakota', 'TN': 'Tennessee', 'TX': 'Texas', 'UT': 'Utah',
      'VT': 'Vermont', 'VA': 'Virginia', 'WA': 'Washington', 'WV': 'West Virginia',
      'WI': 'Wisconsin', 'WY': 'Wyoming', 'DC': 'Washington D.C.', 'PR': 'Puerto Rico',
    };
    return states[code] ?? code;
  }

  List<Map<String, String>> _getStateResources(String stateCode) {
    // State-specific resources - can be expanded
    final stateResources = <String, List<Map<String, String>>>{
      'CA': [
        {
          'category': 'hotline',
          'name': 'California Immigrant Policy Center',
          'description': 'Statewide immigrant rights hotline',
          'description_es': 'Línea de derechos de inmigrantes estatal',
          'phone': '1-888-624-4752',
          'website': 'https://caimmigrant.org',
        },
        {
          'category': 'legal',
          'name': 'CHIRLA - Coalition for Humane Immigrant Rights',
          'description': 'Legal services and advocacy',
          'description_es': 'Servicios legales y defensa',
          'phone': '1-888-624-4752',
          'website': 'https://www.chirla.org',
        },
        {
          'category': 'community',
          'name': 'CARECEN',
          'description': 'Central American Resource Center',
          'description_es': 'Centro de Recursos Centroamericanos',
          'phone': '(213) 385-7800',
          'website': 'https://www.carecen-la.org',
        },
        {
          'category': 'consulate',
          'name': 'Consulado de México en Los Angeles',
          'description': 'Mexican Consulate',
          'description_es': 'Consulado Mexicano',
          'phone': '(213) 351-6800',
          'website': 'https://consulmex.sre.gob.mx/losangeles',
        },
      ],
      'TX': [
        {
          'category': 'hotline',
          'name': 'RAICES Texas',
          'description': 'Immigration legal services hotline',
          'description_es': 'Línea de servicios legales de inmigración',
          'phone': '(210) 787-3933',
          'website': 'https://www.raicestexas.org',
        },
        {
          'category': 'legal',
          'name': 'Texas RioGrande Legal Aid',
          'description': 'Free legal help for low-income residents',
          'description_es': 'Ayuda legal gratuita para residentes de bajos ingresos',
          'phone': '1-888-988-9996',
          'website': 'https://www.trla.org',
        },
        {
          'category': 'community',
          'name': 'LULAC - League of United Latin American Citizens',
          'description': 'Advocacy and community support',
          'description_es': 'Defensa y apoyo comunitario',
          'phone': '(210) 627-2221',
          'website': 'https://lulac.org',
        },
        {
          'category': 'consulate',
          'name': 'Consulado de México en Houston',
          'description': 'Mexican Consulate',
          'description_es': 'Consulado Mexicano',
          'phone': '(713) 271-6800',
          'website': 'https://consulmex.sre.gob.mx/houston',
        },
      ],
      'NY': [
        {
          'category': 'hotline',
          'name': 'ActionNYC Hotline',
          'description': 'Free immigration legal help from NYC',
          'description_es': 'Ayuda legal de inmigración gratuita de NYC',
          'phone': '1-800-354-0365',
          'website': 'https://www.nyc.gov/actionnyc',
        },
        {
          'category': 'legal',
          'name': 'Make the Road New York',
          'description': 'Legal services and community organizing',
          'description_es': 'Servicios legales y organización comunitaria',
          'phone': '(718) 418-7690',
          'website': 'https://maketheroadny.org',
        },
        {
          'category': 'legal',
          'name': 'New York Immigration Coalition',
          'description': 'Immigration policy and legal referrals',
          'description_es': 'Política de inmigración y referencias legales',
          'phone': '(212) 627-2227',
          'website': 'https://www.nyic.org',
        },
        {
          'category': 'consulate',
          'name': 'Consulado de México en Nueva York',
          'description': 'Mexican Consulate',
          'description_es': 'Consulado Mexicano',
          'phone': '(212) 217-6400',
          'website': 'https://consulmex.sre.gob.mx/nuevayork',
        },
      ],
      'FL': [
        {
          'category': 'hotline',
          'name': 'Florida Immigrant Coalition',
          'description': 'Statewide immigrant rights hotline',
          'description_es': 'Línea estatal de derechos de inmigrantes',
          'phone': '1-888-600-5762',
          'website': 'https://floridaimmigrant.org',
        },
        {
          'category': 'legal',
          'name': 'Americans for Immigrant Justice',
          'description': 'Legal services in South Florida',
          'description_es': 'Servicios legales en el sur de Florida',
          'phone': '(305) 573-1106',
          'website': 'https://aijustice.org',
        },
        {
          'category': 'community',
          'name': 'WeCount!',
          'description': 'Community organizing in South Florida',
          'description_es': 'Organización comunitaria en el sur de Florida',
          'phone': '(305) 247-2147',
          'website': 'https://www.we-count.org',
        },
        {
          'category': 'consulate',
          'name': 'Consulado de México en Miami',
          'description': 'Mexican Consulate',
          'description_es': 'Consulado Mexicano',
          'phone': '(786) 268-4900',
          'website': 'https://consulmex.sre.gob.mx/miami',
        },
      ],
      'IL': [
        {
          'category': 'hotline',
          'name': 'Illinois Coalition for Immigrant and Refugee Rights',
          'description': 'Statewide immigration hotline',
          'description_es': 'Línea estatal de inmigración',
          'phone': '1-855-435-7693',
          'website': 'https://www.icirr.org',
        },
        {
          'category': 'legal',
          'name': 'National Immigrant Justice Center',
          'description': 'Legal services and advocacy',
          'description_es': 'Servicios legales y defensa',
          'phone': '(312) 660-1370',
          'website': 'https://immigrantjustice.org',
        },
        {
          'category': 'community',
          'name': 'Resurrection Project',
          'description': 'Community development and immigration services',
          'description_es': 'Desarrollo comunitario y servicios de inmigración',
          'phone': '(312) 666-1323',
          'website': 'https://resurrectionproject.org',
        },
        {
          'category': 'consulate',
          'name': 'Consulado de México en Chicago',
          'description': 'Mexican Consulate',
          'description_es': 'Consulado Mexicano',
          'phone': '(312) 738-2383',
          'website': 'https://consulmex.sre.gob.mx/chicago',
        },
      ],
      'AZ': [
        {
          'category': 'hotline',
          'name': 'LUCHA Arizona',
          'description': 'Immigrant rights hotline',
          'description_es': 'Línea de derechos de inmigrantes',
          'phone': '(602) 894-8422',
          'website': 'https://luchaaz.org',
        },
        {
          'category': 'legal',
          'name': 'Florence Immigrant & Refugee Rights Project',
          'description': 'Free legal services for detained immigrants',
          'description_es': 'Servicios legales gratuitos para inmigrantes detenidos',
          'phone': '(520) 868-0191',
          'website': 'https://firrp.org',
        },
        {
          'category': 'community',
          'name': 'Puente Arizona',
          'description': 'Community organizing and rapid response',
          'description_es': 'Organización comunitaria y respuesta rápida',
          'phone': '(480) 736-5985',
          'website': 'https://puenteaz.org',
        },
        {
          'category': 'consulate',
          'name': 'Consulado de México en Phoenix',
          'description': 'Mexican Consulate',
          'description_es': 'Consulado Mexicano',
          'phone': '(602) 242-7398',
          'website': 'https://consulmex.sre.gob.mx/phoenix',
        },
      ],
      'NJ': [
        {
          'category': 'hotline',
          'name': 'New Jersey Alliance for Immigrant Justice',
          'description': 'Statewide immigrant rights hotline',
          'description_es': 'Línea estatal de derechos de inmigrantes',
          'phone': '(844) 864-8341',
          'website': 'https://njaij.org',
        },
        {
          'category': 'legal',
          'name': 'American Friends Service Committee - NJ',
          'description': 'Immigration legal services',
          'description_es': 'Servicios legales de inmigración',
          'phone': '(973) 643-3341',
          'website': 'https://www.afsc.org/office/newark-nj',
        },
        {
          'category': 'community',
          'name': 'Make the Road New Jersey',
          'description': 'Community organizing and advocacy',
          'description_es': 'Organización comunitaria y defensa',
          'phone': '(908) 368-7944',
          'website': 'https://maketheroadnj.org',
        },
        {
          'category': 'consulate',
          'name': 'Consulado de México (closest: NYC)',
          'description': 'Mexican Consulate in New York',
          'description_es': 'Consulado Mexicano en Nueva York',
          'phone': '(212) 217-6400',
          'website': 'https://consulmex.sre.gob.mx/nuevayork',
        },
      ],
      'PA': [
        {
          'category': 'hotline',
          'name': 'HIAS Pennsylvania',
          'description': 'Immigration legal services',
          'description_es': 'Servicios legales de inmigración',
          'phone': '(215) 832-0900',
          'website': 'https://hiaspa.org',
        },
        {
          'category': 'legal',
          'name': 'Nationalities Service Center',
          'description': 'Legal and social services for immigrants',
          'description_es': 'Servicios legales y sociales para inmigrantes',
          'phone': '(215) 893-8400',
          'website': 'https://nscphila.org',
        },
        {
          'category': 'community',
          'name': 'JUNTOS',
          'description': 'Latino immigrant community organization',
          'description_es': 'Organización comunitaria de inmigrantes latinos',
          'phone': '(215) 463-5767',
          'website': 'https://vamosjuntos.org',
        },
        {
          'category': 'consulate',
          'name': 'Consulado de México en Philadelphia',
          'description': 'Mexican Consulate',
          'description_es': 'Consulado Mexicano',
          'phone': '(215) 922-4262',
          'website': 'https://consulmex.sre.gob.mx/filadelfia',
        },
      ],
      'CO': [
        {
          'category': 'hotline',
          'name': 'Colorado Immigrant Rights Coalition',
          'description': 'Statewide immigrant rights hotline',
          'description_es': 'Línea estatal de derechos de inmigrantes',
          'phone': '(720) 476-1158',
          'website': 'https://coloradoimmigrant.org',
        },
        {
          'category': 'legal',
          'name': 'Rocky Mountain Immigrant Advocacy Network',
          'description': 'Free immigration legal services',
          'description_es': 'Servicios legales de inmigración gratuitos',
          'phone': '(303) 433-2812',
          'website': 'https://rmian.org',
        },
        {
          'category': 'consulate',
          'name': 'Consulado de México en Denver',
          'description': 'Mexican Consulate',
          'description_es': 'Consulado Mexicano',
          'phone': '(303) 331-1110',
          'website': 'https://consulmex.sre.gob.mx/denver',
        },
      ],
      'NV': [
        {
          'category': 'hotline',
          'name': 'Progressive Leadership Alliance of Nevada',
          'description': 'Immigrant rights hotline',
          'description_es': 'Línea de derechos de inmigrantes',
          'phone': '(702) 791-1965',
          'website': 'https://planevada.org',
        },
        {
          'category': 'legal',
          'name': 'Legal Aid Center of Southern Nevada',
          'description': 'Free legal services',
          'description_es': 'Servicios legales gratuitos',
          'phone': '(702) 386-1070',
          'website': 'https://www.lacsn.org',
        },
        {
          'category': 'consulate',
          'name': 'Consulado de México en Las Vegas',
          'description': 'Mexican Consulate',
          'description_es': 'Consulado Mexicano',
          'phone': '(702) 477-2700',
          'website': 'https://consulmex.sre.gob.mx/lasvegas',
        },
      ],
      'WA': [
        {
          'category': 'hotline',
          'name': 'Washington Immigrant Solidarity Network',
          'description': 'Statewide rapid response hotline',
          'description_es': 'Línea de respuesta rápida estatal',
          'phone': '1-844-724-3737',
          'website': 'https://www.waisn.org',
        },
        {
          'category': 'legal',
          'name': 'Northwest Immigrant Rights Project',
          'description': 'Legal services for immigrants',
          'description_es': 'Servicios legales para inmigrantes',
          'phone': '(206) 587-4009',
          'website': 'https://www.nwirp.org',
        },
        {
          'category': 'community',
          'name': 'OneAmerica',
          'description': 'Immigrant advocacy organization',
          'description_es': 'Organización de defensa de inmigrantes',
          'phone': '(206) 723-2203',
          'website': 'https://weareoneamerica.org',
        },
        {
          'category': 'consulate',
          'name': 'Consulado de México en Seattle',
          'description': 'Mexican Consulate',
          'description_es': 'Consulado Mexicano',
          'phone': '(206) 448-3526',
          'website': 'https://consulmex.sre.gob.mx/seattle',
        },
      ],
      'GA': [
        {
          'category': 'hotline',
          'name': 'Georgia Latino Alliance for Human Rights',
          'description': 'Immigrant rights hotline',
          'description_es': 'Línea de derechos de inmigrantes',
          'phone': '(404) 691-8720',
          'website': 'https://glahr.org',
        },
        {
          'category': 'legal',
          'name': 'Latin American Association',
          'description': 'Legal and social services',
          'description_es': 'Servicios legales y sociales',
          'phone': '(404) 638-1800',
          'website': 'https://thelaa.org',
        },
        {
          'category': 'consulate',
          'name': 'Consulado de México en Atlanta',
          'description': 'Mexican Consulate',
          'description_es': 'Consulado Mexicano',
          'phone': '(404) 266-1913',
          'website': 'https://consulmex.sre.gob.mx/atlanta',
        },
      ],
      'NC': [
        {
          'category': 'hotline',
          'name': 'El Pueblo',
          'description': 'Latino advocacy and support',
          'description_es': 'Defensa y apoyo latino',
          'phone': '(919) 835-1525',
          'website': 'https://elpueblo.org',
        },
        {
          'category': 'legal',
          'name': 'NC Justice Center - Immigrant Rights',
          'description': 'Legal advocacy and services',
          'description_es': 'Defensa y servicios legales',
          'phone': '(919) 856-2570',
          'website': 'https://www.ncjustice.org',
        },
        {
          'category': 'consulate',
          'name': 'Consulado de México en Raleigh',
          'description': 'Mexican Consulate',
          'description_es': 'Consulado Mexicano',
          'phone': '(919) 754-0046',
          'website': 'https://consulmex.sre.gob.mx/raleigh',
        },
      ],
      'MA': [
        {
          'category': 'hotline',
          'name': 'Massachusetts Immigrant and Refugee Advocacy Coalition',
          'description': 'Statewide immigrant rights hotline',
          'description_es': 'Línea estatal de derechos de inmigrantes',
          'phone': '(617) 350-5480',
          'website': 'https://www.miracoalition.org',
        },
        {
          'category': 'legal',
          'name': 'Political Asylum/Immigration Representation Project',
          'description': 'Free legal services for asylum seekers',
          'description_es': 'Servicios legales gratuitos para solicitantes de asilo',
          'phone': '(617) 742-9296',
          'website': 'https://www.pairproject.org',
        },
        {
          'category': 'community',
          'name': 'Centro Presente',
          'description': 'Latino immigrant community organization',
          'description_es': 'Organización comunitaria de inmigrantes latinos',
          'phone': '(617) 497-9080',
          'website': 'https://cpresente.org',
        },
        {
          'category': 'consulate',
          'name': 'Consulado de México en Boston',
          'description': 'Mexican Consulate',
          'description_es': 'Consulado Mexicano',
          'phone': '(617) 426-4181',
          'website': 'https://consulmex.sre.gob.mx/boston',
        },
      ],
    };

    return stateResources[stateCode] ?? [];
  }

  List<Map<String, String>> _getNationalResources() {
    return [
      // Hotlines
      {
        'category': 'hotline',
        'name': 'United We Dream',
        'description': 'National immigrant youth hotline',
        'description_es': 'Línea nacional para jóvenes inmigrantes',
        'phone': '1-844-363-1423',
        'website': 'https://unitedwedream.org',
      },
      {
        'category': 'hotline',
        'name': 'ICE Detainee Locator',
        'description': 'Find someone in ICE detention',
        'description_es': 'Encontrar a alguien detenido por ICE',
        'phone': '1-888-351-4024',
        'website': 'https://locator.ice.gov',
      },
      {
        'category': 'hotline',
        'name': 'National Domestic Violence Hotline',
        'description': 'Help for abuse victims (immigration options available)',
        'description_es': 'Ayuda para víctimas de abuso (opciones de inmigración disponibles)',
        'phone': '1-800-799-7233',
        'website': 'https://www.thehotline.org',
      },
      // Legal aid
      {
        'category': 'legal',
        'name': 'CLINIC - Catholic Legal Immigration Network',
        'description': 'National network of immigration legal services',
        'description_es': 'Red nacional de servicios legales de inmigración',
        'phone': '(301) 565-4800',
        'website': 'https://cliniclegal.org',
      },
      {
        'category': 'legal',
        'name': 'ACLU Immigrants\' Rights Project',
        'description': 'Legal advocacy for immigrant rights',
        'description_es': 'Defensa legal de los derechos de los inmigrantes',
        'phone': '(212) 549-2500',
        'website': 'https://www.aclu.org/issues/immigrants-rights',
      },
      {
        'category': 'legal',
        'name': 'National Immigration Law Center',
        'description': 'Legal rights information and advocacy',
        'description_es': 'Información de derechos legales y defensa',
        'phone': '(213) 639-3900',
        'website': 'https://www.nilc.org',
      },
      // Community organizations
      {
        'category': 'community',
        'name': 'National Council of La Raza (UnidosUS)',
        'description': 'Latino advocacy and community programs',
        'description_es': 'Defensa latina y programas comunitarios',
        'phone': '(202) 785-1670',
        'website': 'https://www.unidosus.org',
      },
      {
        'category': 'community',
        'name': 'Immigrant Legal Resource Center',
        'description': 'Training and resources for immigrant communities',
        'description_es': 'Capacitación y recursos para comunidades inmigrantes',
        'phone': '(415) 255-9499',
        'website': 'https://www.ilrc.org',
      },
      {
        'category': 'community',
        'name': 'National Immigration Project',
        'description': 'Defense of immigrants in criminal and immigration systems',
        'description_es': 'Defensa de inmigrantes en sistemas criminales y de inmigración',
        'phone': '(617) 227-9727',
        'website': 'https://nipnlg.org',
      },
    ];
  }

  String _t(String key) => ResourcesText.get(key, language);
}

// ===========================================
// BILINGUAL TEXT FOR RESOURCES SECTION
// ===========================================
class ResourcesText {
  static String get(String key, String language) {
    final texts = {
      'resources_near_me': {
        'es': 'Recursos cerca de mí',
        'en': 'Resources near me'
      },
      'resources_in': {
        'es': 'Recursos en',
        'en': 'Resources in'
      },
      'state_resources': {
        'es': 'Recursos en tu estado',
        'en': 'Resources in your state'
      },
      'national_resources': {
        'es': 'Recursos nacionales',
        'en': 'National resources'
      },
      'hotlines': {
        'es': 'Líneas de ayuda',
        'en': 'Hotlines'
      },
      'legal_aid': {
        'es': 'Ayuda legal',
        'en': 'Legal aid'
      },
      'community_orgs': {
        'es': 'Organizaciones comunitarias',
        'en': 'Community organizations'
      },
      'consulates': {
        'es': 'Consulados',
        'en': 'Consulates'
      },
      'resources_disclaimer': {
        'es': 'Esta lista no es exhaustiva. Verifica siempre la información antes de compartir datos personales. Las organizaciones listadas no están afiliadas con esta app.',
        'en': 'This list is not exhaustive. Always verify information before sharing personal data. Listed organizations are not affiliated with this app.'
      },
    };
    return texts[key]?[language] ?? key;
  }
}