import 'package:db_project/helper_db.dart';
import 'package:db_project/student_form_screen.dart';
import 'package:db_project/student_model.dart';
import 'package:db_project/update_studen_form.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<Studentdetailsmodel> _Studentdetailslist = <Studentdetailsmodel>[];

  @override
  void initState() {
    super.initState();
    print("------>initState");
    getAllStudentdetails();
  }

  getAllStudentdetails() async {
    print('---------->getAllStudentdetails');

    var studentDetialRecords = await databasehelper.getStudentRecord();

    studentDetialRecords.forEach((row) {
      setState(() {
        print(row[Helperdb.Id]);
        print(row[Helperdb.Name]);
        print(row[Helperdb.Mobile]);
        print(row[Helperdb.Email]);

        var studentsModel = Studentdetailsmodel(
          row[Helperdb.Id],
          row[Helperdb.Name],
          row[Helperdb.Mobile],
          row[Helperdb.Email],
        );

        _Studentdetailslist.add(studentsModel);
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.cyan,
          title: const Text(
            "Student Form Screen",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: Container(
          child: ListView.builder(
              itemCount: _Studentdetailslist.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                    onTap: () {
                      print('------->List View Clicked');
                      print(_Studentdetailslist[index].id);
                      print(_Studentdetailslist[index].StudentName);
                      print(_Studentdetailslist[index].StudentNo);
                      print(_Studentdetailslist[index].StudentEmail);

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Updatestudentform(),
                          settings: RouteSettings(
                            arguments: _Studentdetailslist[index],
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Container(
                        height: 70,
                          width:50,
                          color: Colors.cyan,
                          child: Center(
                              child: Text(_Studentdetailslist[index].StudentName +"\n"+
                                  _Studentdetailslist[index].StudentNo+"\n"+
                              _Studentdetailslist[index].StudentEmail))),
                    ));
              }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print("Floating action button is pressed");
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => StudentFormScreen()));
          },
          child: Icon(Icons.add),
        ));
  }
}
