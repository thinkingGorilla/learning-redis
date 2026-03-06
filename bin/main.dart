import 'package:learning_redis/redis_conn_factory.dart';

void main(List<String> arguments) async {
  final command = await connectRedis(host: 'localhost', port: 6379);

  await command.send_object(['SET', 'user:777:name', 'thinkingGorilla']);
  print(await command.get('user:777:name'));
  print(await command.send_object(['GET', 'user:100:name']));

  await command.send_object(['SET', 'user:777:name', 'gorillaThinking']);
  print(await command.get('user:777:name'));

  await command.send_object(['INCR', 'page:today:views']);
  await command.send_object(['INCR', 'page:today:views']);
  await command.send_object(['INCR', 'page:today:views']);
  print(await command.get('page:today:views'));

  await command.send_object(['INCRBY', 'page:today:views', 10]);
  print(await command.get('page:today:views'));

  await command.send_object(['DECRBY', 'page:today:views', 10]);
  print(await command.get('page:today:views'));

  await command.send_object([
    'MSET',
    'user:123:name',
    'user123',
    'user:456:name',
    'user456',
  ]);
  print(await command.send_object(['MGET', 'user:123:name', 'user:456:name']));

  await command.send_object(['SET', 'session:777', 'lock', 'EX', 3]);
  print(await command.get('session:777'));
  Future.delayed(Duration(milliseconds: 1500)).then((_) async {
    var ttl = await command.send_object(['PTTL', 'session:777']);
    print('Remaining TTL: ${ttl}sec');
  });
  Future.delayed(Duration(milliseconds: 1500)).then((_) async {
    var saved = await command.send_object(['SET', 'session:777', 'lock', 'NX', 'EX', 1]);
    print(saved);
  });
  Future.delayed(Duration(milliseconds: 3500)).then((_) async {
    var saved = await command.send_object(['SET', 'session:777', 'lock', 'NX', 'EX', 1]);
    print(saved);
  });
  await Future.delayed(Duration(seconds: 3));
  print(await command.get('session:777'));
}
