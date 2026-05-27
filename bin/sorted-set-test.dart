import 'package:learning_redis/redis_conn_factory.dart';

void main(List<String> arguments) async {
  final command = await connectRedis(host: 'localhost', port: 6379);
  await command.send_object(['FLUSHALL']);

  await command.send_object(['ZADD', 'leaderboard', 100, 'Alice']);
  await command.send_object(['ZADD', 'leaderboard', 95, 'Bob', 150, 'Charlie', 85, 'Dave']);
  print(await command.send_object(['ZRANGE', 'leaderboard', 0, -1, 'WITHSCORES']));

  // NX: 존재하지 않을 때만 추가
  print(await command.send_object(['ZADD', 'leaderboard', 'NX', 200, 'Eve']));
  print(await command.send_object(['ZADD', 'leaderboard', 'NX', 999, 'Alice']));

  // XX: 존재할 때만 추가
  print(await command.send_object(['ZADD', 'leaderboard', 'XX', 150, 'Alice']));
  print(await command.send_object(['ZADD', 'leaderboard', 'XX', 300, 'Frank']));

  print(await command.send_object(['ZSCORE', 'leaderboard', 'Alice'])); // 150
  print(await command.send_object(['ZADD', 'leaderboard', 'GT', 180, 'Alice']));
  print(await command.send_object(['ZSCORE', 'leaderboard', 'Alice']));

  print(await command.send_object(['ZRANGE', 'leaderboard', 0, 2, 'WITHSCORES']));
  print(await command.send_object(['ZREVRANGE', 'leaderboard', 0, 2, 'WITHSCORES']));
  print(await command.send_object(['ZRANGE', 'leaderboard', 0, 2, 'REV', 'WITHSCORES']));

  print(await command.send_object(['ZRANK', 'leaderboard', 'Alice']));
  print(await command.send_object(['ZREVRANK', 'leaderboard', 'Alice']));

  print(await command.send_object(['ZINCRBY', 'leaderboard', 30, 'Bob']));
}
