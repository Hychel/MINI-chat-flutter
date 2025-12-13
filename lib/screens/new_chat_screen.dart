import 'package:flutter/material.dart';
import '../repositories/firestore_chat_repository.dart';
import '../core/services/analytics_service.dart';
import '../core/validators.dart';
import 'chat_screen.dart';

class NewChatScreen extends StatefulWidget {
  const NewChatScreen({super.key});

  @override
  State<NewChatScreen> createState() => _NewChatScreenState();
}

class _NewChatScreenState extends State<NewChatScreen> {
  final _nickController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _creating = false;
  final _repo = FirestoreChatRepository();

  @override
  void dispose() {
    _nickController.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _creating = true);

    try {
      final title = _nickController.text.trim();
      await _repo.createChat(title);
      await AnalyticsService.logCreateChat();

      setState(() => _creating = false);
      _nickController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Чат "$title" створено!'), backgroundColor: Colors.white),
        );
      }
    } catch (e) {
      setState(() => _creating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Помилка: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade400),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('New Chat'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nickController,
                decoration: InputDecoration(
                  labelText: 'User nickname',
                  hintText: '@username',
                  prefixIcon: Icon(Icons.alternate_email, color: Colors.grey),
                  border: inputBorder,
                  focusedBorder: inputBorder.copyWith(borderSide: BorderSide(color: Colors.grey.shade400)),
                  errorBorder: inputBorder.copyWith(borderSide: BorderSide(color: Colors.red)),
                  focusedErrorBorder: inputBorder.copyWith(borderSide: BorderSide(color: Colors.red)),
                  filled: true,
                  fillColor: Colors.grey[100],
                  labelStyle: TextStyle(color: Colors.grey),
                ),
                validator: FormValidators.validateNickname,
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _creating ? null : _create,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _creating
                      ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Text('Create chat', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
              SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
