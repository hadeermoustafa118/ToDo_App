import 'package:flutter/material.dart';
import 'package:conditional_builder_rec/conditional_builder_rec.dart';

import '../shared/cubit.dart';

Widget text({
  required TextEditingController controller,
  required TextInputType type,
  required FormFieldValidator<String> validate,
  VoidCallback? suffixPressed,
  VoidCallback? onTap,
  required String label,
  required IconData prefix,
  bool isPassword = false,
  IconData? suffix,
  bool isClickable = true,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      validator: validate,
      onTap: onTap,
      enabled: isClickable,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(suffix),
                onPressed: suffixPressed,
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );

Widget buildItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35.0,
              child: Text('${model['time']}'),
            ),
            const SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${model['title']}',
                    style:
                        const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Text(
                    '${model['date']}',
                    style:const  TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20.0,
            ),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'Done', id: model['id']);
                },
                color: Colors.amber,
                icon: const Icon(Icons.check_box)),
            IconButton(
                onPressed: () {
                  AppCubit.get(context)
                      .updateData(status: 'Archived', id: model['id']);
                },
                color: Colors.black45,
                icon: const Icon(Icons.archive)),
          ],
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
    );

Widget tasksBuilder({required List<Map> tasks}) => ConditionalBuilderRec(
      condition: tasks.isNotEmpty,
      builder: (context) => ListView.separated(
          itemBuilder: (context, index) => buildItem(tasks[index], context),
          separatorBuilder: (context, index) => Container(
                width: double.infinity,
                height: 1.0,
                color: Colors.grey[300],
              ),
          itemCount: tasks.length),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.menu,
              size: 50.0,
              color: Colors.grey,
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'No Tasks Yet, add some to do them!',
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black45),
            ),
          ],
        ),
      ),
    );
