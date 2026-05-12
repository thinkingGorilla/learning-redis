import 'package:learning_redis/redis_conn_factory.dart';

void main(List<String> arguments) async {
  final command = await connectRedis(host: 'localhost', port: 6379);

  await command.send_object(['SADD', 'fruits', 'apple']);
  await command.send_object(['SADD', 'fruits', 'apple']);
  await command.send_object(['SADD', 'fruits', 'banana', 'orange']);

  print(await command.send_object(['SMEMBERS', 'fruits']));
  print(await command.send_object(['SISMEMBER', 'fruits', 'apple']));
  print(await command.send_object(['SISMEMBER', 'fruits', 'grape']));
  print(await command.send_object(['SCARD', 'fruits']));

  await command.send_object(['SREM', 'fruits', 'apple']);
  print(await command.send_object(['SMEMBERS', 'fruits']));

  await command.send_object(['SPOP', 'fruits']);
  print(await command.send_object(['SMEMBERS', 'fruits']));

  await command.send_object(['SADD',  'numbers', '1', '2', '3', '4', '5']);
  print(await command.send_object(['SRANDMEMBER', 'numbers', 2]));
  print(await command.send_object(['SRANDMEMBER', 'numbers', 3]));

  // 게시글 좋아요 시스템
  await command.send_object(['SADD',  'post:1:likes', 'user1', 'user2', 'user3']);
  print(await command.send_object(['SCARD', 'post:1:likes']));
  print(await command.send_object(['SISMEMBER', 'fruits', 'user2']));

  await command.send_object(['SADD', 'post:1:likes', 'user1']);
  await command.send_object(['SREM', 'post:1:likes', 'user2']);
  print(await command.send_object(['SMEMBERS', 'post:1:likes']));
}
