import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_todo_bloc/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'recycle_bin.dart';
import 'tabs_screen.dart';

import '../blocs/bloc_exports.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              color: Colors.grey,
              child: Text('Task Drawer', style: Theme.of(context).textTheme.headlineSmall),
            ),
            BlocBuilder<TasksBloc, TasksState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () => Navigator.of(context).pushReplacementNamed(TabsScreen.id),
                  child: ListTile(
                    leading: const Icon(Icons.folder_special),
                    title: const Text('My Tasks'),
                    trailing: Text('${state.pendingTasks.length} | ${state.completedTasks.length}'),
                  ),
                );
              },
            ),
            const Divider(),
            BlocBuilder<TasksBloc, TasksState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () => Navigator.of(context).pushReplacementNamed(RecycleBin.id),
                  child: ListTile(leading: const Icon(Icons.delete), title: const Text('Bin'), trailing: Text('${state.removedTasks.length}')),
                );
              },
            ),
            const Divider(),
            GestureDetector(
              onTap: () => logout(context),
              child: ListTile(leading: const Icon(Icons.logout), title: const Text('Logout'), trailing: null),
            ),
            const Divider(),
            BlocBuilder<SwitchBloc, SwitchState>(
              builder: (context, state) {
                return Switch(
                  value: state.switchValue,
                  onChanged: (newValue) {
                    newValue ? context.read<SwitchBloc>().add(SwitchOnEvent()) : context.read<SwitchBloc>().add(SwitchOffEvent());
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void logout(context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Clear navigation stack and go to login screen
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logout failed: $e")));
    }
  }
}
