import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'collection_points_screen.dart';
import 'materials_screen.dart';
import 'profile_screen.dart';
import 'chat_list_screen.dart'; // Importada tela de Chat
import 'login_screen.dart';
import '../models/ponto_coleta.dart';
import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart'; // Importada para abrir URLs
import 'package:provider/provider.dart'; // Importada para usar Provider
import '../services/auth_service.dart'; // Importada para usar AuthService

class HomeScreen extends StatefulWidget {
  final bool isGuest;
  
  const HomeScreen({super.key, this.isGuest = false});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late MapController _mapController;
  
  static const LatLng _initialPosition = LatLng(-10.184444, -48.333889);

  final List<Marker> _markers = [];
  List<PontoColeta> _pontosColeta = [];
  bool _isLoadingPontos = true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _loadPontosColeta();
  }

  Future<void> _loadPontosColeta() async {
    setState(() {
      _isLoadingPontos = true;
    });

    try {
      final pontos = await ApiService.getPontosColeta(pageSize: 100);
      setState(() {
        _pontosColeta = pontos;
        _isLoadingPontos = false;
      });
      _loadMarkers();
    } catch (e) {
      print('Error loading pontos: $e');
      setState(() {
        _isLoadingPontos = false;
      });
    }
  }

  void _loadMarkers() {
    setState(() {
      _markers.clear();
      for (var ponto in _pontosColeta) {
        _markers.add(
          Marker(
            point: LatLng(ponto.latitude, ponto.longitude),
            child: GestureDetector(
              onTap: () => _showPointDetailsFromMarker(ponto),
              child: const Icon(
                Icons.location_pin,
                color: Color(0xFF34CB79),
                size: 40,
              ),
            ),
          ),
        );
      }
    });
  }

  // Método corrigido para abrir Google Maps
  Future<void> _openGoogleMaps(double lat, double lng) async {
    // Tenta abrir com o app nativo do Google Maps primeiro
    final String urlNative = 'google.navigation:q=$lat,$lng';
    final String urlWeb = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng&travelmode=driving';
    final String urlFallback = 'https://maps.google.com/?q=$lat,$lng';

    try {
      final nativeUri = Uri.parse(urlNative);
      final webUri = Uri.parse(urlWeb);
      final fallbackUri = Uri.parse(urlFallback);

      // Tenta abrir no app nativo do Google Maps
      if (await canLaunchUrl(nativeUri)) {
        await launchUrl(
          nativeUri,
          mode: LaunchMode.externalApplication,
        );
      } 
      // Se não conseguir, tenta a versão web com direções
      else if (await canLaunchUrl(webUri)) {
        await launchUrl(
          webUri,
          mode: LaunchMode.externalApplication,
        );
      }
      // Último fallback - apenas mostra a localização
      else if (await canLaunchUrl(fallbackUri)) {
        await launchUrl(
          fallbackUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nenhum app de mapa encontrado. Instale o Google Maps.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      print('Erro ao abrir mapa: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao abrir o mapa: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showPointDetailsFromMarker(PontoColeta ponto) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.85,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    Text(
                      ponto.nome,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey[600], size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            ponto.endereco,
                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),
                    
                    if (ponto.telefone != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.phone, color: Colors.grey[600], size: 20),
                          const SizedBox(width: 8),
                          Text(
                            ponto.telefone!,
                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    ],
                    
                    const SizedBox(height: 24),
                    const Text(
                      'Materiais Aceitos',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: ponto.materiais.map((material) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF34CB79).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF34CB79)),
                          ),
                          child: Text(
                            material.nome,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF34CB79),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                    
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _openGoogleMaps(ponto.latitude, ponto.longitude),
                        icon: const Icon(Icons.directions),
                        label: const Text('Como Chegar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF34CB79),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCurrentScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (widget.isGuest && (index == 3 || index == 4)) {
            _showLoginDialog(context);
            return;
          }
          
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF34CB79),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Pontos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.recycling),
            label: 'Materiais',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _buildMapScreen();
      case 1:
        return const CollectionPointsScreen();
      case 2:
        return const MaterialsScreen();
      case 3:
        if (widget.isGuest) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showLoginDialog(context);
          });
          return _buildMapScreen();
        }
        return const ChatListScreen();
      case 4:
        if (widget.isGuest) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showLoginDialog(context);
          });
          return _buildMapScreen();
        }
        return const ProfileScreen();
      default:
        return _buildMapScreen();
    }
  }

  Widget _buildMapScreen() {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _initialPosition,
            initialZoom: 13.0,
            maxZoom: 18.0,
            minZoom: 3.0,
          ),
          children: [
            // Tile Layer - OpenStreetMap
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.ecoleta',
            ),
            
            // Marker Layer
            MarkerLayer(
              markers: _markers,
            ),
          ],
        ),
        
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: EdgeInsets.fromLTRB(
              16,
              MediaQuery.of(context).padding.top + 16,
              16,
              16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF34CB79),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.recycling,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ecoleta',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF34CB79),
                          ),
                        ),
                        Text(
                          'Encontre pontos de coleta',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Buscar por material ou local',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.filter_list, color: Colors.grey),
                        onPressed: () {
                          _showFilterBottomSheet();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        Positioned(
          bottom: 24,
          right: 16,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: _goToMyLocation,
            child: const Icon(
              Icons.my_location,
              color: Color(0xFF34CB79),
            ),
          ),
        ),

        if (_isLoadingPontos)
          const Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF34CB79),
              ),
            ),
          ),
      ],
    );
  }

  void _goToMyLocation() {
    _mapController.move(_initialPosition, 13.0);
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              const Text(
                'Filtrar por Material',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFilterChip('Papel'),
                  _buildFilterChip('Papelão'),
                  _buildFilterChip('Plástico'),
                  _buildFilterChip('Vidro'),
                  _buildFilterChip('Metal'),
                  _buildFilterChip('Eletrônicos'),
                  _buildFilterChip('Óleo de Cozinha'),
                  _buildFilterChip('Pilhas'),
                  _buildFilterChip('Baterias'),
                ],
              ),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF34CB79),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Aplicar Filtro'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.grey[700],
        ),
      ),
    );
  }

  void _showLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.lock_outline, color: Color(0xFF34CB79)),
            SizedBox(width: 12),
            Text('Login Necessário'),
          ],
        ),
        content: Text(
          'Para acessar esta funcionalidade, você precisa fazer login ou criar uma conta.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF34CB79),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Fazer Login'),
          ),
        ],
      ),
    );
  }
}