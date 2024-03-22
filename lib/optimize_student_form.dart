import 'package:db_project/helper_db.dart';
import 'package:db_project/home_screen.dart';
import 'package:db_project/main.dart';
import 'package:db_project/student_model.dart';
import 'package:flutter/material.dart';

class Optimizedstudentform extends StatefulWidget {
  const Optimizedstudentform({super.key});

  @override
  State<Optimizedstudentform> createState() => _OptimizedStudentFormState();
}

class _OptimizedStudentFormState extends State<Optimizedstudentform> {

  //I want to accessing textformfeild we use controller(IDENTIFY)
  var _studentNameController = TextEditingController();
  var _studentMobileNoController = TextEditingController();
  var _studentEmailIdController = TextEditingController();

  bool firstTimeFlag = false;
  var selectedRecordId = 0;

  //Dynamic Changing Button
  String buttonText ="Save";

  @override
  Widget build(BuildContext context) {
    if(firstTimeFlag == false){
      print('--------------->Once Execute');
      firstTimeFlag = true;

      //Recieving Data
      final studentdetails = ModalRoute.of(context)!.settings.arguments;
      if(studentdetails == null){
        print('--------------->FAB : Insert/Save');
      }else{
        print('--------------->ListView : Recieved Data : Delete/Save');
        studentdetails as Studentdetailsmodel;
        print('--------------->Recieving Data');
        print(studentdetails.id);
        print(studentdetails.StudentName);
        print(studentdetails.StudentNo);
        print(studentdetails.StudentEmail);

        selectedRecordId = studentdetails.id!;
        buttonText = "Update";
        _studentNameController.text = studentdetails.StudentName;
        _studentMobileNoController.text = studentdetails.StudentNo;
        _studentEmailIdController.text = studentdetails.StudentEmail;
      }
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 10,
        centerTitle: true,
        title: const Text(
          'Student Details Form',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        actions: selectedRecordId == 0
            ? null : [
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
                    if(selectedRecordId == 0){
                      print('--------------->Save Method Clicked');
                      _save();
                    }else{
                      print('--------------->Update Method Clicked');
                      _update();
                    }
                  },
                  child: Text(buttonText),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _deleteDialogshow(BuildContext context) {
    return showDialog(
        context: context,
        builder: (param){
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
                    print('--------------->Delete Button Clicked');
                    _delete();
                  },
                  child: Text('Delete')
              )
            ],
            title: Text('Are You Sure You Want To Delete This?'),
          );
        }
    );
  }

  void _save() async {
    print('--------------->Save Method');
    print('------------------>Student Name : ${_studentNameController.text}');
    print('------------------>Student Mobile No : ${_studentMobileNoController.text}');
    print('------------------>Student Email Id : ${_studentEmailIdController.text}');
    //-----------------------------Step 1 Complete--------------------------------------

    //Store Data in Table Using Map
    Map<String, dynamic> row = {
      Helperdb.Name: _studentNameController.text,
      Helperdb.Mobile: _studentMobileNoController.text,
      Helperdb.Email: _studentEmailIdController.text,
    };

    //Insert
    final res = await databasehelper.insertstudentdeatils(row);
    debugPrint('----------------> Inserted Id : $res');
    //-------------------------------Step 2 Complete------------------------------------

    //This Conditions if the record is avaiable If condition is true else false
    if (res > 0) {
      _showSuccessSnackBar(context, "Saved");//Method Call
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>Homescreen(),
      ));
    }
  }

  void _update() async {
    print('--------------->Update Method');
    print('--------------->Student Name :${_studentNameController.text}');
    print('--------------->Student Mobile No :${_studentMobileNoController.text}');
    print('--------------->Student EmailId :${_studentEmailIdController.text}');
    print('--------------->Selected Id :$selectedRecordId');

    //Store Data in Table Using Map
    Map<String, dynamic> row = {
      Helperdb.Id: selectedRecordId,
      Helperdb.Name: _studentNameController.text,
      Helperdb.Mobile: _studentMobileNoController.text,
      Helperdb.Email: _studentEmailIdController.text,
    };

    final result = await databasehelper.updatestudentdetails(row);
    debugPrint('--------------->Update Row Id :$result');

    //This Conditions if the record is avaiable If condition is true else false
    if (result >0) {
      _showSuccessSnackBar(context, 'Updated');//Method Call
      setState(() {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) =>Homescreen()));
      });
    }
  }

  void _delete() async{
    print('--------------->Delete Method');
    print('--------------->Selected Id :$selectedRecordId');

    final res = await databasehelper.delectstudentdetails(selectedRecordId);

    if(res>0){
      _showSuccessSnackBar(context, "Deleted");
      setState(() {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>Homescreen(),));
      });
    }
  }

  //Show Mgs in StudentListScreen
  void _showSuccessSnackBar(BuildContext context, String mgs) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mgs)));
  }
}
