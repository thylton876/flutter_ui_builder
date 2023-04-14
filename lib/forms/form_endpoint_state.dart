import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'form_endpoint_state.freezed.dart';

@freezed
class FormEndpointState with _$FormEndpointState {
  const factory FormEndpointState.initial() = Initial;
  const factory FormEndpointState.loading() = Loading;
  const factory FormEndpointState.data({
    required int statusCode,
    required Object body,
    required Object data,
  }) = Data;
  const factory FormEndpointState.error({
    required Object error,
    StackTrace? stackTrace,
    int? statusCode,
    Object? body,
    Object? data,
  }) = Error;
}
