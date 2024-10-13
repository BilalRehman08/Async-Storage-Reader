import 'package:async_storage_reader/src/platform_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:async_storage_reader/async_storage_reader.dart';
import 'package:async_storage_reader/src/ios_storage.dart';
import 'package:async_storage_reader/src/sqlite_storage.dart';

// Update this line
@GenerateMocks([], customMocks: [
  MockSpec<SQLiteStorage>(as: #MockSQLiteStorage),
  MockSpec<IOSStorage>(as: #MockIOSStorage),
  MockSpec<PlatformChecker>(as: #MockPlatformChecker),
])
import 'async_storage_reader_test.mocks.dart';

void main() {
  late AsyncStorageReader reader;
  late MockSQLiteStorage mockSqliteStorage;
  late MockIOSStorage mockIosStorage;
  late MockPlatformChecker mockPlatformChecker;

  setUp(() {
    mockSqliteStorage = MockSQLiteStorage();
    mockIosStorage = MockIOSStorage();
    mockPlatformChecker = MockPlatformChecker();
    reader = AsyncStorageReader(
      sqliteStorage: mockSqliteStorage,
      iosStorage: mockIosStorage,
      platformChecker: mockPlatformChecker,
    );
  });

  group('AsyncStorageReader', () {
    test('getItem on Android', () async {
      when(mockPlatformChecker.isAndroid).thenReturn(true);
      when(mockPlatformChecker.isIOS).thenReturn(false);
      when(mockSqliteStorage.getItemFromSQLite(any))
          .thenAnswer((_) async => 'testValue');

      final result = await reader.getItem('testKey');
      expect(result, equals('testValue'));
    });

    test('getItem on iOS', () async {
      when(mockPlatformChecker.isAndroid).thenReturn(false);
      when(mockPlatformChecker.isIOS).thenReturn(true);
      when(mockIosStorage.getItemFromIOSAsyncStorage(any))
          .thenAnswer((_) async => 'testValue');

      final result = await reader.getItem('testKey');
      expect(result, equals('testValue'));
    });

    test('getAllItems on Android', () async {
      when(mockPlatformChecker.isAndroid).thenReturn(true);
      when(mockPlatformChecker.isIOS).thenReturn(false);
      when(mockSqliteStorage.getAllItemsFromSQLite())
          .thenAnswer((_) async => {'key1': 'value1', 'key2': 'value2'});

      final result = await reader.getAllItems();
      expect(result, equals({'key1': 'value1', 'key2': 'value2'}));
    });

    test('getAllItems on iOS', () async {
      when(mockPlatformChecker.isAndroid).thenReturn(false);
      when(mockPlatformChecker.isIOS).thenReturn(true);
      when(mockIosStorage.getAllItemsFromIOSAsyncStorage())
          .thenAnswer((_) async => {'key1': 'value1', 'key2': 'value2'});

      final result = await reader.getAllItems();
      expect(result, equals({'key1': 'value1', 'key2': 'value2'}));
    });

    test('removeItem on Android', () async {
      when(mockPlatformChecker.isAndroid).thenReturn(true);
      when(mockPlatformChecker.isIOS).thenReturn(false);
      when(mockSqliteStorage.removeItemFromSQLite(any))
          .thenAnswer((_) async => true);

      final result = await reader.removeItem('testKey');
      expect(result, isTrue);
    });

    test('removeItem on iOS', () async {
      when(mockPlatformChecker.isAndroid).thenReturn(false);
      when(mockPlatformChecker.isIOS).thenReturn(true);
      when(mockIosStorage.removeItemFromIOSAsyncStorage(any))
          .thenAnswer((_) async => true);

      final result = await reader.removeItem('testKey');
      expect(result, isTrue);
    });

    test('clear on Android', () async {
      when(mockPlatformChecker.isAndroid).thenReturn(true);
      when(mockPlatformChecker.isIOS).thenReturn(false);
      when(mockSqliteStorage.clearSQLite()).thenAnswer((_) async => true);

      final result = await reader.clear();
      expect(result, isTrue);
    });

    test('clear on iOS', () async {
      when(mockPlatformChecker.isAndroid).thenReturn(false);
      when(mockPlatformChecker.isIOS).thenReturn(true);
      when(mockIosStorage.clearIOSAsyncStorage()).thenAnswer((_) async => true);

      final result = await reader.clear();
      expect(result, isTrue);
    });

    test('unsupported platform', () async {
      when(mockPlatformChecker.isAndroid).thenReturn(false);
      when(mockPlatformChecker.isIOS).thenReturn(false);

      final result = await reader.getItem('testKey');
      expect(result, equals('Platform not supported'));

      final allItems = await reader.getAllItems();
      expect(allItems, isEmpty);

      final removeResult = await reader.removeItem('testKey');
      expect(removeResult, isFalse);

      final clearResult = await reader.clear();
      expect(clearResult, isFalse);
    });
  });
}
