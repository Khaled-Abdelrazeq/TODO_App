import 'package:flutter/material.dart';

import 'constants.dart';
import 'cubit/cubit.dart';

Widget taskCategory({
  required BuildContext context,
  required String title,
  required Color sliderColor,
  required List<Map> tasks,
}) {
  return SizedBox(
    height: 115,
    width: 190,
    child: Card(
      elevation: 3,
      shape: cardShape,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 20.0, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              tasks.length == 1
                  ? '${tasks.length} task'
                  : '${tasks.length} tasks',
              style: titleStyle,
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SliderTheme(
              child: Slider(
                value: tasks.length.toDouble(),
                max: maxSliderValue,
                min: 0,
                onChanged: (value) {},
                thumbColor: sliderColor,
                activeColor: sliderColor,
                inactiveColor: greyColor,
              ),
              data: SliderTheme.of(context).copyWith(
                  trackHeight: 3,
                  thumbColor: Colors.transparent,
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 3.5)),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget taskItem({required Map tasks, required BuildContext context}) {
  return Dismissible(
    key: Key('${UniqueKey()}'),
    onDismissed: (direction) {
      AppCubit.get(context).deleteFromDatabase(id: tasks['id']);
    },
    child: SizedBox(
      height: 65,
      child: Card(
          elevation: 3,
          shape: cardShape,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              children: [
                iconButtonUpdate(
                  context: context,
                  iconDataChecked: Icons.check_circle,
                  iconDataUnChecked: Icons.radio_button_unchecked,
                  tasks: tasks,
                  updatedText: 'done',
                  isDoneICon: true,
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    tasks['title'],
                    maxLines: 3,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                        decoration: tasks['status'] == 'done'
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                ),
                iconButtonUpdate(
                    tasks: tasks,
                    context: context,
                    iconDataChecked: Icons.archive_rounded,
                    iconDataUnChecked: Icons.archive_outlined,
                    updatedText: 'archive')
              ],
            ),
          )),
    ),
  );
}

Widget iconButtonUpdate({
  required Map tasks,
  required BuildContext context,
  required IconData iconDataChecked,
  required IconData iconDataUnChecked,
  required String updatedText,
  bool isDoneICon = false,
}) =>
    IconButton(
      icon: Icon(
        tasks['status'] == updatedText ? iconDataChecked : iconDataUnChecked,
        size: 30,
      ),
      color: isDoneICon
          ? tasks['type'] == 'Personal'
              ? personalColor
              : businessColor
          : greyColor,
      onPressed: () {
        AppCubit.get(context)
            .updateDatabase(updateStatus: updatedText, id: tasks['id']);
      },
    );

Widget textField({
  required TextEditingController controller,
  Function? onSubmittedFunction,
  Function? onTabFunction,
  required String labelText,
  required IconData prefixIcon,
  required String validateText,
  bool isEnabled = true,
  TextInputType keyboardType = TextInputType.text,
  double radius = 10,
  bool obscureText = false,
  IconData? suffixIcon,
  Function? suffixFunction,
}) =>
    TextFormField(
      controller: controller,
      enabled: isEnabled,
      keyboardType: keyboardType,
      onFieldSubmitted: (_) {
        onSubmittedFunction!();
      },
      onTap: () {
        onTabFunction!();
      },
      obscureText: obscureText,
      decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(prefixIcon),
          suffixIcon: suffixIcon != null
              ? IconButton(
                  onPressed: () {
                    suffixFunction!();
                  },
                  icon: Icon(suffixIcon))
              : Text(''),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(radius)))),
      validator: (value) {
        if (value != null && value.isNotEmpty) {
          return null;
        }
        return validateText; //'Email address mustn\'t be empty';
      },
    );

Widget circleIcon({
  required double width,
  required double height,
  required double radius,
  required double padding,
  required IconData iconData,
  required Color color,
  Color iconColor = Colors.white,
  required Function onTabFunction,
}) =>
    GestureDetector(
      onTap: () {
        onTabFunction();
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            color: color,
          ),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.only(start: padding),
          child: Icon(
            iconData,
            color: iconColor,
            size: 35,
          ),
        ),
      ),
    );

Widget drawerElement({
  required IconData iconData,
  required String title,
  required Function onTabFunction,
}) =>
    GestureDetector(
      onTap: () {
        onTabFunction();
      },
      child: Row(
        children: [
          Icon(
            iconData,
            color: greyColor,
          ),
          const SizedBox(width: 15),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );

Widget emptyTasks() => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            color: greyColor,
            size: 50,
          ),
          const SizedBox(height: 3),
          Text(
            'No Tasks for today, please add some!',
            style: TextStyle(fontSize: 16, color: greyColor),
          )
        ],
      ),
    );

Widget listViewTasks({
  required BuildContext context,
  required List<Map> tasks,
}) =>
    ListView.separated(
        itemBuilder: (context, index) {
          return taskItem(tasks: tasks[index], context: context);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: 5,
          );
        },
        itemCount: tasks.length);
