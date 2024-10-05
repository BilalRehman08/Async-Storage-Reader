import 'package:async_storage_reader/async_storage_reader.dart';
import 'package:async_storage_reader/src/ios_storage.dart';
import 'package:async_storage_reader/src/sqlite_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([SQLiteStorage, IOSStorage])
import 'async_storage_reader_ios_test.mocks.dart';

void main() {
  late MockSQLiteStorage mockSQLiteStorage;
  late MockIOSStorage mockIOSStorage;
  late AsyncStorageReader asyncStorageReader;

  setUp(() {
    mockSQLiteStorage = MockSQLiteStorage();
    mockIOSStorage = MockIOSStorage();
    asyncStorageReader = AsyncStorageReader(
      sqliteStorage: mockSQLiteStorage,
      iosStorage: mockIOSStorage,
    );
  });

  group('AsyncStorageReader iOS Tests', () {
    test('getItem should return value from SQLite if available', () async {
      when(mockSQLiteStorage.getItemFromSQLite('testKey'))
          .thenAnswer((_) async => 'testValue');

      final result = await asyncStorageReader.getItem('testKey');

      expect(result, 'testValue');
      verify(mockSQLiteStorage.getItemFromSQLite('testKey')).called(1);
      verifyZeroInteractions(mockIOSStorage);
    });

    test('getItem should return value from iOS storage if SQLite returns null',
        () async {
      when(mockSQLiteStorage.getItemFromSQLite('testKey'))
          .thenAnswer((_) async => null);
      when(mockIOSStorage.getItemFromIOSAsyncStorage('testKey'))
          .thenAnswer((_) async => 'testValueFromIOS');

      final result = await asyncStorageReader.getItem('testKey');

      expect(result, 'testValueFromIOS');
      verify(mockSQLiteStorage.getItemFromSQLite('testKey')).called(1);
      verify(mockIOSStorage.getItemFromIOSAsyncStorage('testKey')).called(1);
    });

    test('removeItem should remove from iOS storage if SQLite removal fails',
        () async {
      when(mockSQLiteStorage.removeItemFromSQLite('testKey'))
          .thenAnswer((_) async => false);
      when(mockIOSStorage.removeItemFromIOSAsyncStorage('testKey'))
          .thenAnswer((_) async => true);

      final result = await asyncStorageReader.removeItem('testKey');

      expect(result, true);
      verify(mockSQLiteStorage.removeItemFromSQLite('testKey')).called(1);
      verify(mockIOSStorage.removeItemFromIOSAsyncStorage('testKey')).called(1);
    });

    test('clear should return success from iOS storage if SQLite clear fails',
        () async {
      when(mockSQLiteStorage.clearSQLite()).thenAnswer((_) async => false);
      when(mockIOSStorage.clearIOSAsyncStorage()).thenAnswer((_) async => true);

      final result = await asyncStorageReader.clear();

      expect(result, true);
      verify(mockSQLiteStorage.clearSQLite()).called(1);
      verify(mockIOSStorage.clearIOSAsyncStorage()).called(1);
    });
  });
}
