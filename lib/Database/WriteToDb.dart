import 'package:mongo_dart/mongo_dart.dart';
import 'dart:io' show Platform;

import '../Models/ingredient.dart';
import '../Models/recipe.dart';
import '../Models/step.dart';

String host = Platform.environment['MONGO_DART_DRIVER_HOST'] ?? '127.0.0.1';
String port = Platform.environment['MONGO_DART_DRIVER_PORT'] ?? '27017';


// Create / Write one recipe to the database.
void main() async {
  Db db = Db('mongodb://$host:$port/Cookbook');
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
    Step('1. mix ingredients'),
    Step('2. put batter in pan')
  ]);
  Recipe pie = Recipe('Apple Pie', [
    Ingredient('apple','Delicious' ,10,'-'),
    Ingredient('flour','AP', 5, 'cups'),
    Ingredient('egg','Large', 1,'-')
  ], [
    Step('mix ingredients'),
    Step('put apples and batter in pie plate')
  ]);
  // Map recipeMap = <String, Map>{};

  await db.open();
  await db.drop();
  print('====================================================================');
  print('>> Adding Recipe');
  DbCollection collection = db.collection('recipe');
  await collection.insert(
    {
      'name': cake.recipeName,
      //iterate - list - map
      'ingredients': [cake.ingredients[1].name,
                      cake.ingredients[1].type,
                      cake.ingredients[1].amount,
                      cake.ingredients[1].measurement
                      ],
      // iterate - list  - map
      'steps': [cake.steps[0],
                cake.steps[1]
               ]
    });

  await db.close();
  print('>> Recipe Added/Updated');
}