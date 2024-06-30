// env.dart

import 'package:flutter/foundation.dart';

const stripe_env = 'test';



const publishableKey = 'pk_live_51Imq0HKSkIRE2FaD4P8yhQipFZVdn8qM3YishoP8sJUWl20qR0wr5srhBUp2LevOXtVJG3eqP2oXVsquX5CiwZxN00eYwGLJ9g';
const secretKey = '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';

const test_publishableKey = 'pk_test_51Imq0HKSkIRE2FaD1KvHqLid3c3tREWjKzCB1c1ycsuYP8QoahFXlbqbp4Be3y7SPTvjshOsSBO041VnrE9inwr400SSQT6TDs';
const test_secretKey = 'sk_test_51Imq0HKSkIRE2FaDse1NDWhLyRI2uXlHSBvXiyWoAg8UzBnvMKb7fVBXKrAmcDHmO53aj7rSRKsv14knaaIOSNPO00C72XjyrJ';


const my_test_publishableKey = 'pk_test_U0J5xXlOOdXWHzPLCwhAke9P';
const my_test_secretKey = 'sk_test_aNeMEakOWucF0iRSpekM4mZc';



String getPublishableKey() {
  if (kDebugMode) {
    return my_test_publishableKey; // or test_publishableKey, based on your preference
  }
  return publishableKey;
}

String getSecretKey() {
  if (kDebugMode) {
    return my_test_secretKey; // or test_secretKey, based on your preference
  }
  return secretKey;
}