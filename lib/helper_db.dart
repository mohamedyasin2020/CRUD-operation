import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class Helperdb {
  static const databaseName = "StudentDetails";
  static const databaseVersion = 6;
  static const StudentDetailsTable = "StudentTable";
  static const Id = "StudentId";
  static const Name = "StudentName";
  static const Mobile = "StudentMobile";
  static const Email = "StudentEmail";

  late Database _db;

  Future<void> initialization() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, databaseName);

    _db = await openDatabase(
      path,
      version: databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database database, int version) async {
    await database.execute('''
      CREATE TABLE $StudentDetailsTable(
      $Id INTEGER PRIMARY KEY,
      $Mobile TEXT,
      $Name TEXT,
      $Email TEXT
      )
   ''');
  }

  Future<void> _onUpgrade(
      Database database, int oldVersion, int newVersion) async {
    await database.execute("drop table $StudentDetailsTable");
    _onCreate(database, newVersion);
  }

  Future<int> insertstudentdeatils(Map<String, dynamic> row) async {

    return await _db.insert(StudentDetailsTable, row);
  }
  Future<List<Map<String,dynamic>>> getStudentRecord() async{
    print("-------------------->getsudentRecord");
    return await _db.query(StudentDetailsTable);
  }
  Future<int>updatestudentdetails(Map<String, dynamic> row)async{
    int id=row[Id];
    return await _db.update(
    StudentDetailsTable,
        row,
        where:"$Id=?",
        whereArgs:[id],
    );
  }
 Future<int>delectstudentdetails(int id)async{
    return await _db.delete(
      StudentDetailsTable,
      where: "$Id=?",
      whereArgs: [id],
    );

 }


}




