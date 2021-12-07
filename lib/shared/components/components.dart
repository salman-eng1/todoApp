

import 'package:flutter/material.dart';
import 'package:todo_app/layout/todo_app/cubit/cubit.dart';


Widget defaultTextButton({
  required String text,
  required Function() onPressed,
})=>TextButton(
  onPressed: onPressed,
  child: Text(text.toUpperCase()),);

//suffix icon button
Widget suffixIconBtn ({
  IconData? suffix,
})=>IconButton(
onPressed: () {},
icon: Icon(suffix),

    );



//TextFormField
Widget defaultFormField({
  Function(String value)? onSubmit,
  Function(String value)? onChanged,
  Function()? onTap,
  Function()? suffixPressed,
  required FormFieldValidator<String>? validator,
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required IconData prefix,
  bool isClickable=true,
  bool isPassword=true,
   IconData? suffix,


})=> TextFormField(
  controller: controller,
  keyboardType: type,
  obscureText: isPassword,
  onFieldSubmitted: onSubmit,
  onChanged: onChanged,
  onTap: onTap,
  validator: validator,
  enabled: isClickable,
  decoration: InputDecoration(
    //or hintText(Second Style)
    labelText: label,
    prefixIcon: Icon(
      prefix,
    ),
    suffixIcon: suffix !=null ?
    IconButton(
        onPressed: suffixPressed,
        icon: Icon(suffix,)
    ) :null,
    // suffixIcon:
    // IconButton(
    //   onPressed: (){},
    //   icon: Icon(suffix),
    //   focusColor: Colors.red,
    // ),
    //suffixIcon: suffix !=null ? Icon(suffix,) :null,
    border: OutlineInputBorder(),
  ),
);
Widget buildTaskItem(Map model,context)=> Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    children: [
      CircleAvatar(
        radius: 40.0,
        child: Text('${model['time']}'),
      ),
      SizedBox(
        width: 20.0,
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                '${model['title']}',
                style:TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                )),
            Text(
                '${model['date']}',
                style:TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                  color: Colors.grey,
                )),
          ],
        ),
      ),
      SizedBox(
        width: 20.0,
      ),
      IconButton(
          onPressed: (){
            AppCubit.get(context).updateData(status: 'done', id: model['id']);
          },
          icon: Icon(Icons.check_box,color: Colors.green,)),
      IconButton(onPressed: (){
        AppCubit.get(context).updateData(status: 'archive', id: model['id']);
      },
          icon: Icon(Icons.archive,color: Colors.black45,))

    ],
  ),
);

Widget myDivider()=>Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);










