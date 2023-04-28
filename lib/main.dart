import 'package:flutter/material.dart';



class Product {
  const Product({required this.name});

final String name;


}

typedef CartChangeCallback = Function(Product product, bool inCart );

class ShoppingListItem extends StatelessWidget{
    ShoppingListItem({
      required this.product,
      required this.inCart,
      required this.onCartChanged,
    }) : super(key: ObjectKey(product));

    final Product product;
    final bool inCart;
    final CartChangeCallback onCartChanged;

    Color _getColor(BuildContext context){
      return inCart 
        ? Colors.black54
        : Theme.of(context).primaryColor;
    }

    TextStyle? _getTextStyle(BuildContext context){
      if(!inCart) return null ;
      return const TextStyle(
        color: Colors.black54,
        decoration:TextDecoration.lineThrough,
      );
    }

    @override
    Widget build(BuildContext context){
      return  ListTile(
        onTap:(){
          onCartChanged(product, inCart);
        },
        leading: CircleAvatar(
          backgroundColor: _getColor(context),
          child:Text(product.name[0]),
        ),
        title: Text(product.name, style: _getTextStyle(context),),
      );
    }
}

class ShoppingList extends StatefulWidget {
  const ShoppingList({required this.products,super.key});

  final List<Product> products;

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final _shoppingCart =<Product>{};
   final _textController = TextEditingController();



  void _handleOnCardChanged(Product product, bool inCart){
    setState(() {
      if(!inCart){
        _shoppingCart.add(product);
      } else {
        _shoppingCart.remove(product);

      }
    });
  }

  void _handleAddProduct(){
    final productName = _textController.text.trim();
    if(productName.isNotEmpty){
        setState(){
          widget.products.add(Product(name: productName));
         }
           _textController.clear();
    }
  }

  @override
  void dispose(){
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context){
    return  Scaffold(
      appBar:AppBar(title: const Text("Shopping List"),),
      body: Column(
        children: [
        Expanded(child:ListView(
          padding: const EdgeInsets.symmetric(vertical:8.0),
          children: widget.products.map((product){
            return ShoppingListItem(
              product: product, 
              inCart: _shoppingCart.contains(product), 
              onCartChanged: _handleOnCardChanged
              );
              
          }).toList(),

          ),
        ),

       


        ],
      ),
     
    );
  }
}

void main(){
  runApp(
     const MaterialApp(
        title:'ShoppingApp',
      home: ShoppingList (
        products: [
          Product(name: 'Chips'),
          Product(name: "burger"),
          Product(name: "water"),
        ], 
       
    ),
  ),
  );
}