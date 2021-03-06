import 'package:dota_app/infrastructure/http_cache_interface.dart';
import 'package:dota_app/infrastructure/result.dart';
import 'package:dota_app/infrastructure/sqlite_http_cache.dart';
import 'package:dota_app/infrastructure/time.dart';
import 'package:dota_app/services/database_service_interface.dart';
import 'package:dota_app/services/models/http_cache_record.dart';
import 'package:flutter_test/flutter_test.dart';

class MockDatabseService implements IDatabseService {
  HttpCacheRecord? fakeRecord;

  @override
  Future<Result<HttpCacheRecord>> get(String url) {
    return fakeRecord == null
        ? Future.value(Result.error())
        : Future.value(Result.success(fakeRecord));
  }

  @override
  void insert(HttpCacheRecord record) {}

  @override
  void update(HttpCacheRecord record) {}
}

void main() {
  test("Retrieves from cache when not expired", () async {
    var mockDbService = MockDatabseService();

    fakeTime = DateTime(2021, 1, 1, 12, 0, 0, 0, 0);
    mockDbService.fakeRecord = HttpCacheRecord(
        "anything", fakeTime!.subtract(Duration(minutes: 15)), "testData");

    IHttpCache cache = SqliteHttpCache(mockDbService);
    String? result =
        await cache.get("anything", (_) => Future.value("not correct"));

    expect(result, "testData");
  });

  test("Calls retrieval function when expired", () async {
    var mockDbService = MockDatabseService();

    fakeTime = DateTime(2021, 1, 1, 12, 0, 0, 0, 0);
    mockDbService.fakeRecord = HttpCacheRecord(
        "anything", fakeTime!.subtract(Duration(minutes: 75)), "testData");

    IHttpCache cache = SqliteHttpCache(mockDbService);
    String? result =
        await cache.get("anything", (_) => Future.value("correct"));

    expect(result, "correct");
  });

  test("Calls retrieval function if there is no record", () async {
    var mockDbService = MockDatabseService();

    IHttpCache cache = SqliteHttpCache(mockDbService);
    String? result =
        await cache.get("anything", (_) => Future.value("correct"));

    expect(result, "correct");
  });
}
