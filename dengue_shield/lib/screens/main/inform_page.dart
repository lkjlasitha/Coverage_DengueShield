import 'package:dengue_shield/widgets/appbar/appbar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';

class InformScreen extends StatefulWidget {
  const InformScreen({super.key});

  @override
  State<InformScreen> createState() => _InformScreenState();
}

class _InformScreenState extends State<InformScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _chatScrollController = ScrollController();
  final FocusNode _textFieldFocusNode = FocusNode();
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;
  bool _isTextFieldFocused = false;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
    _textFieldFocusNode.addListener(() {
      setState(() {
        _isTextFieldFocused = _textFieldFocusNode.hasFocus;
      });
      // Scroll to bottom when text field is focused
      if (_textFieldFocusNode.hasFocus) {
        _scrollToBottomDelayed();
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _chatScrollController.dispose();
    _textFieldFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final String? chatHistory = prefs.getString('chat_history');
    if (chatHistory != null) {
      setState(() {
        _messages = List<Map<String, dynamic>>.from(json.decode(chatHistory));
      });
    }
  }

  Future<void> _saveChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chat_history', json.encode(_messages));
  }

  Future<void> _clearChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('chat_history');
    setState(() {
      _messages.clear();
    });
  }

  Future<void> _sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': message,
        'isUser': true,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();
    await _saveChatHistory();

    try {
      debugPrint("Sending message: $message");
      // Replace with your actual API endpoint
      final response = await http.post(
        Uri.parse('http://16.171.60.189:8000/ask'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "question": message
        }),
      );
      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Check if the response has the expected format
        if (data['status'] == 'success' && data['answer'] != null) {
          final botResponse = data['answer'];
          setState(() {
            _messages.add({
              'text': botResponse,
              'isUser': false,
              'timestamp': DateTime.now().millisecondsSinceEpoch,
            });
            _isLoading = false;
          });
        } else {
          // Handle case where status is not success
          setState(() {
            _messages.add({
              'text': 'Sorry, I couldn\'t process your question properly. Please try again.',
              'isUser': false,
              'timestamp': DateTime.now().millisecondsSinceEpoch,
            });
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _messages.add({
            'text': 'Sorry, I\'m having trouble responding right now. Please try again later.',
            'isUser': false,
            'timestamp': DateTime.now().millisecondsSinceEpoch,
          });
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add({
          'text': 'I\'m currently offline. Here are some general dengue prevention tips: Use mosquito repellent, eliminate standing water, and seek medical help if you have fever, headache, or joint pain.',
          'isUser': false,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        });
        _isLoading = false;
      });
    }

    _scrollToBottom();
    await _saveChatHistory();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_chatScrollController.hasClients) {
        _chatScrollController.animateTo(
          _chatScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _scrollToBottomDelayed() {
    // Add a slight delay to ensure the UI has updated after focus change
    Future.delayed(Duration(milliseconds: 300), () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_chatScrollController.hasClients) {
          _chatScrollController.animateTo(
            _chatScrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Appbar(),
          Positioned(
            top: screenWidth * 0.35,
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            child: SizedBox(
              height: MediaQuery.of(context).size.height - (screenWidth * 0.35),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Emergency Medical Help Card
                    Container(
                      height:150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 4,
                                  height: 170,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Need Medical Help Fast?',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Call 1919 for the Government\nAmbulance Service',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: ElevatedButton(
                                onPressed: () {
                                  // Handle call action
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                ),
                                child: Text('Call Now'),
                              ),

                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Handle call action
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                            child: Text('Call Now'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
            
                  // Dengue Symptoms Card
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dengue Symptoms',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16),
                          InkWell(
                            onTap: () {
                              // Navigate to symptoms details
                            },
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.medical_services_outlined,
                                    color: Colors.blue,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    'Know the Signs',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
            
                  // Dengue Prevention Guide Card
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dengue Prevention Guide',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 16),
                          InkWell(
                            onTap: () {
                              // Navigate to prevention guide
                            },
                            child: Row(
                              children: [
                                Container(

                                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade600,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Ask Den X',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Transform.translate(
                                        offset: Offset(8, 0),
                                        child: Image.asset(
                                          'assets/icons/image.png',
                                          width: 40,
                                          height: 40,
                                        ),
                                      ),
                                    ],

                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    'Smart Dengue Prevention',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),


                          // Chat messages
                          Container(
                            height: _isTextFieldFocused ? 500 : 300,
                            child: Column(
                              children: [
                                // Messages list
                                Expanded(
                                  child: _messages.isEmpty
                                      ? Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Hi! How can I help you',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.grey[600],
                                                ),

                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              '1:21 pm',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[400],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : ListView.builder(
                                        controller: _chatScrollController,
                                        padding: EdgeInsets.symmetric(horizontal: 16),
                                        itemCount: _messages.length,
                                        itemBuilder: (context, index) {
                                          final message = _messages[index];
                                          final isUser = message['isUser'] as bool;
                                          return Align(
                                            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                                            child: Container(
                                              margin: EdgeInsets.symmetric(vertical: 4),
                                              padding: EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: isUser ? Colors.blue.shade600 : Colors.grey.shade100,
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                              constraints: BoxConstraints(
                                                maxWidth: screenWidth * 0.7,
                                              ),
                                              child: isUser 
                                                ? Text(
                                                    message['text'] as String,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  )
                                                : MarkdownBody(
                                                    data: message['text'] as String,
                                                    styleSheet: MarkdownStyleSheet(
                                                      p: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 14,
                                                        height: 1.4,
                                                      ),
                                                      strong: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      listBullet: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 14,
                                                      ),
                                                      h1: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      h2: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                      h3: TextStyle(
                                                        color: Colors.black87,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                              ),
                              
                              // Loading indicator
                              if (_isLoading)
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Row(
                                    children: [

                                      Expanded(
                                        child: TextField(
                                          controller: _messageController,
                                          focusNode: _textFieldFocusNode,
                                          decoration: InputDecoration(
                                            hintText: 'What are the early warning signs of dengue fever?',
                                            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: BorderSide(color: Colors.grey.shade300),
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: BorderSide(color: Colors.grey.shade300),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(25),
                                              borderSide: BorderSide(color: Colors.blue.shade600),
                                            ),
                                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          ),
                                          onSubmitted: _sendMessage,
                                        ),

                                      ),
                                      SizedBox(width: 8),
                                      Text('DenX is typing...', style: TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                ),
            
                              // Input field
                              Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Colors.grey.shade200),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _messageController,
                                        decoration: InputDecoration(
                                          hintText: 'What are the early warning signs of dengue fever?',
                                          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25),
                                            borderSide: BorderSide(color: Colors.grey.shade300),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25),
                                            borderSide: BorderSide(color: Colors.grey.shade300),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(25),
                                            borderSide: BorderSide(color: Colors.blue.shade600),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                        ),
                                        onSubmitted: _sendMessage,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () => _sendMessage(_messageController.text),
                                      child: Container(
                                        padding: EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade600,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.send,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 100), // Bottom padding for scrolling
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}