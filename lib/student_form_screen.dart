import 'package:db_project/helper_db.dart';
import 'package:db_project/home_screen.dart';
import 'package:db_project/main.dart';
import 'package:flutter/material.dart';

class StudentFormScreen extends StatefulWidget {
  const StudentFormScreen({super.key});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {

  //I want to accessing textformfeild we use controller(IDENTIFY)
  var _studentNameController = TextEditingController();
  var _studentMobileNoController = TextEditingController();
  var _studentEmailIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                      border:
                      const OutlineInputBorder(borderSide: BorderSide()),
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
                      print('--------------->Save Button Clicked');
                      _save();
                    },
                    child: const Text('Save'))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _save() async {
    print('--------------->Save Method');
    print('------------------>Student Name : ${_studentNameController.text}');
    print('------------------>Student Mobile No : ${_studentMobileNoController.text}');
    print('------------------>Student Email Id : ${_studentEmailIdController.text}');
    //Step 1 Complete

    Map<String, dynamic> row= {
      Helperdb.Name: _studentNameController.text,
      Helperdb.Mobile: _studentMobileNoController.text,
      Helperdb.Email: _studentEmailIdController.text,
    };

    //Insert
    final res = await databasehelper.insertstudentdeatils(row);
    debugPrint('----------------> Inserted Id : $res');
    //---------------------------Step 2

    if (res > 0) {
      _showSuccessfulSnackBar(context, "Saved");
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>Homescreen(),
      ));
    }
  } //-------->Ending Save method

  void _showSuccessfulSnackBar(BuildContext context, String toastmgs) {
    ScaffoldMessenger.of(context)
        .showSnackBar(new SnackBar(content: new Text(toastmgs)));
  }
}
