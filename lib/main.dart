import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'model/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();

  final userRepository = FirebaseUserRepo();
  final cattleRepository = CattleRepository();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (context) => userRepository,
        ),
        RepositoryProvider<CattleRepository>(
          create: (context) => cattleRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(userRepository: userRepository),
          ),
          BlocProvider<CattleBloc>(
            create: (context) => CattleBloc(
              context.read<CattleRepository>(),
              context.read<UserRepository>()
            ),
          ),
        ],
        child: MyApp(userRepository),
      ),
    ),
  );
}

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   Bloc.observer = SimpleBlocObserver();

//   final userRepository = FirebaseUserRepo();
//   final cattleRepository = CattleRepository();

//   runApp(
//     MultiRepositoryProvider(
//       providers: [
//         RepositoryProvider<UserRepository>(
//           create: (context) => userRepository,
//         ),
//         RepositoryProvider<CattleRepository>(
//           create: (context) => cattleRepository,
//         ),
//       ],
//       child: MultiBlocProvider(
//         providers: [
//           BlocProvider<AuthenticationBloc>(
//             create: (context) => AuthenticationBloc(userRepository: userRepository),
//           ),
//           BlocProvider<CattleBloc>(
//             create: (context) => CattleBloc(
//               context.read<CattleRepository>(), 
//               context.read<UserRepository>()
//             ),

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter SQLite Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const HomePage(),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final dbHelper = DatabaseHelper();
//   List<User> users = [];
  
//   final nameController = TextEditingController();
//   final emailController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _refreshUserList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter SQLite Demo'),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Form(
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: nameController,
//                     decoration: const InputDecoration(labelText: 'Name'),
//                   ),
//                   TextFormField(
//                     controller: emailController,
//                     decoration: const InputDecoration(labelText: 'Email'),
//                   ),
//                   const SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: _addUser,
//                     child: const Text('เพิ่มผู้ใช้'),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: users.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Text(users[index].name),
//                   subtitle: Text(users[index].email),
//                   trailing: IconButton(
//                     icon: const Icon(Icons.delete),
//                     onPressed: () => _deleteUser(users[index].id!),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _refreshUserList() async {
//     final data = await dbHelper.queryAllUsers();
//     setState(() {
//       users = data.map((e) => User.fromMap(e)).toList();
//     });
//   }

//   void _addUser() async {
//     String name = nameController.text;
//     String email = emailController.text;
    
//     if (name.isNotEmpty && email.isNotEmpty) {
//       User newUser = User(name: name, email: email);
//       await dbHelper.insertUser(newUser.toMap());
      
//       // Clear the form
//       nameController.clear();
//       emailController.clear();
      
//       // Refresh the list
//       _refreshUserList();
//     }
//   }

//   void _deleteUser(int id) async {
//     await dbHelper.deleteUser(id);
    
//     // Refresh the list
//     _refreshUserList();
    
//     // Show snackbar
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('ลบผู้ใช้เรียบร้อยแล้ว')),
//     );
//   }
// }