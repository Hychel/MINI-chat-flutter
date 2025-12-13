import 'package:flutter_bloc/flutter_bloc.dart';
import '../repositories/firestore_chat_repository.dart';
import '../models/chat_model.dart';

abstract class ChatsEvent {}
class LoadChatsEvent extends ChatsEvent {}
class CreateChatEvent extends ChatsEvent {
  final String title;
  CreateChatEvent(this.title);
}

abstract class ChatsState {}
class ChatsInitial extends ChatsState {}
class ChatsLoading extends ChatsState {}
class ChatsLoaded extends ChatsState {
  final List<ChatThread> chats;
  ChatsLoaded(this.chats);
}
class ChatsError extends ChatsState {
  final String message;
  ChatsError(this.message);
}

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  final FirestoreChatRepository repository;

  ChatsBloc(this.repository) : super(ChatsInitial()) {
    on<LoadChatsEvent>(_onLoadChats);
    on<CreateChatEvent>(_onCreateChat);
  }

  void _onLoadChats(LoadChatsEvent event, Emitter<ChatsState> emit) async {
    emit(ChatsLoading());

    await for (final snapshot in repository.getChats()) {
      print('🔥 Firestore: ${snapshot.length} чатів');
      emit(ChatsLoaded(snapshot));
    }
  }

  void _onCreateChat(CreateChatEvent event, Emitter<ChatsState> emit) async {
    try {
      await repository.createChat(event.title);
      print('🔥 Чат створено: ${event.title}');
    } catch (e) {
      print('🔥 Помилка створення: $e');
      emit(ChatsError(e.toString()));
    }
  }
}
