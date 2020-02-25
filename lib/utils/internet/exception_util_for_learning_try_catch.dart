import 'dart:io';



/*
*
 * Created by Hamid on 12/3/2017.

*/





//region for learning exception and





class OutOfLlamasException {

}

void misbehave() {

    //https://dart.dev/guides/language/language-tour#exceptions


//    throw 'Out of llamas!';


    try {
        int c=0;
    } on OutOfLlamasException {
        // A specific exception
        //buyMoreLlamas();
    } on Exception catch (e) {
        // Anything else that is an exception
        print('Unknown exception: $e');
    } catch (e) {
        // No specified type, handles all
        print('Something really unknown: $e');
    }



    try {
        dynamic foo = true;
        print(foo++); // Runtime error
    } catch (e) {
        print('misbehave() partially handled ${e.runtimeType}.');
        rethrow; // Allow callers to see the exception.
    }
}

void main() {
    try {
        misbehave();
    } catch (e) {
        print('main() finished handling ${e.runtimeType}.');
    }
}



//endregion

