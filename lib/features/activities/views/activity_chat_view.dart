import 'package:flutter/material.dart';
import 'package:app_arzsuite/core/theme/app_theme.dart';
// import 'package:app_arzsuite/core/widgets/responsive_container.dart';

enum ChatMode { bidirectional, replyOnly, readOnly }

class ActivityChatView extends StatefulWidget {
  final ChatMode mode;

  const ActivityChatView({super.key, this.mode = ChatMode.bidirectional});

  @override
  State<ActivityChatView> createState() => _ActivityChatViewState();
}

class _ActivityChatViewState extends State<ActivityChatView> {
  final TextEditingController _messageController = TextEditingController();
  final List<MessageMock> _messages = [
    MessageMock(sender: 'Prof. Carlos', text: '¡Buen día! Recuerden el torneo de mañana.', time: '09:00', isMe: false),
    MessageMock(sender: 'Tutor Juanito', text: 'Entendido, ahí estaremos.', time: '09:05', isMe: true, isRead: true),
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      _messages.add(MessageMock(
        sender: 'Tutor Juanito',
        text: _messageController.text,
        time: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
        isMe: true,
        isRead: false,
      ));
      _messageController.clear();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.neutral50,
      appBar: AppBar(
        title: const Text('Chat: Fútbol Infantil'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () {
              // Ver información del chat o participantes
            },
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(AppTheme.spacingLarge),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _MessageBubble(message: msg);
              },
            ),
          ),
          if (widget.mode == ChatMode.readOnly)
             Container(
               width: double.infinity,
               padding: const EdgeInsets.all(AppTheme.spacingLarge),
               color: AppTheme.neutral100,
               child: const Text(
                 'El profesor configuró este grupo para solo recibir comunicados. No se puede responder.',
                 textAlign: TextAlign.center,
                 style: TextStyle(color: AppTheme.neutral600, fontWeight: FontWeight.bold, fontSize: 12),
               ),
             )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMedium, vertical: AppTheme.spacingSmall),
              color: Colors.white,
              child: SafeArea(
                child: Row(
                  children: [
                     Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Escribir mensaje...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppTheme.borderRadiusGlobal),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: AppTheme.neutral100,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingSmall),
                    Container(
                      decoration: const BoxDecoration(
                        color: AppTheme.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send_rounded, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageMock message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: message.isMe ? AppTheme.primaryColor.withValues(alpha: 0.1) : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(AppTheme.borderRadiusMedium),
            topRight: const Radius.circular(AppTheme.borderRadiusMedium),
            bottomLeft: Radius.circular(message.isMe ? AppTheme.borderRadiusMedium : 0),
            bottomRight: Radius.circular(message.isMe ? 0 : AppTheme.borderRadiusMedium),
          ),
          border: Border.all(
            color: message.isMe ? Colors.transparent : AppTheme.neutral100,
          ),
        ),
        child: Column(
          crossAxisAlignment: message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!message.isMe)
              Text(
                message.sender,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppTheme.primaryColor),
              ),
            if (!message.isMe) const SizedBox(height: 4),
            Text(
              message.text,
              style: const TextStyle(color: AppTheme.neutral900),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.time,
                  style: const TextStyle(fontSize: 10, color: AppTheme.neutral500),
                ),
                if (message.isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isRead ? Icons.done_all_rounded : Icons.check_rounded,
                    size: 14,
                    color: message.isRead ? Colors.blue : AppTheme.neutral500,
                  ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Modelo de prueba
class MessageMock {
  final String sender;
  final String text;
  final String time;
  final bool isMe;
  final bool isRead;

  MessageMock({
    required this.sender,
    required this.text,
    required this.time,
    required this.isMe,
    this.isRead = false,
  });
}
