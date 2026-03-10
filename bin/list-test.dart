import 'package:learning_redis/redis_conn_factory.dart';

void main(List<String> arguments) async {
  final command = await connectRedis(host: 'localhost', port: 6379);

  // list
  await command.send_object(['DEL', 'mylist']);

  await command.send_object(['RPUSH', 'mylist', 'first']);
  await command.send_object(['RPUSH', 'mylist', 'second', 'third']);
  print(await command.send_object(['LRANGE', 'mylist', 0, -1]));

  await command.send_object(['LPUSH', 'mylist', 'zero']);
  print(await command.send_object(['LRANGE', 'mylist', 0, -1]));

  await command.send_object(['RPOP', 'mylist']);
  print(await command.send_object(['LRANGE', 'mylist', 0, -1]));

  await command.send_object(['LPOP', 'mylist']);
  print(await command.send_object(['LRANGE', 'mylist', 0, -1]));

  // queue
  await command.send_object(['DEL', 'task_queue']);

  await command.send_object(['RPUSH', 'task_queue', 'task1', 'task2', 'task3']);
  print(await command.send_object(['LRANGE', 'task_queue', 0, -1]));

  print(await command.send_object(['LPOP', 'task_queue']));
  print(await command.send_object(['LPOP', 'task_queue']));
  print(await command.send_object(['LRANGE', 'task_queue', 0, -1]));

  // stack
  await command.send_object(['DEL', 'task_stack']);

  await command.send_object(['LPUSH', 'task_stack', 'task1', 'task2', 'task3']);
  print(await command.send_object(['LRANGE', 'task_stack', 0, -1]));

  print(await command.send_object(['RPOP', 'task_stack']));
  print(await command.send_object(['RPOP', 'task_stack']));
  print(await command.send_object(['RPOP', 'task_stack']));
  print(await command.send_object(['RPOP', 'task_stack']));
  print(await command.send_object(['LRANGE', 'task_stack', 0, -1]));

  // blocking pop
  await command.send_object(['DEL', 'async_queue']);

  Future.delayed(Duration(seconds: 2), () {
    print('push data...');
    command.send_object(['RPUSH', 'async_queue', 'delayed_task']);
  });

  // Redis의 Blocking 명령어는 연결을 점유한다.
  final newCommand = await connectRedis(host: 'localhost', port: 6379);
  await newCommand
      .send_object(['BLPOP', 'async_queue', 5])
      .then(
        (value) {
          print(value.runtimeType);
          print(value);
          if (value is List && !value.isOnlyNulls) {
            print('key: ${value[0]}, value: ${value[1]}');
          } else {
            print('No data');
          }
        },
        onError: (_, _) {
          print('Error occurred.');
        },
      );
}

extension ListNullChecker on List {
  bool get isOnlyNulls {
    return isNotEmpty ? every((element) => element == null) : true;
  }
}
