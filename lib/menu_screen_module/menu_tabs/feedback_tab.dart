import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:provider/provider.dart';
import 'package:sihproject/models/saved_info.dart';


class FeedbackTab extends StatelessWidget {

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final int maxLines = 20;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color(0xff263238),
          title: Text(
            'feedback',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22.0),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(flex: 1, child: Icon(Icons.alternate_email, color: Colors.redAccent,)),
                        Expanded(
                          flex: 6,
                          child: Text(
                              Provider.of<SavedInfo>(context, listen: false).getUser(),
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500
                              )
                          ),
                        ),
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
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Please leave your feedback below:',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w500
                            ),
                          ),
                          SizedBox(height: 5.0,),
                          Flexible(
                            child: Scrollbar(
                              isAlwaysShown: false,
                              child: TextField(
                                textCapitalization: TextCapitalization.sentences,
                                maxLines: maxLines,
                                controller: controller,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey[50],
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  contentPadding: EdgeInsets.all(8.0),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey[200])),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey[200])),
                                ),
                              ),
                            ),
                          ),
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
                  ),
                ),
                RaisedButton(
                  child: Text(
                    'SEND',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  color: Color(0xff3366ff),
                  onPressed: () {
                     if (controller.text == null || controller.text == '') {
                      showAlert(context, 'Tell us your querry please');
                    }else{
                       sendFeedback(context);
                       controller.clear();
                     }
                  },
                )
              ]),
        ),
      ),
    );
  }

  void sendFeedback(BuildContext context) async{
    String userName = 'mailfordevelopment101@gmail.com';//Provider.of<SavedInfo>(context, listen: false).getUser();
    String password = 'sh@m1n@m1n@'; //Provider.of<SavedInfo>(context, listen: false).getPassword();

    final smtpServer = gmail(userName, password);

    final feedback = Message()..from = Address(userName)..recipients.add('singhbprakash505@gmail.com')..text = controller.text;

    try{
      final sendReport = await send(feedback,smtpServer);
      print('send report: ${sendReport.toString()}');
      if(sendReport.toString() == 'send report: Message successfully sent.' ){
        showAlert(context, 'feedback sent');
      }
    } catch(e){
        print(e);
        showAlert(context, 'An error encountered');
    }
  }

  showAlert(context, String alertText) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'oops!',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18.0,
              ),
            ),
            content: Text(
              alertText,
              style: TextStyle(
                fontWeight: FontWeight.w300,
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  /// when this button is pressed then the popup is dismissed
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

}
