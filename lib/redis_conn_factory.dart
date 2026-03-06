import 'package:redis/redis.dart';

Future<Command> connectRedis({String host = 'localhost', int port = 6379}) async {
  final conn = RedisConnection();
  print('Redis 연결 시도: $host:$port');

  try {
    final command = await conn.connect(host, port);
    print('Redis 연결 성공!');
    return command;
  } catch (e) {
    print('Redis 연결 실패: $e');
    rethrow;
  }
}

Future<void> disconnectRedis(RedisConnection conn) async {
  try {
    await conn.close();
    print('Redis 연결 종료됨');
  } catch (e) {
    print('Redis 연결 종료 중 오류: $e');
    rethrow;
  }
}

Future<void> disconnectRedisCommand(Command command) async {
  try {
    await command.get_connection().close();
    print('Redis 연결 종료됨');
  } catch (e) {
    print('Redis 연결 종료 중 오류: $e');
    rethrow;
  }
}