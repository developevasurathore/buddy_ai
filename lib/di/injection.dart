import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddy_ai/core/network/network_info.dart';
import 'package:buddy_ai/features/chat/data/datasources/chat_local_datasource.dart';
import 'package:buddy_ai/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:buddy_ai/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:buddy_ai/features/chat/domain/repositories/chat_repository.dart';
import 'package:buddy_ai/features/chat/domain/usecases/get_chat_history_usecase.dart';
import 'package:buddy_ai/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:buddy_ai/features/chat/presentation/viewmodels/chat_state.dart';
import 'package:buddy_ai/features/chat/presentation/viewmodels/chat_viewmodel.dart';

// ---- Core / External ----
final firebaseFunctionsProvider = Provider<FirebaseFunctions>((ref) {
  return FirebaseFunctions.instance;
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl();
});

// ---- Data Sources ----
final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return ChatRemoteDataSourceImpl(ref.watch(firebaseFunctionsProvider));
});

final chatLocalDataSourceProvider = Provider<ChatLocalDataSource>((ref) {
  return ChatLocalDataSourceImpl();
});

// ---- Repository ----
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(
    remoteDataSource: ref.watch(chatRemoteDataSourceProvider),
    localDataSource: ref.watch(chatLocalDataSourceProvider),
    networkInfo: ref.watch(networkInfoProvider),
  );
});

// ---- UseCases ----
final sendMessageUseCaseProvider = Provider<SendMessageUseCase>((ref) {
  return SendMessageUseCase(ref.watch(chatRepositoryProvider));
});

final getChatHistoryUseCaseProvider = Provider<GetChatHistoryUseCase>((ref) {
  return GetChatHistoryUseCase(ref.watch(chatRepositoryProvider));
});

// ---- ViewModel ----
final chatViewModelProvider =
StateNotifierProvider<ChatViewModel, ChatState>((ref) {
  return ChatViewModel(
    sendMessageUseCase: ref.watch(sendMessageUseCaseProvider),
    getChatHistoryUseCase: ref.watch(getChatHistoryUseCaseProvider),
  );
});