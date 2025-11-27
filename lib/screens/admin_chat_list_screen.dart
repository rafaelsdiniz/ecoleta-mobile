// screens/admin_chat_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../models/chat_model.dart';
import '../models/enums.dart';
import 'admin_chat_screen.dart';

class AdminChatListScreen extends StatefulWidget {
  const AdminChatListScreen({super.key});

  @override
  State<AdminChatListScreen> createState() => _AdminChatListScreenState();
}

class _AdminChatListScreenState extends State<AdminChatListScreen> {
  List<ChatModel> _chats = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      final chats = await ApiService.getChatsForAdmin();
      
      // Most recent first (descending order)
      chats.sort((a, b) {
        final aLastMsg = a.ultimaMensagem;
        final bLastMsg = b.ultimaMensagem;
        
        if (aLastMsg == null && bLastMsg == null) return 0;
        if (aLastMsg == null) return 1;
        if (bLastMsg == null) return -1;
        
        return bLastMsg.dataEnvio.compareTo(aLastMsg.dataEnvio);
      });
      
      if (mounted) {
        setState(() {
          _chats = chats;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('[v0] Error loading chats: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao carregar conversas'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getLastMessagePreview(ChatModel chat) {
    final lastMessage = chat.ultimaMensagem;
    if (lastMessage == null) return 'Nenhuma mensagem ainda';
    
    String senderName = _getSenderName(lastMessage);
    
    String messageContent = lastMessage.conteudo;
    if (messageContent.length > 30) {
      messageContent = '${messageContent.substring(0, 30)}...';
    }
    
    return '$senderName: $messageContent';
  }

  String _getSenderName(MessageModel message) {
    switch (message.remetente) {
      case Remetente.USUARIO:
        return 'Usuário';
      case Remetente.PONTO_COLETA:
        return 'Ponto Coleta';
      case Remetente.ADM:
        return 'Admin';
      default:
        return 'Desconhecido';
    }
  }

  String _formatLastMessageTime(DateTime? timestamp) {
    if (timestamp == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) return 'Agora';
    if (difference.inHours < 1) return '${difference.inMinutes}m';
    if (difference.inDays < 1) return '${difference.inHours}h';
    if (difference.inDays < 7) return '${difference.inDays}d';
    
    return '${timestamp.day}/${timestamp.month}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF34CB79),
        elevation: 0,
        title: const Text(
          'Conversas',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadChats,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF34CB79)))
          : _chats.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Nenhuma conversa encontrada',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'As conversas aparecerão aqui quando os usuários enviarem mensagens',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadChats,
                  color: const Color(0xFF34CB79),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _chats.length,
                    itemBuilder: (context, index) {
                      final chat = _chats[index];
                      return _buildChatItem(chat);
                    },
                  ),
                ),
    );
  }

  Widget _buildChatItem(ChatModel chat) {
    final lastMessage = chat.ultimaMensagem;
    final hasMessages = lastMessage != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminChatScreen(
                chatId: chat.id,
                usuarioNome: chat.usuarioNome,
                pontoColetaNome: chat.pontoColetaNome,
                usuarioEmail: chat.usuarioEmail,
              ),
            ),
          ).then((_) {
            _loadChats();
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFF2196F3).withOpacity(0.2),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF2196F3),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.usuarioNome,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (chat.usuarioEmail != null && chat.usuarioEmail!.isNotEmpty)
                      Text(
                        chat.usuarioEmail!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.store,
                          size: 14,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            chat.pontoColetaNome,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (hasMessages) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _getLastMessageText(lastMessage!),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (hasMessages)
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _formatDateTime(lastMessage.dataEnvio),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _getColorForSender(lastMessage.remetente),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _getBadgeTextForSender(lastMessage.remetente),
                        style: TextStyle(
                          fontSize: 10,
                          color: _getTextColorForSender(lastMessage.remetente),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLastMessageText(MessageModel message) {
    String senderPrefix = '';
    switch (message.remetente) {
      case Remetente.USUARIO:
        senderPrefix = 'Usuário: ';
        break;
      case Remetente.PONTO_COLETA:
        senderPrefix = 'Ponto: ';
        break;
      case Remetente.ADM:
        senderPrefix = 'Admin: ';
        break;
    }
    
    return '$senderPrefix${message.conteudo}';
  }

  String _formatDateTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);
    final difference = today.difference(messageDate).inDays;

    if (difference == 0) {
      // Today - show time
      return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (difference < 7) {
      // This week - show day count
      return '${difference}d';
    } else {
      // Older - show date
      return '${timestamp.day.toString().padLeft(2, '0')}/${timestamp.month.toString().padLeft(2, '0')}';
    }
  }

  Color _getColorForSender(Remetente remetente) {
    switch (remetente) {
      case Remetente.USUARIO:
        return Colors.blue[50]!;
      case Remetente.PONTO_COLETA:
        return Colors.green[50]!;
      case Remetente.ADM:
        return Colors.orange[50]!;
      default:
        return Colors.grey[50]!;
    }
  }

  Color _getTextColorForSender(Remetente remetente) {
    switch (remetente) {
      case Remetente.USUARIO:
        return Colors.blue[700]!;
      case Remetente.PONTO_COLETA:
        return Colors.green[700]!;
      case Remetente.ADM:
        return Colors.orange[700]!;
      default:
        return Colors.grey[700]!;
    }
  }

  String _getBadgeTextForSender(Remetente remetente) {
    switch (remetente) {
      case Remetente.USUARIO:
        return 'Usuário';
      case Remetente.PONTO_COLETA:
        return 'Ponto';
      case Remetente.ADM:
        return 'Admin';
      default:
        return 'Desconhecido';
    }
  }
}