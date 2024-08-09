import 'package:finishflutter_app/layout/cubit/cubit_screen.dart';
import 'package:finishflutter_app/layout/cubit/states.dart';
import 'package:finishflutter_app/shared/componants/componants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';


class HomeLayout extends StatelessWidget {


  var scaffoldKey=GlobalKey<ScaffoldState>();
  var titleControl=TextEditingController();
  var timeControl=TextEditingController();
  var dateControl=TextEditingController();
  var formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return BlocProvider<CubitApp>(
      create: (context) => CubitApp()..createDataBase(context),
      child: BlocConsumer<CubitApp,AppStates>(
        builder: (context, state) {
          CubitApp cubit= CubitApp.getObject(context);
          return Form(
          key: formKey,
          child: Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.appBar[cubit.currenIndex]),
            ),
            body: cubit.screen[cubit.currenIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: ()  {

                if(cubit.isFloatingActionBootom)
                {
                  if(formKey.currentState!.validate())
                  {
                    cubit.insertDataBase(titleControl.text,timeControl.text,dateControl.text,context);
                    cubit.changeFloatingButton(false,Icons.edit);

                  }
                }
                else{
                  scaffoldKey.currentState!.showBottomSheet((context) {
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            defaultTextFormFeild(
                              control: titleControl,
                              labletext: "Task Title",
                              prfexicon:Icons.title,
                              validator: (value) {
                                if(value!.isEmpty)
                                {
                                  return "title must not be empty";
                                }
                              },

                            ),
                            SizedBox(height: 20,),
                            defaultTextFormFeild(
                              control: timeControl,
                              labletext: "Task Time",
                              prfexicon:Icons.watch_later,
                              validator: (value) {
                                if(value!.isEmpty)
                                {
                                  return "time must not be empty";
                                }
                              },
                              keyboard: TextInputType.datetime,
                              onTap: () {
                                showTimePicker(context: context, initialTime: TimeOfDay.now()).then((value) {
                                  timeControl.text=value!.format(context);
                                });
                              },
                            ),
                            SizedBox(height: 20,),
                            defaultTextFormFeild(
                              control: dateControl,
                              labletext: "Task Date",
                              prfexicon:Icons.date_range,
                              validator: (value) {
                                if(value!.isEmpty)
                                {
                                  return "date must not be empty";
                                }
                              },
                              keyboard: TextInputType.datetime,
                              onTap: () {
                                showDatePicker(context: context , initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate:DateTime(2026)).then((value) {
                                  dateControl.text= DateFormat.yMMMd().format(DateTime.now());
                                });

                              },
                            )
                          ],
                        ),
                      ),
                    );
                  }).closed.then((value) {
                   cubit.changeFloatingButton(false,Icons.edit);

                  });
                  cubit.changeFloatingButton(true,Icons.add);
                }

              },
              child: Icon(cubit.icon),
              elevation: 10,
            ),
            bottomNavigationBar: BottomNavigationBar(
              onTap: (value) {
                cubit.changeCurrentIndex(value);
              },
              currentIndex: cubit.currenIndex,
              items: [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: "Tasks"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: "Done"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: "Archived"),
              ],
            ),

          ),
        );
        },
        listener: (context, state) {},

      ),
    );
  }


}

