// screens/admin_chat_screen.dart
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/chat_model.dart';
import '../models/enums.dart';

class AdminChatScreen extends StatefulWidget {
  final int chatId;
  final String usuarioNome;
  final String pontoColetaNome;
  final String? usuarioEmail;

  const AdminChatScreen({
    super.key,
    required this.chatId,
    required this.usuarioNome,
    required this.pontoColetaNome,
    this.usuarioEmail,
  });

  @override
  State<AdminChatScreen> createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<MessageModel> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;
  String? _usuarioEmail;

  @override
  void initState() {
    super.initState();
    _usuarioEmail = widget.usuarioEmail;
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      print('[AdminChatScreen] Loading messages for chat: ${widget.chatId}');
      
      final messages = await ApiService.getMessagesByChat(widget.chatId);
      
      print('[AdminChatScreen] Total messages loaded: ${messages.length}');
      
      if (mounted) {
        setState(() {
          _messages = messages;
          _isLoading = false;
        });
      }

      // Scroll para o final
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients && mounted) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    } catch (e) {
      print('[AdminChatScreen] Error loading messages: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _isSending) return;

    final messageText = _messageController.text.trim();
    _messageController.clear();

    if (mounted) {
      setState(() {
        _isSending = true;
      });
    }

    try {
      print('[AdminChatScreen] Sending message: "$messageText"');
      
      final newMessage = await ApiService.sendMessage(
        widget.chatId,
        messageText,
        'ADM',
      );

      if (newMessage != null) {
        print('[AdminChatScreen] Message sent successfully');
        
        if (mounted) {
          setState(() {
            _messages.add(newMessage);
            _isSending = false;
          });
        }

        // Scroll para o final
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients && mounted) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      } else {
        print('[AdminChatScreen] Failed to send message');
        if (mounted) {
          setState(() {
            _isSending = false;
          });
        }
        _showError('Erro ao enviar mensagem');
      }
    } catch (e) {
      print('[AdminChatScreen] Error sending message: $e');
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
      _showError('Erro ao enviar mensagem');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getSenderName(MessageModel message) {
    switch (message.remetente) {
      case Remetente.USUARIO:
        return widget.usuarioNome;
      case Remetente.PONTO_COLETA:
        return widget.pontoColetaNome;
      case Remetente.ADM:
        return 'Admin';
      default:
        return 'Desconhecido';
    }
  }

  IconData _getSenderIcon(Remetente remetente) {
    switch (remetente) {
      case Remetente.USUARIO:
        return Icons.person;
      case Remetente.PONTO_COLETA:
        return Icons.store;
      case Remetente.ADM:
        return Icons.admin_panel_settings;
      default:
        return Icons.person;
    }
  }

  Color _getSenderColor(Remetente remetente) {
    switch (remetente) {
      case Remetente.USUARIO:
        return const Color(0xFF2196F3);
      case Remetente.PONTO_COLETA:
        return const Color(0xFF34CB79);
      case Remetente.ADM:
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF2196F3);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF34CB79),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.usuarioNome,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _loadMessages,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: const Color(0xFF2196F3).withOpacity(0.1),
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
                        widget.usuarioNome,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (_usuarioEmail != null)
                        Text(
                          _usuarioEmail!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        widget.pontoColetaNome,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF34CB79).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_messages.length} msgs',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF34CB79),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF34CB79)))
                : _messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhuma mensagem ainda',
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Inicie a conversa com o usuário!',
                              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          final isMe = message.remetente == Remetente.ADM;
                          return _buildMessageBubble(message, isMe);
                        },
                      ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(MessageModel message, bool isMe) {
    final senderName = _getSenderName(message);
    final senderColor = _getSenderColor(message.remetente);
    final senderIcon = _getSenderIcon(message.remetente);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 16,
              backgroundColor: senderColor.withOpacity(0.1),
              child: Icon(
                senderIcon,
                color: senderColor,
                size: 16,
              ),
            ),
          if (!isMe) const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 6, left: 8, right: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: senderColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              senderIcon,
                              size: 12,
                              color: senderColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              senderName,
                              style: TextStyle(
                                fontSize: 11,
                                color: senderColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isMe ? senderColor : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.conteudo,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    _formatMessageTime(message.dataEnvio),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isMe) const SizedBox(width: 8),
          if (isMe)
            CircleAvatar(
              radius: 16,
              backgroundColor: senderColor.withOpacity(0.1),
              child: Icon(
                senderIcon,
                color: senderColor,
                size: 16,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'Digite uma mensagem...',
                  border: InputBorder.none,
                ),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                enabled: !_isSending,
              ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            backgroundColor: _isSending ? Colors.grey : const Color(0xFFFF9800),
            radius: 24,
            child: _isSending
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: _sendMessage,
                  ),
          ),
        ],
      ),
    );
  }

  String _formatMessageTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    final time = '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
    
    if (messageDate == today) {
      return time;
    } else if (messageDate.year == today.year) {
      return '${timestamp.day}/${timestamp.month} $time';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year} $time';
    }
  }
}