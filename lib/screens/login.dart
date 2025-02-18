


import 'package:flutter/material.dart';
import 'package:mins/screens/Homepage.dart';

class loginScreen extends StatefulWidget{
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
   return Scaffold(
   // backgroundColor: const Color.fromARGB(226, 1, 45, 34),
    body: Center(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: LoginForm(),
        
        ),
      
    ),
   );
  }
}


class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width*0.3,
      //  height: MediaQuery.of(context).size.height*5,

        child: Card(
          elevation: 6,
          shadowColor: const Color.fromARGB(255, 9, 236, 153),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/deuces.png'),
                const SizedBox(height: 20,),
                // Email Field
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                ),
                const SizedBox(height: 16), // Spacing
        
                // Password Field
                TextField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                ),
                const SizedBox(height: 20), // Spacing
        
                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                        
                      ),backgroundColor: const Color.fromARGB(255, 5, 38, 95)
                    ),
                    onPressed: () {
                     Navigator.push(context,MaterialPageRoute(builder: (context)=>AdminDashboardApp()));
                    },
                    child: const Text('Login',style: TextStyle(color: Colors.white),),
                  ),
                ),
                 const SizedBox(height: 20),
                 Text('Forgot Password',style:TextStyle(color: Colors.black,fontWeight: FontWeight.bold))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
