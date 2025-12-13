import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/chats_bloc.dart';
import '../repositories/firestore_chat_repository.dart';
import 'chat_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatsBloc(FirestoreChatRepository())..add(LoadChatsEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Active Chats'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),

        body: BlocBuilder<ChatsBloc, ChatsState>(
          builder: (context, state) {
            if (state is ChatsLoading) return Center(child: CircularProgressIndicator());
            if (state is ChatsLoaded) {
              return ListView.separated(
                itemCount: state.chats.length,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (context, index) {
                  final chat = state.chats[index];
                  return ListTile(
                    leading: CircleAvatar(child: Text('@')),
                    title: Text(chat.title),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ChatScreen(chatId: chat.id)),
                    ),
                  );
                },
              );
            }
            return Center(child: Text('No chats'));
          },
        ),
      ),
    );
  }
}
