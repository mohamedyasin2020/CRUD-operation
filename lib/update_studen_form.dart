import 'package:db_project/helper_db.dart';
import 'package:db_project/home_screen.dart';
import 'package:db_project/main.dart';
import 'package:db_project/student_model.dart';
import 'package:flutter/material.dart';


class Updatestudentform extends StatefulWidget {
  const Updatestudentform({super.key});

  @override
  State<Updatestudentform> createState() => _UpdateStudentFormState();
}

class _UpdateStudentFormState extends State<Updatestudentform> {
  //I want to accessing textformfeild we use controller(IDENTIFY)
  var _studentNameController = TextEditingController();
  var _studentMobileNoController = TextEditingController();
  var _studentEmailIdController = TextEditingController();

  bool firstTimeFlag = false;
  var selectRecordId = 0;

  @override
  Widget build(BuildContext context) {
    if (firstTimeFlag == false) {
      print('--------------->Once Execute');

      firstTimeFlag = true;

      //Recieving Data
      final studentdetail =
      ModalRoute.of(context)!.settings.arguments as Studentdetailsmodel;

      print('--------------->Receiving Data');
      print(studentdetail.id);
      print(studentdetail.StudentName);
      print(studentdetail. StudentNo);
      print(studentdetail.StudentEmail);

      selectRecordId = studentdetail.id!; //Handle Null
      _studentNameController.text = studentdetail.StudentName;
      _studentMobileNoController.text = studentdetail.StudentNo;
      _studentEmailIdController.text = studentdetail.StudentEmail;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 10,
        centerTitle: true,
        title: const Text(
          'Student Form',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        actions: [
          PopupMenuButton(itemBuilder: (context) => [
            PopupMenuItem(value: 1,child: Text('Delete'))
          ],
            elevation: 2,
            onSelected: (value){
              if(value==1){
                print('Clicked Delete Button');
                _deleteDialogshow(context);
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _studentNameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide()),
                      labelText: 'Student Name',
                      hintText: 'Enter Student Name'),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _studentMobileNoController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide()),
                      labelText: 'Student Mobile No',
                      hintText: 'Enter Student Mobile No'),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: _studentEmailIdController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(borderSide: BorderSide()),
                      labelText: 'Student Email Id',
                      hintText: 'Enter Student Email Id'),
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      print('--------------->Update Button Clicked');
                      _update();
                    },
                    child: const Text('Update'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _update() async {
    print('--------------->Update Method');
    print('--------------->Student Name :${_studentNameController.text}');
    print('--------------->Student Mobile No :${_studentMobileNoController.text}');
    print('--------------->Student EmailId :${_studentEmailIdController.text}');
    print('--------------->Selected Id :$selectRecordId');

    //Store Data in Table Using Map
    Map<String, dynamic> row = {
      Helperdb.Id: selectRecordId,
      Helperdb.Name:_studentNameController.text,
      Helperdb.Mobile: _studentMobileNoController.text,
      Helperdb.Email: _studentEmailIdController.text,
    };



    final result = await databasehelper.updatestudentdetails(row);
    debugPrint('--------------->Update Row Id :$result');

    //This Conditions if the record is avaiable If condition is true else false
    if (result > 0) {
      _showSuccessSnackBar(context, 'Updated');//Method Call
      setState(() {
       Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Homescreen()));
      });
    }
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  _deleteDialogshow(BuildContext context) {
    return showDialog(
        context: context,
        builder:(param){
          return AlertDialog(
            actions: [
              ElevatedButton(
                  onPressed: (){
                    print('--------------->Cancel Button Clicked');
                    Navigator.pop(context);
                  },
                  child: Text('Cancel')
              ),
              ElevatedButton(
                  onPressed: (){
                    print('--------------->Delete Method Clicked');
                    _delete();
                  },
                  child: Text('Delete')
              ),
            ],
            title: Text('Are You Sure You Want To Delete This?'),
          );
        }
    );
  }

  //Delete Method
  void _delete() async{
    print('--------------->Delete Method');
    print('--------------->Selected Id :$selectRecordId');

    final res = await databasehelper.delectstudentdetails(selectRecordId);
    debugPrint('---------------->Deleted Row Id :$res');

    if(res>0){
      _showSuccessSnackBar(context, "Deleted");
      setState(() {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Homescreen(),));
      });
    }
  }
}
