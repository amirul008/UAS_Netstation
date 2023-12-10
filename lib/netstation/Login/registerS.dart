import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uas_net/netstation/Login/Service/AuthControler.dart';
import 'package:uas_net/netstation/Login/loginS.dart';

class RegisterS extends StatefulWidget {
  const RegisterS({Key? key}) : super(key: key);

  @override
  State<RegisterS> createState() => _RegisterSState();
}

class _RegisterSState extends State<RegisterS> {
  bool _isPasswordVisible = false;
  FirebaseAuthController _authentication = FirebaseAuthController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _countryController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  void register() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String username = _usernameController.text;
    String country = _countryController.text;
    String phoneNumber = _phoneNumberController.text;

    User? user = await _authentication.signUpWithEmailAndPassword(
      email: email,
      password: password,
      username: username,
      country: country,
      phoneNumber: phoneNumber,
      context: context,
    );

    if (user != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("User is successfully created"),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Cannot create user"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(66, 66, 66, 0.9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'Assets/image/ONI.png',
                    height: 150,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Daftar dulu, Yuk",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 40),
                buildInputField('Username', Icons.person, _usernameController),
                const SizedBox(height: 15),
                buildInputField('Email Address', Icons.email, _emailController),
                const SizedBox(height: 15),
                buildInputField('Country', Icons.location_on, _countryController),
                const SizedBox(height: 15),
                buildInputField('Phone Number', Icons.phone, _phoneNumberController),
                const SizedBox(height: 15),
                buildPasswordInputField('Password'),
                const SizedBox(height: 15),
                buildRegisterButton(context),
                const SizedBox(height: 20),
                buildLoginLink(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField(
      String hintText, IconData icon, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8F9),
        border: Border.all(
          color: const Color(0xFFE8ECF4),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: TextFormField(
          controller: controller,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Color(0xFF8391A1),
            ),
            prefixIcon: Icon(
              icon,
              color: const Color(0xFF8391A1),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordInputField(String hintText) {
    return buildInputField(hintText, Icons.lock, _passwordController);
  }

  Widget buildRegisterButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: MaterialButton(
            color: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onPressed: () => register(),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: const Text(
                "Register",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLoginLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Already have an account? ",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginS(),
              ),
            );
          },
          child: const Text(
            "Login",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
