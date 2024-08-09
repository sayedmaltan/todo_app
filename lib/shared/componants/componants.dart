
import 'package:finishflutter_app/layout/cubit/cubit_screen.dart';
import 'package:finishflutter_app/layout/cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Widget defaultTextFormFeild({
  required TextEditingController control,
  required String labletext,
  required IconData prfexicon,
  IconData? sufxexicon,
  TextInputType? keyboard,
  required String? Function(String? value) validator,
  bool isPassword = false,
  void Function()? SwitchEyeIcon,
  Function()? onTap,
}) =>
    TextFormField(
      validator: validator,
      controller: control,
      decoration: InputDecoration(
        labelText: labletext,
        border: OutlineInputBorder(),
        prefixIcon: Icon(
          prfexicon,
        ),
        suffixIcon: IconButton(
          icon: Icon(sufxexicon),
          onPressed: SwitchEyeIcon,
        ),
      ),
      keyboardType: keyboard,
      obscureText: isPassword,
      onTap: onTap,
    );


Widget buildOneTask (Map record,context)=> Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        CircleAvatar(
          radius: 45,
          child: Text(
            "${record["time"]}",
            style: TextStyle(
                fontSize: 20
            ),

          ),

        ),
        SizedBox(width: 20,),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${record["title"]}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25
              ),
            ),
            SizedBox(height: 5,),
            Text("${record["date"]}",
              style: TextStyle(
                fontSize: 15,
                  color: Colors.grey
              ),
            ),
          ],
        ),
        SizedBox(width: 20,),
        Expanded(
          child: IconButton(
              onPressed: () {
                CubitApp.getObject(context).updateDataBase("done", record['id'],context);
              },
              icon: Icon(Icons.check_box_rounded),
            color: Colors.green,
          ),
        ),
        IconButton(
            onPressed: () {
              CubitApp.getObject(context).updateDataBase("archived",record['id'],context);
            },
            icon: Icon(Icons.archive_outlined,),
          color: Colors.black54,

        )
      ],
    ),
  );


Widget Screen(task)
=> BlocConsumer<CubitApp, AppStates>(
    listener: (context, state) {},
    builder: (context, state) {
      CubitApp cubit=CubitApp.getObject(context);
      return task.length == 0
          ? Center(
            child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
            Icon(Icons.menu),
            Text("add some "),
        ],
      ),
          )
          : ListView.separated(
          itemBuilder: (context, index) => Dismissible(
              key: Key("value"),
              onDismissed: (direction) {
                cubit.deleteRecord(task[index]["id"], context);
              },
              child: buildOneTask(task[index], context)),
          separatorBuilder: (context, index) => Padding(
            padding: const EdgeInsetsDirectional.only(start: 20),
            child: Container(
              width: double.infinity,
              height: 1,
              color: Colors.grey.shade300,
            ),
          ),
          itemCount: task.length);
    },
  );
