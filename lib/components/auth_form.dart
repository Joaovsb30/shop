import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/models/auth.dart';

enum AuthMode {
  signup,
  login,
}

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _passwordController = TextEditingController();

  AuthMode _authMode = AuthMode.login;

  bool _isLoading = false;

  bool isLogin() => _authMode == AuthMode.login;

  bool isSinup() => _authMode == AuthMode.signup;

  AnimationController? _controler;
  Animation<Size>? _heightAnimation;

  @override
  void initState() {
    super.initState();
    _controler = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );

    _heightAnimation = Tween(
      begin: const Size(double.infinity, 300),
      end: const Size(double.infinity, 400),
    ).animate(CurvedAnimation(
      parent: _controler!,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    super.dispose();
    _controler!.dispose();
  }

  void _swtichLogin() {
    setState(() {
      if (isLogin()) {
        _authMode = AuthMode.signup;
        _controler!.forward();
      } else {
        _authMode = AuthMode.login;
        _controler!.reverse();
      }
    });
  }

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    Auth auth = Provider.of(context, listen: false);
    if (!isValid) {
      return;
    }
    setState(() => _isLoading = true);

    _formKey.currentState?.save();

    try {
      if (isLogin()) {
        await auth.login(
          email: _authData['email']!,
          password: _authData['password']!,
        );
      } else {
        await auth.signup(
          email: _authData['email']!,
          password: _authData['password']!,
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
        elevation: 2,
        child: AnimatedBuilder(
          animation: _heightAnimation!,
          builder: (context, child) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: _heightAnimation?.value.height ?? (isLogin() ? 300 : 400),
            width: deviceSize.width * 0.75,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('E-mail'),
                    ),
                    onSaved: (email) => _authData['email'] = email ?? '',
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text('Senha'),
                    ),
                    controller: _passwordController,
                    onSaved: (password) =>
                        _authData['password'] = password ?? '',
                    obscureText: true,
                  ),
                  if (isSinup())
                    TextFormField(
                      validator: (_password) {
                        final password = _password ?? '';
                        if (password != _passwordController.text) {
                          return 'Senhas não conferem';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        label: Text('Confirmar Senha'),
                      ),
                      obscureText: true,
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo[900],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 8,
                              )),
                          onPressed: _submit,
                          child: Text(
                            isLogin() ? 'Logar' : 'Cadastrar',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextButton(
                    onPressed: _swtichLogin,
                    child: Text(isLogin() ? 'Cadastre-se' : 'Entrar'),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
