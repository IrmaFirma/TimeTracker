import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/Authentication/Models/Record.dart';
import 'package:time_tracker/Authentication/SignIn/SignInPage.dart';
import 'package:time_tracker/Components/PlatformAwareDialog.dart';
import 'package:time_tracker/Services/Database.dart';
import 'package:time_tracker/Services/auth.dart';
import 'package:time_tracker/home/RecordListTile.dart';
import 'package:time_tracker/home/Records/EditRecordPage.dart';


class RecordsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (context) => SignInPage.create(context)));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await PlatformAwareDialog(
      title: 'Logout',
      content: 'Are you sure that you want to Logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout',
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1F232E),
      appBar: AppBar(
        title: Text('Records',  style: TextStyle(color: Color(0xFFC6D5E9))),
        backgroundColor: Color(0xFF2A3040),
        leading: Container(),
        centerTitle: true,
        actions: [
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFFC6D5E9),
              ),
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body: buildContent(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => EditRecordPage.show(context),
        backgroundColor: Color(0xFF2795C4),
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    final database = Provider.of<Database>(context);
    return StreamBuilder<List<Record>>(
      stream: database.recordsStream(),
      builder: (context, snapshot){
        if(snapshot.hasData){
          final records = snapshot.data;
          final children = records.map((record) => RecordListTile(record: record, onTap: () {EditRecordPage.show(context, record: record);},)).toList();
          return ListView(
            children: children,
          );
        }
        if(snapshot.hasError){
          return Center(child: Text('Some error ocurred'));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}



