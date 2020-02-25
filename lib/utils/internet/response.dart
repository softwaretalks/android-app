
import 'dart:convert';


class BaseResponse {

  bool success = false;
  int statusCode = -1; // for general status
  Object result; // for string results
  Object results;
  int count = 0;
  ResponseError error; // list of code and message


  static const String keySuccess= "success";
  static const String keyStatusCode= "statusCode";
  static const String keyResult= "result";
  static const String keyResults= "results";
  static const String keyCount= "count";
  static const String keyError= "error";


  BaseResponse(Map<String, dynamic> o){
    success=o[keySuccess] ;
    statusCode=o[keyStatusCode] ;
    result=o[keyResult] ;
    results=o[keyResults];
    count=o[keyCount] ;
    error=ResponseError.fromMap(o[keyError]) ;
  }

  @override
  String toString() {
    print(
        "\n ------------- success : " + success.toString()  +
            "\n ------------- statusCode : " + statusCode.toString() +
            "\n --------- result : " + result +
            "\n ------------- results : " + results.toString() +
            "\n ------------- count : " + count.toString() +
            "\n ------------- error : " + error.toString() );
  }


}





class ResponseError {


  ResponseError({this.code = -1,this.message = 'Unknown error',this.technical_message="Unknown error",bool debug = false}) {

    type = exceptions[code];
    if (debug) {
      print(toString());
    }

  }


  // ignore: always_specify_types
  Map<int, String> exceptions = {
    -1: 'UnknownError',

    // SDK errors / Errors
    1: 'No Results',
    2: 'OK',
    400: 'Bad Request',

    // Parse specific / Exceptions
    100: 'ConnectionFailed',
    101: 'ObjectNotFound',
    102: 'InvalidQuery',
    103: 'InvalidClassName',
    104: 'MissingObjectId',
    105: 'InvalidKeyName',
    106: 'InvalidPointer',
    107: 'InvalidJson',
    108: 'CommandUnavailable',
    109: 'NotInitialized',
    111: 'IncorrectType',
    112: 'InvalidChannelName',
    115: 'PushMisconfigured',
    116: 'ObjectTooLarge',
    119: 'OperationForbidden',
    120: 'CacheMiss',
    121: 'InvalidNestedKey',
    122: 'InvalidFileName',
    123: 'InvalidAcl',
    124: 'Timeout',
    125: 'InvalidEmailAddress',
    135: 'MissingRequiredFieldError',
    137: 'DuplicateValue',
    139: 'InvalidRoleName',
    140: 'ExceededQuota',
    141: 'ScriptError',
    142: 'ValidationError',
    153: 'FileDeleteError',
    155: 'RequestLimitExceeded',
    160: 'InvalidEventName',
    200: 'UsernameMissing',
    201: 'PasswordMissing',
    202: 'UsernameTaken',
    203: 'EmailTaken',
    204: 'EmailMissing',
    205: 'EmailNotFound',
    206: 'SessionMissing',
    207: 'MustCreateUserThroughSignUp',
    208: 'AccountAlreadyLinked',
    209: 'InvalidSessionToken',
    250: 'LinkedIdMissing',
    251: 'InvalidLinkedSession',
    252: 'UnsupportedService'
  };

  int code;
  String message;
  String technical_message;
  String type;

  @override
  String toString() {
    String exceptionString = ' \n';
    exceptionString += '----';
    exceptionString += '\nException (Type: $type) :';
    exceptionString += '\nCode: $code';
    exceptionString += '\nMessage: $message';
    exceptionString += '\nTechnical Message: $technical_message';
    exceptionString += '----';
    return exceptionString;
  }


  ResponseError.fromMap(Map o){
    if(o==null)
      return;
    code = o["code"];
    message = o["message"];
    technical_message = o["technical_message"];
  }


}
