import '../models/user.dart';
import '../services/auth_service.dart';
class AuthController{

  final StorageService _storageService=StorageService();

  Future<void> signUp(User user) async{
if (user.prenom.isEmpty ||  user.nom.isEmpty || 
        user.email.isEmpty || user.password.isEmpty) {
  throw Exception("Veuillez remplir tous les champs ");
}

    if(! _isValidEmail(user.email)){
      throw Exception("format d'email invalidee ");;
    }

    if (await _storageService.emailExists(user.email)) {
      throw Exception("Cet email est déja utilisé ");
    }
await _storageService.saveUser(user.toJson());
  }
    bool _isValidEmail(String email){
        return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

    }
}