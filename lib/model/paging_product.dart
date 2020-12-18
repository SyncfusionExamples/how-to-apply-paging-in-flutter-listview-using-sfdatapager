import 'package:flutter/material.dart';

class PagingProduct {
  PagingProduct(
      {this.name,
      this.ratings,
      this.image,
      this.weight,
      this.price,
      this.offer,
      this.reviewValue});

  String name;

  String ratings;

  String image;

  String weight;

  double price;

  String offer;

  double reviewValue;
}
