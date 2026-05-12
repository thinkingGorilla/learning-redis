import 'package:learning_redis/redis_conn_factory.dart';

void main(List<String> arguments) async {
  final command = await connectRedis(host: 'localhost', port: 6379);

  await command.send_object(['HSET', 'user:1000', 'name', 'Alice']);
  await command.send_object(['HSET', 'user:1000', 'email', 'alice@example.com', 'age', 25]);

  print(await command.send_object(['HGET', 'user:1000', 'name']));
  print(await command.send_object(['HGET', 'user:1000', 'age']));

  final [name2, email, age2] = await command.send_object(['HMGET', 'user:1000', 'name2', 'email', 'age']);
  print('$name2, $email, $age2');

  print(await command.send_object(['HGETALL', 'user:1000']));
  print(await command.send_object(['HEXISTS', 'user:1000', 'phone']));
  print(await command.send_object(['HKEYS', 'user:1000']));
  print(await command.send_object(['HVALS', 'user:1000']));
}
