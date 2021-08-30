import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();// this takes it to the next field when next is clicked on the soft keyboard
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode(); // since FocusNode doesn't work with image textfields, we are setting up our own listener
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
      id: '',
      title: '',
      price: 0,
      description: '',
      imageUrl: '');
  
  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }
  @override
  void dispose() { // This will help dispose the focus nodes and avoid memory leaks once the screen is off
    // TODO: implement dispose
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }
  void _updateImageUrl(){
    if(!_imageUrlFocusNode.hasFocus){
      if(_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') && !_imageUrlController.text.startsWith('https'))||
          (!_imageUrlController.text.endsWith('.png') &&
          !_imageUrlController.text.endsWith('.jpg') &&
          !_imageUrlController.text.endsWith('.jpeg')) ){
        return ;
      }

      setState(() {});
    }
  }
  void _saveForm(){
     final isValid = _form.currentState!.validate(); // this will trigger all the validator
     if(!isValid){
       return;
     }
     _form.currentState!.save();
     Provider.of<Products>(context, listen: false).addProduct(_editedProduct);
     // set listen to false since we are not interested in all the changes that happen to product except the addproduct
    Navigator.of(context).pop(); // this takes us to the previous page
      // print(_editedProduct.title);
      // print(_editedProduct.description);
      // print(_editedProduct.price);
      // print(_editedProduct.imageUrl);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(onPressed: _saveForm, icon: Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText:'Title'),
              textInputAction: TextInputAction.next,
                onFieldSubmitted:(_){
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please provide a value';
                  }
                  return null;
                },
                onSaved: (value){
                  _editedProduct = Product(
                    title: value!,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: _editedProduct.id,
                      price:_editedProduct.price
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText:'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                  onFieldSubmitted:(_){
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please enter a price';
                  }
                  if(double.tryParse(value) == null){
                     return 'Please enter a valid number';
                  }
                  if(double.parse(value) <= 0){
                    return 'Pls enter a number greater than zero';
                  }
                  return null;
                },
                  onSaved: (value){
      _editedProduct = Product(
      title: _editedProduct.title,
      description: _editedProduct.description,
      imageUrl: _editedProduct.imageUrl,
      id: _editedProduct.id,
      price:double.parse(value!), // convert to int as value is string
      );
      },
              ),
              TextFormField(
                decoration: InputDecoration(labelText:'Description'),
                maxLines: 3,// default lines
                keyboardType: TextInputType.multiline,
                focusNode: _descriptionFocusNode,
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please enter a description';
                  }
                  if(value.length < 10){
                    return 'Should be at least 10 characters';
                  }
                  return null;
                },
                onSaved: (value){
                  _editedProduct = Product(
                      title: _editedProduct.title,
                      description: value!,
                      imageUrl: _editedProduct.imageUrl,
                      id: _editedProduct.id,
                      price:_editedProduct.price
                  );
                },

              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: Colors.grey),
                    ),
                    child:
                    _imageUrlController.text.isEmpty ? Text('Enter a URL') :
                    FittedBox(child: Image.network(_imageUrlController.text, fit: BoxFit.cover,),),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image Url'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,// this will help us get the value before the form is submited
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_){
                        _saveForm();
                      },
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please enter a url';
                        }
                        if(!value.startsWith('http') && !value.startsWith('https')){
                          return 'Please enter a valid url ';
                        }
                        if(!value.endsWith('.png') || !value.endsWith('.jpg') || !value.endsWith('.jpeg')){
                          return '';
                        }
                        return null;
                      },
                      onSaved: (value){
                        _editedProduct = Product(
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageUrl: value!,
                            id: _editedProduct.id,
                            price:_editedProduct.price
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
