import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/cubit/cubit.dart';

Widget default_form({
  @required TextEditingController controller,
  @required TextInputType type,
  Function onSubmit,
  Function onChange,
  bool isPassword = false,
  @required Function validate,
  Function ontap,
  @required String label,
  @required IconData prefix,
  IconData suffix,
  bool isclickenable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: ontap,
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null ? Icon(suffix) : null,
        border: OutlineInputBorder(),
        enabled: isclickenable,
      ),
    );
Widget buildtaskitem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      onDismissed: (direction) {
        AppCubit.get(context).deletData(id: model['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.green,
              radius: 40,
              child: Text("${model['time']}"),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${model['title']}",
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "mhmd",
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${model['date']}",
                    style: TextStyle(fontFamily: "mhmd", color: Colors.grey),
                  )
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.check_box_rounded),
              onPressed: () {
                AppCubit.get(context)
                    .ubdateData(status: 'done', id: model['id']);
              },
              color: Colors.green,
            ),
            IconButton(
              icon: Icon(Icons.archive),
              onPressed: () {
                AppCubit.get(context)
                    .ubdateData(status: 'archive', id: model['id']);
              },
              color: Colors.grey,
            )
          ],
        ),
      ),
    );

Widget taskbuilder({
  @required List<Map> tasks,
}) =>
    ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) {
        return ListView.separated(
            itemBuilder: (context, index) =>
                buildtaskitem(tasks[index], context),
            separatorBuilder: (context, index) => Padding(
                  padding: const EdgeInsetsDirectional.only(start: 20.0),
                  child: Container(
                      width: double.infinity,
                      height: 1.0,
                      color: Colors.grey[300]),
                ),
            itemCount: tasks.length);
      },
      fallback: (context) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
                iconSize: 100.0,
                color: Colors.grey,
              ),
              Text(
                "No Tasks Yet , Please Add Some Tasks",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
              )
            ],
          ),
        );
      },
    );
