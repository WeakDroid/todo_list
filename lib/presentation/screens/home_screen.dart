import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list_bloc/presentation/widgets/task_text_field.dart';
import '../../data/enum/todo_status.dart';
import '../../data/todo.dart';
import '../../domain/todo_bloc/todo_bloc.dart';
import '../styles/colors.dart';
import '../styles/text_styles.dart';
import '../widgets/custom_snack_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  addTodo(Todo todo) {
    context.read<TodoBloc>().add(
          AddTodo(todo),
        );
  }

  removeTodo(Todo todo) {
    context.read<TodoBloc>().add(
          RemoveTodo(todo),
        );
  }

  alertTodo(int index) {
    context.read<TodoBloc>().add(AlterTodo(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return _buildAlertDialog(context);
                });
          },
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: const Icon(
            Icons.add,
            color: AppColors.grey800,
            size: 32,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: BlocBuilder<TodoBloc, TodoState>(
            builder: (context, state) {
              if (state.status == TodoStatus.success) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: _buildTodoList(state),
                );
              } else if (state.status == TodoStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Container();
              }
            },
          ),
        ));
  }

  Widget _buildTodoList(TodoState state) {
    return ListView.builder(
        itemCount: state.todos.length,
        itemBuilder: (context, int i) {
          return Card(
            color: Theme.of(context).colorScheme.primary,
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Slidable(
                key: const ValueKey(0),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  extentRatio: 0.28,
                  children: [
                    SlidableAction(
                      onPressed: (_) {
                        removeTodo(state.todos[i]);
                      },
                      backgroundColor: AppColors.alertRed,
                      foregroundColor: AppColors.grey800,
                      icon: Icons.delete,
                      label: 'Remove',
                    ),
                  ],
                ),
                child: ListTile(
                    title: Text(
                      state.todos[i].title,
                      style: AppTextStyles.titleStyle,
                    ),
                    subtitle: Text(
                      state.todos[i].subtitle,
                      style: AppTextStyles.subtitleStyle,
                    ),
                    trailing: Checkbox(
                        value: state.todos[i].isDone,
                        activeColor: Theme.of(context).colorScheme.secondary,
                        onChanged: (value) {
                          alertTodo(i);
                        }))),
          );
        });
  }

  Widget _buildAlertDialog(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'New todo',
        style: AppTextStyles.h1,
      ),
      backgroundColor: AppColors.grey800,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TaskTextField(controller: titleController, hint: 'Title'),
          const SizedBox(height: 10),
          TaskTextField(controller: descriptionController, hint: 'Description'),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextButton(
              onPressed: () {
                titleController.text.isNotEmpty
                    ? addTodo(
                        Todo(
                            title: titleController.text,
                            subtitle: descriptionController.text),
                      )
                    : ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: CustomSnackbar(
                            message: 'Title should not be empty',
                          ),
                          duration: Duration(seconds: 3),
                          backgroundColor: Colors.transparent,
                        ),
                      );
                titleController.text = '';
                descriptionController.text = '';
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    width: 1,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                foregroundColor: Theme.of(context).colorScheme.secondary,
              ),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: const Icon(
                    Icons.done,
                    color: AppColors.neon,
                  ))),
        )
      ],
    );
  }
}
