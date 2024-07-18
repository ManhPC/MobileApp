// ignore_for_file: unused_import

import 'package:hydrated_bloc/hydrated_bloc.dart';

class StorageInitializer {
  static final StorageInitializer _instance = StorageInitializer._internal();

  factory StorageInitializer() {
    return _instance;
  }

  StorageInitializer._internal();

  Future<void> initialize() async {
    // Khởi tạo và ghi các biến ban đầu vào storage ở đây
    // Ví dụ:
    // await HydratedBloc.storage.write('isDisabled', false);
  }
}
