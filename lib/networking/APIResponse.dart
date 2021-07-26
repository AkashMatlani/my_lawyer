import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

enum Status { Loading, Done, Error }

class APIResponse<T> {
  Status status;
  T data;
  String message;
  Map<String, dynamic> error;

  APIResponse.loading(this.message) : status = Status.Loading;

  APIResponse.done(this.data) : status = Status.Done;

  APIResponse.error(this.error) : status = Status.Error;

  String toString() {
    return 'Status: $status Message: $message, Data: $data';
  }
}
