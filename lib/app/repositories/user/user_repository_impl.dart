import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_list_provider/app/exception/auth_exception.dart';

import 'user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  FirebaseAuth _firebaseAuth;

  UserRepositoryImpl({required FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth;

  @override
  Future<User?> register(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      // email-already-exists
      if (e.code == 'email-already-in-use') {
        final loginTypes =
            await _firebaseAuth.fetchSignInMethodsForEmail(email);
        if (loginTypes.contains('password')) {
          throw AuthException(
              message: 'E-mail já utilizado, por favor escolha outro e-mail');
        } else {
          throw AuthException(
              message:
                  'Você se cadastrou no TodoList pelo Google, por favor utilize ele para entrar!');
        }
      } else {
        throw AuthException(message: (e.message ?? '') + '\n Erro ao registrar usuário.');
      }
    }
  }

  @override
  Future<User?> login(String email, String password) async {
    try {

      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);


      return userCredential.user;
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      throw AuthException(message: (e.message ?? '' )+ 
      '- Erro ao realizar login');
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        throw AuthException(message:( e.message ?? '') + ' \n Login ou senha inválidos');
      }
      throw AuthException(message: (e.message ?? '') + ' \n Erro ao realizar login');
    } catch (e) {
      print(e);
      throw Exception('Erro ao realizar login');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      var loginMethods = await _firebaseAuth.fetchSignInMethodsForEmail(email);

      if (loginMethods.contains('password')) {
        await _firebaseAuth.sendPasswordResetEmail(email: email);
      } else if (loginMethods.contains('google')) {
        throw AuthException(
            message:
                'Cadastro realizado com o google, não pode ser resetado a senha');
      } else {
        throw AuthException(message: 'Email não cadastrado');
      }
    } on PlatformException catch (e, s) {
      print(e);
      print(s);
      throw AuthException(message: 'Erro ao resetar senha');
    }
  }
  
  @override
  Future<User?> googleLogin() async {
    List<String>? loginMethods;
    try {
        final googleSignIn = GoogleSignIn();
        final googleUser = await googleSignIn.signIn();
      if(googleUser != null) {
        loginMethods = 
            await _firebaseAuth.fetchSignInMethodsForEmail(googleUser.email);
  
      if(loginMethods.contains('password')) {
        throw AuthException(
            message: 'Você utilizou o e-mail para cadastro no TodoList, caso tenha esquecido sua senha por favor clique no link "Esqueci minha senha".');
      } else {
        final googleAuth = await googleUser.authentication;
        final firebaseCredencial = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken,
        );
        var userCredential = await _firebaseAuth.signInWithCredential(firebaseCredencial);
        return userCredential.user;
      }
    }
    } on FirebaseAuthException catch (e, s) {
      print(e);
      print(s);
      if(e.code == 'account-exists-with-different-credential') {
        throw AuthException(message: '''
            Login inválido, você se registrou no TodoList com os seguintes provedores:
              ${loginMethods?.join(',')}
            ''');
      }else {
        throw AuthException(message: 'Erro ao realizar login');
      }
    }
  }
  
  @override
  Future<void> logOut() async {
    await GoogleSignIn().signOut();
    _firebaseAuth.signOut();
    // sql
  }
  
  @override
  Future<void> updateDisplayName(String name) async {
    final user = _firebaseAuth.currentUser;
    if(user != null) {
      await user.updateDisplayName(name);
      user.reload();
    }
  }
}
