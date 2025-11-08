class ApiConfig {
  static const String baseUrl = 'https://ecoleta-quarkus-1.onrender.com';
  
  // Endpoints
  static const String materiais = '/materiais';
  static const String pontosColeta = '/pontos-coleta';
  static const String usuarios = '/usuarios';
  static const String chats = '/chats';
  
  // Headers
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
