import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sihproject/main_screen.dart';
import 'package:sihproject/user_signin_signup_modules/Screens/components/rounded_button.dart';

class SubscriptionScreen extends StatefulWidget {
  SubscriptionScreen({this.lat, this.long});
  final double lat;
  final double long;
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {

  static const platform = const MethodChannel('razorpay_flutter');

  Razorpay _razorpay;
  String paymentResponse;
  String merchantID = 'KzzejG09699460228112';
  String merchantKey = 'FaxkXmwsGlfZ1PuY';
  String website = 'WEBSTAGING';
  bool loading = false;

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Select A Subscription Plan',
                    style: TextStyle(
                      fontFamily: 'Rowdies',
                      color: Color(0xff263238),
                      fontWeight: FontWeight.w500,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffDCDCE5),
                        blurRadius: 10.0,
                      )
                    ]),
              ),
              SizedBox(height: 8.0,),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      RoundedButton(
                        color: Color(0xff263238),
                        text: '1000',
                        textColor: Colors.white,
                        press: (){
                          openCheckout();
                        },
                      ),
                      RoundedButton(
                        color: Colors.grey[200],
                        text: '2000',
                        textColor: Color(0xff263238),
                        press: (){
                          openCheckout();
                        },
                      )
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xffDCDCE5),
                        blurRadius: 10.0,
                      )
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': '1000',
      'name': 'Acme Corp.',
      'description': '',
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    showAlert(context,
        'SUCCESS: ${response.paymentId}');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showAlert(context,
        'ERROR: ${response.code.toString()} + " - " + ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    showAlert(context,
       'Payment Successfull using: ${response.walletName}');
  }
  showAlert(context, String payAmount) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Info',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18.0,
              ),
            ),
            content: Text(payAmount),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Proceed',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return MainScreen(latitude: widget.lat, longitude: widget.long,);
                  }));
                },
              ),
            ],
          );
        });
  }
//  Future<void> _verifyPhoneNumber(BuildContext context) async{
//
////    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]){
////      verificationId = verId;
////      smsOTPDialog(context).then((value){
////        print('sign in');
////      });
////    };
//
//    try {
//      await _auth.verifyPhoneNumber(
//
//          phoneNumber: '+$dialCode ' + phoneNo,
//
//          timeout: Duration(seconds: 30),
//
//          verificationCompleted: (AuthCredential credential) {
//            // _auth.signInWithCredential(credential).then((AuthResult result){
//            //  Navigator.pushNamed(context, ChatScreen.id);
//            // });
//            print(credential);
//          },
//
//          verificationFailed: (AuthException exception) {
//            print(exception);
//          },
//
//          codeSent: smsOTPSent,
//
//          codeAutoRetrievalTimeout: (String verId) {
//            verificationId = verId;
//          }
//
//      );
//    }catch(e){
//      print(e);
//    }
//  }

}
