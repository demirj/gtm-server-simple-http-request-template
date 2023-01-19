___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Simple HTTP Request",
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "Make a HTTP Request with Body and Headers to any Endpoint.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "SELECT",
    "name": "method",
    "displayName": "HTTP Method",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "GET",
        "displayValue": "GET"
      },
      {
        "value": "POST",
        "displayValue": "POST"
      }
    ],
    "simpleValueType": true,
    "help": "Please choose a http methode (GET or POST)."
  },
  {
    "type": "TEXT",
    "name": "endpoint",
    "displayName": "Please set the Request-URL (required).",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "REGEX",
        "args": [
          "^(http:\\/\\/|https:\\/\\/)(.*)"
        ]
      }
    ],
    "help": "You must specify this field with a Request URL starting with the HTTP protocol."
  },
  {
    "type": "TEXT",
    "name": "timeout",
    "displayName": "Set the timeout (optional).",
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "POSITIVE_NUMBER"
      }
    ],
    "help": "The timeout, in milliseconds, before the request is aborted. Defaults to 15000."
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "postBody",
    "displayName": "Set the Key/Value-Pairs for the body.",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "Key",
        "name": "key",
        "type": "TEXT"
      },
      {
        "defaultValue": "",
        "displayName": "Value",
        "name": "value",
        "type": "TEXT"
      }
    ]
  },
  {
    "type": "SIMPLE_TABLE",
    "name": "postHeaders",
    "displayName": "Set the HTTP Headers for the request.",
    "simpleTableColumns": [
      {
        "defaultValue": "",
        "displayName": "Key",
        "name": "key",
        "type": "TEXT"
      },
      {
        "defaultValue": "",
        "displayName": "Value",
        "name": "value",
        "type": "TEXT"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_SERVER___

const sendHttpRequest = require('sendHttpRequest');
const setResponseBody = require('setResponseBody');
const setResponseHeader = require('setResponseHeader');
const setResponseStatus = require('setResponseStatus');

const method = data.method;
const timeout = data.timeout;
const endpoint = data.endpoint;
const inputBody = data.postBody;
const inputHeaders = data.postHeaders; 

let httpBodyString = '';
let httpHeaders = {};

if (inputBody) {
inputBody.forEach((obj, index) => {
  if (index === inputBody.length - 1) {
    httpBodyString += obj.key + '=' + obj.value;
  } else {
    httpBodyString += obj.key + '=' + obj.value  + '&';
  }
});
} else {
  httpBodyString = null;
}

if (inputHeaders) {
inputHeaders.forEach((obj) => {
  httpHeaders[obj.key] = obj.value;
});
}

sendHttpRequest(endpoint, {
  headers: httpHeaders || null,
  method: method,
  timeout: timeout || 15000,
}, httpBodyString).then((result) => {
  setResponseStatus(result.statusCode);
  setResponseBody(result.body);
  setResponseHeader('cache-control', result.headers['cache-control']);
});

data.gtmOnSuccess();


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_response",
        "versionId": "1"
      },
      "param": [
        {
          "key": "writeResponseAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        },
        {
          "key": "writeHeaderAccess",
          "value": {
            "type": 1,
            "string": "specific"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "send_http",
        "versionId": "1"
      },
      "param": [
        {
          "key": "allowedUrls",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 19.1.2023, 15:49:01


