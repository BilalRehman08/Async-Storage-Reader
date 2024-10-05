import 'package:async_storage_reader/async_storage_reader.dart';
import 'package:async_storage_reader/src/sqlite_storage.dart';
import 'package:async_storage_reader/src/shared_prefs_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([SQLiteStorage, SharedPrefsStorage])
import 'async_storage_reader_android_test.mocks.dart';

void main() {
  late MockSQLiteStorage mockSQLiteStorage;
  late MockSharedPrefsStorage mockSharedPrefsStorage;
  late AsyncStorageReader asyncStorageReader;

  setUp(() {
    mockSQLiteStorage = MockSQLiteStorage();
    mockSharedPrefsStorage = MockSharedPrefsStorage();
    asyncStorageReader = AsyncStorageReader(
      sqliteStorage: mockSQLiteStorage,
      sharedPrefsStorage: mockSharedPrefsStorage,
    );
  });

  group('AsyncStorageReader Android Tests', () {
    test('getItem should return value from SQLite if available', () async {
      when(mockSQLiteStorage.getItemFromSQLite('testKey'))
          .thenAnswer((_) async => 'testValue');

      final result = await asyncStorageReader.getItem('testKey');

      expect(result, 'testValue');
      verify(mockSQLiteStorage.getItemFromSQLite('testKey')).called(1);
      verifyZeroInteractions(mockSharedPrefsStorage);
    });

    test('getAllItems should return all items from SQLite if available',
        () async {
      final sqliteItems = {'key1': 'value1', 'key2': 'value2'};
      when(mockSQLiteStorage.getAllItemsFromSQLite())
          .thenAnswer((_) async => sqliteItems);

      final result = await asyncStorageReader.getAllItems();

      expect(result, sqliteItems);
      verify(mockSQLiteStorage.getAllItemsFromSQLite()).called(1);
      verifyZeroInteractions(mockSharedPrefsStorage);
    });

    test('removeItem should remove from SQLite if present', () async {
      when(mockSQLiteStorage.removeItemFromSQLite('testKey'))
          .thenAnswer((_) async => true);

      final result = await asyncStorageReader.removeItem('testKey');

      expect(result, true);
      verify(mockSQLiteStorage.removeItemFromSQLite('testKey')).called(1);
      verifyZeroInteractions(mockSharedPrefsStorage);
    });

    test('clear should clear SQLite if possible', () async {
      when(mockSQLiteStorage.clearSQLite()).thenAnswer((_) async => true);

      final result = await asyncStorageReader.clear();

      expect(result, true);
      verify(mockSQLiteStorage.clearSQLite()).called(1);
      verifyZeroInteractions(mockSharedPrefsStorage);
    });
  });
}
