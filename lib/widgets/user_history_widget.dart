import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_firebase/constants/colors.dart';
import 'package:flutter_firebase/models/convercion_model.dart';
import 'package:flutter_firebase/services/store_convercions_firestore.dart';

class UserHistoryWidget extends StatelessWidget {
  const UserHistoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
   return  StreamBuilder<List<ConvercionModel>>(stream: StoreConvercionsFirestore().getUserConvercions(), builder: (context, snapshot) {
      if(snapshot.connectionState == ConnectionState.waiting){
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      if(snapshot.hasError){
        return Center(
          child: Text("Error:${snapshot.error}"),
        );
      }
      final List<ConvercionModel>?userConvercion =snapshot.data;

      if(userConvercion == null || userConvercion.isEmpty){
        return const Center(
          child: Text("No convecions found"),
        );
      }
      return ListView.builder(
        itemCount: userConvercion.length,
        itemBuilder:(context, index) {
        final ConvercionModel convercion = userConvercion[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: mainColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  convercion.imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  loadingBuilder: (context, child, loadingProgress) {
                    if(loadingProgress == null)return child;
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.broken_image,size: 100,);
                  },
                )
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Text(
                    convercion.convercionData.length>200
                        ? "${convercion.convercionData.substring(0,200)}..."
                        :convercion.convercionData,
                  style: const TextStyle(
                    fontSize: 14,
                  ),      
                    
                  ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy,color: mainColor,
                    ),
                    onPressed: (){
                      Clipboard.setData(
                        ClipboardData(text: convercion.convercionData));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar( 
                        content:Text('Text copied to clipboard!'),),
                        
                      );  

                    })
                ],
              ),
              const SizedBox(height: 8,),
              Text(
                'Converted on:${convercion.convercionDate.toLocal().toString().split(' ')[0]}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey
                ),
              )
            ],
          ),
          ),

        );
      }
      ,);
    },
    );
  }
}