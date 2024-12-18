import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/services/store_convercions_firestore.dart';
import 'package:flutter_firebase/widgets/image_preview.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ImagePicker imagePicker;
  late TextRecognizer textRecognizer;
  String? pikedImagePath;
  String recognizedText = "";

 bool isImagePicked = false;
 bool isProcessing = false;

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
  imagePicker =ImagePicker();
  textRecognizer = TextRecognizer(
    script: TextRecognitionScript.latin,
  );
 }

 // Function to pick an image
 void _pickImage({required ImageSource source})async{
final pickedImage = await imagePicker.pickImage(source: source);
if(pickedImage == null){
  return;
}
setState(() {
 pikedImagePath = pickedImage.path;
 isImagePicked=true;
});
 }

 // Function to process the picked image  

  void _processingImage() async {

    if(pikedImagePath == null){
      return;
    }

    setState(() {
      isProcessing = true;
      recognizedText = "";
    });

    try{
      //convert my image in to input image
      final inputImage = InputImage.fromFilePath(pikedImagePath!);
     
       final RecognizedText textReturnedFromModel = 
       await textRecognizer.processImage(inputImage);
      // print(textReturnedFromModel.blocks[0].lines[0].text);

      //Loop through the recognized text blocks and lines and concatenate them
      for (TextBlock block in textReturnedFromModel.blocks){
        for(TextLine line in block.lines){
          recognizedText += "${line.text}\n";
        }
      }
      //store the convercion data in the firestore
      if(recognizedText.isNotEmpty){
        try{
           await StoreConvercionsFirestore().storeConversionData(convercionData: recognizedText, convercionDate:DateTime.now(), imageFile: File(pikedImagePath!),);
           ScaffoldMessenger.of( context).showSnackBar(
            const SnackBar(content: const Text('The recognized successfully'),),
           );
        }catch(error){
          print(error);
        }
      }
     // print(recognizedText);
    } catch(error) {
      print(error.toString());
      if(!mounted){ 
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error Recognizing Text"),),
        
      );
    }finally{
      setState(() {
       isProcessing =false; 
      });
    }

  }

 //show bottom sheet
  void _ShowBottomSheetWidget (){
   showModalBottomSheet(
     context: context, builder: (context) {
        return Padding(
          padding:const EdgeInsets.symmetric(
            vertical: 20,
           horizontal: 16,
          ),
           child:Column(
             mainAxisSize: MainAxisSize.min,
               children: [
                 ListTile(
                   leading: const Icon(
                      Icons.photo_library
                    ),
                     title: const Text(
                       "Choose from Gallery"
                     ),
                        onTap: () {
                           Navigator.pop(
                             context
                           );
                            _pickImage(
                              source:ImageSource.gallery
                            );

                        },
                  ),
                 ListTile(
                   leading: const Icon(
                           Icons.photo_library
                    ),
                     title: const Text(
                        "Take a Image from Camera"
                      ),
                    onTap: () {
                      Navigator.pop(
                          context
                      );
                     _pickImage(
                        source: ImageSource.camera
                      );

                    },
                  ),
                ],
              ),
        );
    
      },
   );
 }
 //copy to clipboard
 void _copyToClipboard()async {
  if(recognizedText.isNotEmpty){
    await Clipboard.setData(
      ClipboardData(text: recognizedText),
    );
    if(context.mounted){
       ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content:Text('Text copied to clipboard'), 
      ),
    );

    }
   
  }
 }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ML Text Recognition",style: TextStyle(color: Colors.white),),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
           
            children: [
              Padding(
                 padding:  const EdgeInsets.symmetric(
                  vertical: 20,
                 ),
                    child: ImagePreview(
                    imagePath:pikedImagePath
                  ),
              ),
               if(!isImagePicked)Row(
                mainAxisAlignment: MainAxisAlignment.end,
                 children: [
                   ElevatedButton(
                    onPressed:isProcessing ? null:_ShowBottomSheetWidget,
                     child: const Text(
                      "Pick an Image"
                      ,style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                   ),
                 ],
               ),
             if(isImagePicked)
             Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed:isProcessing ? null: _processingImage,
                  child:  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                     const Text(
                       "Process Image",
                       style: TextStyle(
                         color: Colors.white,
                         fontSize: 18,
                        ),
                      ),
                      if(isProcessing) ...[
                          const SizedBox(
                            width: 20,
                       
                          ),
                             const SizedBox(
                              width: 20,
                              height: 16,
                            child: CircularProgressIndicator(),
                          )
                      ]
                   ],
                 ),
                )
                 ,
              ],
             ) ,
             const SizedBox(height: 20,), 
             Padding(padding: const EdgeInsets.only(top: 10),
             child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
              const Text("Recognized text",style: TextStyle(fontSize: 20),),
              IconButton(
                onPressed: _copyToClipboard,
                icon: const Icon(Icons.copy,size: 20,),
                
              ),
             ],),
             ),
             if(!isProcessing) ...[
              Expanded(
                 child: Scrollbar(
                  child: SingleChildScrollView(
                    child:Row(
                     children: [
                      Flexible(
                        child: SelectableText(
                          recognizedText.isEmpty
                           ?"No Text recognized"
                           :recognizedText,
                          ),
                      )
                      ],
                    ) ,
                  ),
                ),
               ),
             ],
            ],
          ),
        ),
      ),
    );
  }
}