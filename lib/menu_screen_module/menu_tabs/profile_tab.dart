import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sihproject/menu_screen_module/menu_tabs/show_media_screen.dart';
import 'package:sihproject/menu_screen_module/reusable_list_tile.dart';
import 'package:sihproject/models/saved_info.dart';
import 'package:sihproject/user_signin_signup_modules/Screens/components/rounded_input_field.dart';
import 'package:path/path.dart' as Path;


class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  void _showScaffold(String message){
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message), duration: Duration(milliseconds: 900),));
  }

  String dispName;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    dispName = dispName = Provider.of<SavedInfo>(context, listen: false).getDisplayName();
    if(dispName == null || dispName == ''){
      dispName = Provider.of<SavedInfo>(context, listen: false).getUser();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomPadding: false,
        appBar:  AppBar(
          elevation: 0,
          backgroundColor: Color(0xff263238),
          title: Text(
            'MyProfile',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22.0),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xffDCDCE5),
                    blurRadius: 10.0,
                  )
                ]),
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 15.0, right: 15.0, bottom: 20.0),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    child: Container(
                      width: 120,
                      height: 120,
                      child: Provider.of<SavedInfo>(context, listen: false).getPhotoUrl() == '' ||
                          Provider.of<SavedInfo>(context, listen: false).getPhotoUrl() == null ?
                       Icon(Icons.camera_alt, color: Colors.grey[400], size: 40.0,) : CircleAvatar(
                        backgroundColor: Colors.black54,
                        backgroundImage: NetworkImage(Provider.of<SavedInfo>(context, listen: false).getPhotoUrl()),
                       ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100.0),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffDCDCE5),
                              blurRadius: 10.0,
                            )
                          ]),
                    ),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ShowMediaScreen(mediaLink: Provider.of<SavedInfo>(context, listen: false).getPhotoUrl())));
                    },
                    onLongPress: (){
                      setImage(context);
                    },
                  ),
                  SizedBox(height: 30.0,),
                  Text(
                   dispName,
                    style: TextStyle(
                        color: Color(0xff263238),
                        fontWeight: FontWeight.w500,
                        fontSize: 25.0
                    ),
                  ),
                  SizedBox(height: 30.0,),
                  ReusableListTile(
                    icon: Icons.assignment,
                    title: 'My current plan',
                    iconColor: Colors.green,
                    onPressed: (){
                      myPlan(context);
                    },
                  ),
                  SizedBox(height: 10.0,),
                  ReusableListTile(
                    icon: Icons.email,
                    title: 'Reset E-mail',
                    iconColor: Colors.redAccent,
                    onPressed: (){
                      showAlert(context, 'Reset E-mail');
                    },
                  ),
                  SizedBox(height: 10.0,),
                  ReusableListTile(
                    icon: Icons.visibility,
                    title: 'Change password',
                    iconColor: Colors.grey,
                    onPressed: (){
                      showAlert(context, 'Reset Password');
                    },
                  ),
                  SizedBox(height: 10.0,),
                  ReusableListTile(
                    icon: Icons.edit,
                    title: 'Change display name',
                    iconColor: Colors.blue,
                    onPressed: (){
                      changeDisplayName(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  showAlert(BuildContext context, String title){
    String credential;
    String newCredential;
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text(title == 'Reset E-mail' ? title : 'Reset Password',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18.0,
              ),
            ),
            content: title == 'Reset E-mail' ? RoundedInputField(
              hintText: 'New E-mail',
              onChanged: (value){
                credential = value;
              },
            ) : Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RoundedInputField(
                  hintText: 'Old Password',
                  onChanged: (value){
                    credential = value;
                  },
                ),
                RoundedInputField(
                  hintText: 'New Password',
                  onChanged: (value){
                    newCredential = value;
                  },
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: (){ /// when this button is pressed then the popup is dismissed
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  'Reset',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: (){
                  if(credential == null || credential == ''){
                    print('ok');
                    _showScaffold('cannot set it empty');
                  }else {
                    if(title == 'Reset E-mail') {
                      Provider.of<SavedInfo>(context, listen: false).resetMyEmail(credential);
                      _showScaffold('Done');
                    }
                    else{
                      if(credential != Provider.of<SavedInfo>(context, listen: false).getOldPassword()){
                        _showScaffold('match failed');
                      }
                      else{
                        Provider.of<SavedInfo>(context, listen: false)
                            .resetMyPassword(newCredential);
                        _showScaffold('Done');
                      }
                    }
                  }
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  myPlan(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('This is your current plan',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18.0,
              ),
            ),
            content: Row(
              children: <Widget>[
                Text(
                  '2000',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 25.0
                  ),
                ),
                SizedBox(width: 10.0,),
                RaisedButton(
                  child: Text('FREEZ' , style: TextStyle(color: Colors.white),),
                  color: Colors.green,
                  onPressed: (){
                    Navigator.pop(context);
                    _showScaffold('Your current plan has been freezed');
                  },
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: (){ /// when this button is pressed then the popup is dismissed
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  setImage(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Update profile photo',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18.0,
              ),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.camera, color: Colors.grey, size: 35.0,),
                  onPressed: (){
                   getMedia(context, ImageSource.camera);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.photo_library, color: Colors.blue, size: 35.0,),
                  onPressed: (){
                    getMedia(context, ImageSource.gallery);
                  },
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: (){ /// when this button is pressed then the popup is dismissed
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }

  changeDisplayName(BuildContext context){
    String credential;
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Set your name',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 18.0,
              ),
            ),
            content:RoundedInputField(
              hintText: 'Name',
              onChanged: (value){
                credential = value;
              },
            ) ,
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: (){ /// when this button is pressed then the popup is dismissed
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  'Set',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: (){ /// when this button is pressed then the popup is dismissed
                  if(credential == null || credential == '') {
                    _showScaffold('cannot set an empty name');
                    Navigator.pop(context);
                  }else{
                    Provider.of<SavedInfo>(context, listen: false).setDisplayName(credential);
                    Navigator.pop(context);
                    setState(() {
                      dispName = credential;
                    });
                  }
                },
              )
            ],
          );
        }
    );
  }

  void getMedia(context,mediaSource) async{
    await ImagePicker().getImage(source: mediaSource).then((image){
      Navigator.of(context).pop();
      StorageReference storageReference = _storage.ref().child('profilePhoto/').child(Path.basename(image.path));
      StorageUploadTask storageUploadTask = storageReference.putFile(File(image.path));
      onComplete(storageReference,storageUploadTask);

    }
    );
  }

  void onComplete(StorageReference ref, StorageUploadTask task) async{
    await task.onComplete;
    var profileUrl = await ref.getDownloadURL();
    setState(() {
      Provider.of<SavedInfo>(context, listen: false).setPhotoUrl(profileUrl);
    });
  }
}
