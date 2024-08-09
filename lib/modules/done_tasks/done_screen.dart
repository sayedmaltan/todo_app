import 'package:finishflutter_app/layout/cubit/cubit_screen.dart';
import 'package:finishflutter_app/layout/cubit/states.dart';
import 'package:finishflutter_app/shared/componants/componants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoneScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CubitApp cubit = CubitApp.getObject(context);
    return  BlocConsumer<CubitApp, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return cubit.doneTasks.length == 0
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
                  cubit.deleteRecord(cubit.doneTasks[index]["id"], context);
                },
                child: buildOneTask(cubit.doneTasks[index], context)),
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsetsDirectional.only(start: 20),
              child: Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey.shade300,
              ),
            ),
            itemCount: cubit.doneTasks.length);
      },
    );
  }
}
