import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/provider/task_provider.dart';
import 'package:todo/provider/user_provider.dart';
import 'package:todo/view/task_dialog.dart';
import 'package:todo/view/loginscreen.dart';  // Ajoutez ceci pour accéder à l'écran de connexion

class TaskListView extends StatelessWidget {
  const TaskListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    if (userProvider.user == null) {
      // Rediriger immédiatement vers l'écran de connexion si l'utilisateur n'est pas connecté
      Future.microtask(() {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      });
      return const SizedBox.shrink();  // Retourne un widget vide pendant la redirection
    }

    // Fetch tasks when the user is logged in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userProvider.user != null) {
        taskProvider.fetchTasks(userProvider.user!.id);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenue, ${userProvider.user?.email ?? ''}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              userProvider.logoutUser();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: taskProvider.tasks.length,
        itemBuilder: (context, index) {
          final task = taskProvider.tasks[index];
          return ListTile(
            title: Text(
              task.title,
              style: TextStyle(
                decoration: task.completed ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
            subtitle: Text(
              task.description,
              style: TextStyle(
                decoration: task.completed ? TextDecoration.lineThrough : TextDecoration.none,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Confirmer la suppression'),
                        content: Text('Voulez-vous vraiment supprimer cette tâche ?'),
                        actions: [
                          TextButton(
                            child: Text('Annuler'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Supprimer'),
                            onPressed: () async {
                              await taskProvider.deleteTask(task.id);
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Checkbox(
                  value: task.completed,
                  onChanged: (value) {
                    taskProvider.toggleComplete(task.id, value!);
                  },
                  activeColor: Colors.green,
                ),
              ],
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => TaskDialog(task: task),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => TaskDialog(),
          );
        },
        backgroundColor: Color.fromRGBO(0, 113, 191, 1), // Couleur de fond du bouton flottant
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
      ),
    );
  }
}
