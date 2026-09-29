import 'dart:async';

import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'message_dao.dart';
import 'message_row.dart';

part 'chat_database.g.dart';

@Database(version: 1, entities: [MessageRow])
abstract class ChatDatabase extends FloorDatabase {
  MessageDao get messageDao;
}
