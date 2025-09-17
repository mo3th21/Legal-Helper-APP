import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:qanon/models/message.dart';
import 'package:qanon/services/ai_service.dart';
import 'package:qanon/utils/network_helper.dart';

class ChatScreen extends StatefulWidget {
  final String category;

  const ChatScreen({super.key, required this.category});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AIService _aiService = AIService();
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    final welcomeMessage = Message(
      text: '''مرحباً بك في قسم **${widget.category}**! 👋

أنا مساعدك القانوني المتخصص في القانون الأردني. أستطيع مساعدتك في:
- **فهم القوانين والأنظمة** الأردنية
- **توضيح الحقوق والواجبات**
- **شرح الإجراءات القانونية**
- **الإجابة على استفساراتك** بدقة

**كيف أقدر أخدمك اليوم؟** 🤝''',
      isUser: false,
    );
    setState(() => _messages.add(welcomeMessage));
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    HapticFeedback.mediumImpact();
    final userMessage = Message(text: text.trim(), isUser: true);
    
    setState(() {
      _messages.add(userMessage);
      _isLoading = true;
    });

    _textController.clear();
    _scrollToBottom();

    final hasConnection = await NetworkHelper.hasInternetConnection();
    if (!hasConnection) {
      _addErrorMessage('عذراً، لا يوجد اتصال بالإنترنت.');
      return;
    }

    try {
      String response = widget.category == 'عام'
          ? await _aiService.getAdvice(text)
          : await _aiService.getCategoryAdvice(widget.category, text);

      setState(() {
        _messages.add(Message(text: response, isUser: false));
        _isLoading = false;
      });
    } catch (e) {
      _addErrorMessage('عذراً، حدث خطأ. يرجى المحاولة مرة أخرى.');
    }

    _scrollToBottom();
  }

  void _addErrorMessage(String text) {
    setState(() {
      _messages.add(Message(text: text, isUser: false));
      _isLoading = false;
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isGeneralChat = widget.category == 'عام';
    
    return Scaffold(
      backgroundColor: isGeneralChat ? const Color(0xFF1A202C) : const Color(0xFFF7FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isGeneralChat ? const Color(0xFF2D3748) : Colors.white,
        foregroundColor: isGeneralChat ? Colors.white : const Color(0xFF2D3748),
        title: Text(
          widget.category,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (!isGeneralChat)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'PRO',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh, size: 20),
            onPressed: () {
              setState(() => _messages.clear());
              _addWelcomeMessage();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isLoading) {
                  return _buildLoadingMessage(isGeneralChat);
                }
                return _buildMessageBubble(_messages[index], isGeneralChat);
              },
            ),
          ),
          _buildInputArea(isGeneralChat),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message, bool isGeneralChat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            _buildAvatar(false),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser 
                    ? const Color(0xFF3182CE)
                    : (isGeneralChat ? const Color(0xFF4A5568) : Colors.white),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: message.isUser ? const Radius.circular(16) : const Radius.circular(4),
                  bottomRight: message.isUser ? const Radius.circular(4) : const Radius.circular(16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: message.isUser
                  ? Text(
                      message.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.4,
                      ),
                    )
                  : MarkdownBody(
                      data: message.text,
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          color: isGeneralChat ? Colors.white : const Color(0xFF2D3748),
                          fontSize: 14,
                          height: 1.5,
                        ),
                        h3: TextStyle(
                          color: isGeneralChat ? Colors.white : const Color(0xFF3182CE),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        listBullet: TextStyle(
                          color: isGeneralChat ? Colors.white : const Color(0xFF3182CE),
                          fontSize: 14,
                        ),
                        strong: TextStyle(
                          color: isGeneralChat ? Colors.white : null,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            _buildAvatar(true),
          ],
        ],
      ),
    );
  }

  Widget _buildAvatar(bool isUser) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isUser ? const Color(0xFFED8936) : const Color(0xFF3182CE),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isUser ? Icons.person : Icons.support_agent,
        color: Colors.white,
        size: 16,
      ),
    );
  }

  Widget _buildLoadingMessage(bool isGeneralChat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          _buildAvatar(false),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isGeneralChat ? const Color(0xFF4A5568) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFF3182CE),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'جار الكتابة...',
                  style: TextStyle(
                    color: isGeneralChat ? Colors.white : const Color(0xFF2D3748),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(bool isGeneralChat) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isGeneralChat ? const Color(0xFF2D3748) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isGeneralChat ? const Color(0xFF4A5568) : const Color(0xFFF7FAFC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _textController,
                maxLines: null,
                textInputAction: TextInputAction.send,
                onSubmitted: _sendMessage,
                style: TextStyle(
                  color: isGeneralChat ? const Color.fromARGB(255, 7, 7, 7) : const Color(0xFF2D3748),
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'اكتب رسالتك...',
                  hintStyle: TextStyle(
                    color: isGeneralChat ? const Color.fromARGB(137, 0, 0, 0) : Colors.grey,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _isLoading ? null : () => _sendMessage(_textController.text),
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFF3182CE),
                shape: BoxShape.circle,
              ),
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}