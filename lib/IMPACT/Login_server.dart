import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:jwt_decoder/jwt_decoder.dart';



class Impact{

  static const String baseUrl = 'https://impact.dei.unipd.it/bwthw/';
  static String pingEndpoint = 'gate/v1/ping/';
  static String tokenEndpoint = 'gate/v1/token/';
  static String refreshEndpoint = 'gate/v1/refresh/';

  static const String patientUsername = 'Jpefaq6m58';
  static const String distanceEndpoint = 'data/v1/steps/patients/';

  
  static String username = '<YOUR_USERNAME>';
  static String password = '<YOUR_PASSWORD>';


  //This method allows to check if the IMPACT backend is up
  Future<bool> isImpactUp() async {

    //Create the request
    final url = Impact.baseUrl + Impact.pingEndpoint;

    //Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url));

    //Just return if the status code is OK
    return response.statusCode == 200;
  } //_isImpactUp


  //This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
  Future<int> getAndStoreTokens() async {

    //Create the request
    final url = Impact.baseUrl + Impact.tokenEndpoint;
    final body = {'username': Impact.username, 'password': Impact.password};

    //Get the response
    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    //If response is OK, decode it and store the tokens. Otherwise do nothing.
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString('access', decodedResponse['access']);
      await sp.setString('refresh', decodedResponse['refresh']);
    } //if

    //Just return the status code
    return response.statusCode;
  } //_getAndStoreTokens



  //This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
  static Future<int> refreshTokens() async {

    //Create the request
    final url = Impact.baseUrl + Impact.refreshEndpoint;
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh');

    final body = {'refresh': refresh};

    //Get the respone
    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    //If 200 set the tokens
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      sp.setString('access', decodedResponse['access']);
      sp.setString('refresh', decodedResponse['refresh']);
    } //if

    //Return just the status code
    return response.statusCode;
  } //_refreshTokens



  //This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
  static Future<dynamic> fetchDistanceData(String day) async {

    //Get the stored access token (Note that this code does not work if the tokens are null)
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');

    //If access token is expired, refresh it
    if(JwtDecoder.isExpired(access!)){
      await Impact.refreshTokens();
      access = sp.getString('access');
    }//if

    //Create the (representative) request
    final url = Impact.baseUrl + distanceEndpoint + patientUsername + '/day/$day/';
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};
    print(url);

    //Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);
    
    //if OK parse the response, otherwise return null
    var result = null;
    if (response.statusCode == 200) {
      result = jsonDecode(response.body);
    } //if

    //Return the result
    return result;

  } //_requestData

 
 













}