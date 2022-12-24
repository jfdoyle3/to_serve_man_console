import 'package:mongo_dart/mongo_dart.dart';
import 'dart:io' show Platform;

import '../Models/ingredient.dart';
import '../Models/recipe.dart';

String host = Platform.environment['MONGO_DART_DRIVER_HOST'] ?? '127.0.0.1';
String port = Platform.environment['MONGO_DART_DRIVER_PORT'] ?? '27017';

void main() async {
  var db = Db('mongodb://$host:$port/Cookbook');
  // Example url for Atlas connection
  /* var db = Db('mongodb://<atlas-user>:<atlas-password>@'
      'cluster0-shard-00-02.xtest.mongodb.net:27017,'
      'cluster0-shard-00-01.xtest.mongodb.net:27017,'
      'cluster0-shard-00-00.xtest.mongodb.net:27017/'
      'mongo_dart-blog?authSource=admin&compressors=disabled'
      '&gssapiServiceName=mongodb&replicaSet=atlas-stcn2i-shard-0'
      '&ssl=true'); */

  Recipe cake = Recipe('Chocolate Cake', [
    Ingredient('egg', 'large',1,'-'),
    Ingredient('flour', 'AP', 1,'cups'),
  ], [
    '1. mix ingredients',
    '2. put batter in pan'
  ]);

  Map recipeMap = <String, Map>{};

  await db.open();
  await db.drop();
  print('====================================================================');
  print('>> Adding Recipe');
  var collection = db.collection('recipe');
  await collection.insertOne(
    {
      'name': cake.recipeName,
      'ingredients': cake.ingredients[0].name,
      'steps': cake.steps[0]
    });


  await db.close();
}