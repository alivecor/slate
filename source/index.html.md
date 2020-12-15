---
title: Kardia API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - shell

toc_footers:

includes:
  - errors

search: true
---

# Introduction

The Kardia API is organized around REST. Our API has predictable resource-oriented URLs, accepts form-encoded request bodies, returns JSON-encoded responses, and uses standard HTTP response codes, authentication, and verbs.

# How it Works

Kardia Pro facilitates a connection between a clinician’s Kardia Pro account and their selected patients. Patients are provisioned with a unique code that connects their Kardia application specifically to their clinician or service and allows all ECG recordings captured via Kardia Mobile to be accessible to the clinician via the Kardia Pro API.

# Authentication

```shell
curl https://api.kardia.com/v1/patients \
  -u YOUR-API-KEY:
# The colon prevents curl from asking for a password.

```
The Kardia API uses API keys to authenticate requests. APIs within the Kardia platform require the use of HTTP Basic Authentication, constructed from a valid API key as the username and empty password combination.


> Example Requests

```shell
# Get your API Key
curl -X POST https://api.kardia.com/v1/apikey \
  -d email=YOUR_EMAIL \
  -d password=YOUR_PASSWORD
```
To access your API Key, send a `POST` request with your Kardia Pro `email` and `password` as url encoded form params to `/v1/apikey`.


```shell
# Generate a new API Key
curl -X POST https://api.kardia.com/v1/apikey/new \
  -u YOUR-API-KEY:
```
> Example Response

```json
{
    "apiKey": "3test974-cd11-48c3-a0dd-621test8test"
}
```
To generate a new API Key, send a `POST` request to `/v1/apikey/new` using your current API Key.

# Base URL

Region | Host
------ | -----------------------
US     | https://api.kardia.com
EU     | https://eu-api.kardia.com


# Patients

### Patient Object

Name       | Type    | Description
---------- | ------- | -----------
id         | string  | The patient's unique random ID
mrn        | string  | The patient's medical record number
dob        | string  | The patient's date of birth
email      | string  | The patient's email address
firstname  | string  | The patient's first name
lastname   | string  | The patient's last name
sex        | int     | The patient's sex as ISO/IEC5218


## Create Patient

> Example Request

```shell
curl https://api.kardia.com/v1/patients \
  -u YOUR-API-KEY: \
  -d mrn=JS-20000721 \
  -d dob=2000-07-21 \
  -d email=joe@example.com \
  -d firstname=Joe \
  -d lastname=Smith \
  -d sex=1
```

> Example Response

```json
{
  "id": "wNSEDeLOEPQE5rznkJmwbnjpxfdst93i",
  "mrn": "JS-20000721",
  "dob": "1970-03-12",
  "email": "joe@example.com",
  "firstname": "Joe",
  "lastname": "Smith",
  "sex": 1
}
```

To create a patient, send a `POST` request to `/v1/patients`.

### Arguments

Name       | Type   | Required | Description
---------  | ------ | ---------| -----------
mrn        | string | Yes      | The patient's medical record number
email      | string | Yes      | The patient's email address
dob        | string | Yes      | The patient's date of birth as YYYY-MM-DD
firstname  | string | No       | The patient's first name
lastname   | string | No       | The patient's last name
sex        | int    | No       | The patient's sex as ISO/IEC 5218


## Get Patient
> Example Request

```shell
curl https://api.kardia.com/v1/patients/wNSEDeLOEPQE5rznkJmwbnjpxfdst93i \
 -u YOUR-API-KEY:
```

> Example Response

```shell
{
  "id": "wNSEDeLOEPQE5rznkJmwbnjpxfdst93i",
  "mrn": "JMJ-19810712",
  "dob": "1970-03-12",
  "email": "joe@example.com",
  "firstname": "Joe",
  "lastname": "Smith",
  "sex": 0
}
```

Responds to `GET` requests to `/v1/patients/:id` and returns a single patient object.


## Delete Patient

> Example Request

```shell
curl -X DELETE https://api.kardia.com/v1/patients/wNSEDeLOEPQE5rznkJmwbnjpxfdst93i \
 -u YOUR-API-KEY:
```

Responds to `DELETE` requests to `/v1/patients/:id`. Successful requests return an HTTP status `202 Accepted`. Developers must request Data Controller access for this functionality.

## Export Patient

> Example Request

```shell
curl https://api.kardia.com/v1/patients/wNSEDeLOEPQE5rznkJmwbnjpxfdst93i/export \
 -u YOUR-API-KEY:
```

Responds to `GET` requests to `/v1/patients/:id/export`. Exports are queued and email sent to the API key owner once the export is ready for download. Returns an HTTP `202 Accepted`on success. Developers must request Data Controller access for this functionality.

## Get Connection Code

> Example Request

```shell
curl https://api.kardia.com/v1/patients/wNSEDeLOEPQE5rznkJmwbnjpxfdst93i/code \
 -u YOUR-API-KEY:
```

> Example Response

```shell
{
  "code": "LQYP-MSAK-NPJR",
  "status": "connected"
}
```

Responds to `GET` requests to `/v1/patients/:id/code` and returns a valid connection code for the given patient and the status of the connection, either `connected` or `pending`.

## Disconnect patient connection

> Example Request

```shell
curl -X POST https://api.kardia.com/v1/patients/wNSEDeLOEPQE5rznkJmwbnjpxfdst93i/disconnect \
 -u YOUR-API-KEY:
```

> Example Response

```shell
{}
```

Responds to `POST` requests to `/v1/patients/:id/disconnect` and terminates a patient's connection. Returns an empty response if successful.

## Get Patient Recordings

> Example Request

```shell
curl https://api.kardia.com/v1/patients/wNSEDeLOEPQE5rznkJmwbnjpxfdst93i/recordings \
 -u YOUR-API-KEY:
```

> Example Response

```shell
{
  "totalCount": 200,
  "recordings": [
    {
      "id": "3wde1eem9vy4y1a0rv3y98u2a",
      "patientID": "wNSEDeLOEPQE5rznkJmwbnjpxfdst93i",
      "duration": 30000,
      "heartRate": 65,  
      "note": "Drank coffee, having palpitations.",
      "recordedAt": "2008-09-15T15:53:00+05:00",
      "tags": ["Low sleep", "At doctors office"]
    }
  ],
  "pageInfo": {
    "startCursor": "c3RhcnRDdXJzb3I=",
    "endCursor": "ZW5kQ3Vyc29yc2Rh=",
    "hasNextPage": true
  }
}
```

Responds to `GET` requests to `/v1/patients/:id/recordings` and returns an array of ECG recordings for the given patient.

**Querystring parameters**

`limit` A limit on the number of objects to be returned. Limit can range between 1 and 500, and the default is 100.

`start` The cursor used to return recordings after the `startCursor` or `endCursor` cursor, and returning at most `limit` recordings.

### Recordings Object

Name        | Type    | Description
----------- | ------- | -----------
totalCount  | int     | The total number of patients
recordings  | array   | An array of recording data
pageInfo    | object  | Pagination information

### Page Info Object

Name        | Type    | Description
----------- | ------- | -----------
startCursor | string  | The cursor for the first recording in the page
endCursor   | string  | the cursor for the last recording in the page
hasNextPage | bool    | True if there is another page of data

## Get All Patients

> Example Request

```shell
curl https://api.kardia.com/v1/patients?limit=50&start=ZW5kQ3Vyc29yc2Rh= \
  -u YOUR-API-KEY:
```

> Example Response

```shell
{
  "totalCount": 200,
    "patients": [{
      "id": "wNSEDeLOEPQE5rznkJmwbnjpxfdst93i",
      "mrn": "JS-19810712",
      "dob": "1970-03-12",
      "email": "joe@example.com",
      "firstname": "Joe",
      "lastname": "Smith",
      "sex": 0
    }],
    "pageInfo": {
      "startCursor": "c3RhcnRDdXJzb3I=",
      "endCursor": "ZW5kQ3Vyc29yc2Rh=",
      "hasNextPage": true
    }
}
```

Responds to `GET` requests to `/v1/patients` and returns a list of patients with the most recent created patient first.

**Querystring parameters**

`limit` A limit on the number of objects to be returned. Limit can range between 1 and 500, and the default is 100.

`start` The cursor used to return patients after the `startCursor` or `endCursor` cursor, and returning at most `limit` patients.

### Patients Object

Name        | Type    | Description
----------- | ------- | -----------
totalCount  | int     | The total number of patients
patients    | array   | An array of `Patient` objects
pageInfo    | object  | Pagination information

### Page Info Object

Name        | Type    | Description
----------- | ------- | -----------
startCursor | string  | The cursor for the first patient in the page
endCursor   | string  | the cursor for the last patient in the page
hasNextPage | bool    | True if there is another page of data

# ECG Recordings

## ECG Object

Name                   | Type    | Description
---------------------- | ------- | -----------
id                     | string  | The patient's unique random ID
patientID              | string  | The unique patient identifier
duration               | int     | The duration of the ECG recording in milliseconds
heartRate              | int     | The average heart rate
note                   | string  | The patient supplied note associated with the ECG
algorithmDetermination | string  | Represents the output of the AliveCor ECG algorithms, the allowable values are `normal`, `afib`, `unclassified`, `bradycardia`, `tachycardia`, `too_short`, `too_long`, `unreadable`, and `no_analysis`
data                   | object  | The raw and enhanced filterred ECG data samples
recordedAt             | string  | The date time the ECG was recorded

## ECG Data Object

Name                | Type   | Description
------------------- | ------ | -----------
frequency           | int    | The frequency in hertz of the ECG recording, i.e. 300Hz
mainsFrequency      | int    | The mains frequency either 50 (e.g. Europe) or 60 (e.g. America) Hz.
amplitudeResolution | int  | The number of nanovolts corresponding to each sample unit.
samples             | object | The ECG data samples

## ECG Samples Object

Name      | Type    | Description
--------- | ------- | -----------
leadI     | array   | The Lead 1 data samples at the specified sampling frequency, in ADC units. To convert to millivolts, divide these samples by (1e6 / amplitudeResolution).

## Single ECG

> Example Request

```shell
curl https://api.kardia.com/v1/recordings/3wde1eem9vy4y1a0rv3y98u2a \
  -u YOUR-API-KEY:
```

> Example Response

```shell
{
  "id": "3wde1eem9vy4y1a0rv3y98u2a",
  "patientID": "wNSEDeLOEPQE5rznkJmwbnjpxfdst93i",
  "algorithmDetermination": "normal",
  "duration": 30000,
  "heartRate": 65,  
  "note": "Drank coffee, having palpitations.",
  "tags": ["Low sleep", "At doctors office"],
  "recordedAt": "2008-09-15T15:53:00+05:00",
  "data": {
    "raw": {
      "frequency": 300,
      "mains_freq": 60,
      "samples": {
        "leadI": [
          397,
          -262,
          -426,
          -284,
          286,
          391,
          -45,
          -249,
          -30,
          566,
          515,
          204,
          -138,
          -30,
          491,
          572,
          103,
          -187,
          -62,
          322,
          ...     
        ],
        "leadII": [...],
        "leadIII": [...],
        "AVR": [...],
        "AVL": [...],
        "AVF": [...]
      },
      "numLeads": 6
    },
    "enhanced": {
      "frequency": 300,
      "mains_freq": 60,
      "samples": {
        "lead_I": [
          397,
          -262,
          -426,
          -284,
          286,
          391,
          -45,
          -249,
          -30,
          566,
          515,
          204,
          -138,
          -30,
          491,
          572,
          103,
          -187,
          -62,
          322,
          ...     
        ],
        "leadII": [...],
        "leadIII": [...],
        "AVR": [...],
        "AVL": [...],
        "AVF": [...]
      },
      "numLeads": 6
    }
  }
}
```

To get a single ECG for a given patient send a `GET` request to `/v1/recordings/:id`

## Single ECG PDF

> Example Request

```shell
curl https://api.kardia.com/v1/recordings/3wde1eem9vy4y1a0rv3y98u2a.pdf \
  -u 7863674b-1919-432b-90d5-838fb8207d3f:
```

To get a single ECG PDF for a given patient send a `GET` request to `/v1/recordings/:id.pdf`

## Get All Recordings

> Example Request

```shell
curl https://api.kardia.com/v1/recordings \
 -u 7863674b-1919-432b-90d5-838fb8207d3f:
```

> Example Response

```shell
{
  "totalCount": 200,
   "recordings": [{
      "id": "3wde1eem9vy4y1a0rv3y98u2a",
      "patientID": "wNSEDeLOEPQE5rznkJmwbnjpxfdst93i",
      "algorithmDetermination": "normal",
      "duration": 30000,
      "heartRate": 65,  
      "note": "Drank coffee, having palpitations.",
      "recordedAt": "2008-09-15T15:53:00+05:00",
      "tags": ["Low sleep", "At doctors office"]
  }],
  "pageInfo": {
    "startCursor": "c3RhcnRDdXJzb3I=",
    "endCursor": "ZW5kQ3Vyc29yc2Rh=",
    "hasNextPage": true
  }
}
```

Responds to `GET` requests to `/v1/recordings` and returns an array of ECG's across all patients taken in the Kardia Mobile App. This will not include screening station recordings.

**Querystring parameters**

`limit` A limit on the number of objects to be returned. Limit can range between 1 and 500, and the default is 100.

`start` The cursor used to return recordings after the `startCursor` or `endCursor` cursor, and returning at most `limit` recordings.

## Get All Screening Station Recordings

> Example Request

```shell
curl https://api.kardia.com/v1/screening/recordings \
 -u 7863674b-1919-432b-90d5-838fb8207d3f:
```

> Example Response

```shell
{
  "totalCount": 200,
   "recordings": [{
      "id": "3wde1eem9vy4y1a0rv3y98u2a",
      "patientID": "wNSEDeLOEPQE5rznkJmwbnjpxfdst93i",
      "algorithmDetermination": "normal",
      "duration": 30000,
      "heartRate": 65,  
      "note": "Drank coffee, having palpitations.",
      "tags": ["Low sleep", "At doctors office"],
      "recordedAt": "2008-09-15T15:53:00+05:00"
  }],
  "pageInfo": {
    "startCursor": "c3RhcnRDdXJzb3I=",
    "endCursor": "ZW5kQ3Vyc29yc2Rh=",
    "hasNextPage": true
  }
}
```

Responds to `GET` requests to `/v1/screening/recordings` and returns an array of ECG's taken at Kardia Screening Stations.

**Querystring parameters**

`limit` A limit on the number of objects to be returned. Limit can range between 1 and 500, and the default is 100.

`start` The cursor used to return recordings after the `startCursor` or `endCursor` cursor, and returning at most `limit` recordings.

## Set QT Analysis Measurements

> Example Request

```shell
curl --request POST https://api.kardia.com/v1/recordings/3wde1eem9vy4y1a0rv3y98u2a/qt \
 -u 7863674b-1919-432b-90d5-838fb8207d3f: \
 --header 'Content-Type: application/json' \
 --data '{"qt": 1.45,"rr": 1.21,"qtcb": -5.12,"qtcf": 145, "error": "any error message", "errorType": "poorQuality"}'
```

> Example Response

```json
{
    "recordingID": "3wde1eem9vy4y1a0rv3y98u2a",
    "qt": 1.45,
    "rr": 1.21,
    "qtcb": -5.12,
    "qtcf": 145,
    "measurementID": "IOyFM8PTUW7DEw2UAircc1pfvsh2rxdd",
    "error": "any error message",
    "errorType": "poorQuality"    
}
```
Responds to `POST` requests to `/v1/recordings/:recordingId/qt` and returns the created qt measurement object.
A qt measurement may contain an optional error message, which will require an errorType if an error message
is specified. Valid error types are ```poorQuality```, ```undeterminedRhythm```, and ```other```

## Recordings Object

Name        | Type    | Description
----------- | ------- | -----------
totalCount  | int     | The total number of recordings
recordings  | array   | An array of recording data
pageInfo    | object  | Pagination information
startCursor | string  | The cursor for the first recording in the page
endCursor   | string  | the cursor for the last recording in the page
hasNextPage | bool    | True if there is another page of data



# Kardia Mobile Users

## Create User

> Example Request

```shell
curl https://api.kardia.com/v1/users \
  -u YOUR-API-KEY: \
  -d email=joe@example.com \
  -d password=5up3R53Cur3 \
  -d countryCode=us \
  -d patientId=wNSEDeLOEPQE5rznkJmwbnjpxfdst93i
```

> Example Response

```json
{
  "requestId": "q1ATFmh7OShS2Dmd1cVAb6boqkrp7gif",
}
```

The API allows developers to create Kardia Mobile users that will be automatically connected to the Kardia Pro account. To create a Kardia Mobile user, send a `POST` request to `/v1/users`.

### Arguments

Name        | Type   | Required | Description
----------  | ------ | ---------| -----------
email       | string | Yes      | The Kardia Mobile user's email address.
password    | string | Yes      | The Kardia Mobile user's password
countryCode | string | Yes      | The ISO 3166 Alpha-2 country code
patientId   | string | Yes      | The patient's unique identifier.


# Webhooks

Webhooks are a system of automated notifications indicating that an event has occurred for your team. Rather than requiring you to pull information via our API, webhooks push information to your destination when important events occur. Webhooks notify the following events.

* New recordings
* Patient connections
* Patient disconnects
* New QT Analysis Requests

The Kardia server will send a post to your set url with the following body:
> Example Body

```json
{
  "eventType":   "qtAnalysis",
  "recordingId": "123recordingIDTest",
}
```

## Set callback URL

> Example Request

```shell
curl -X PUT https://api.kardia.com/v1/callback \
  -u YOUR-API-KEY: \
  -d url=https://www.example.com/webhooks
```

> Example Response

```json
{
  "url": "https://www.example.com/webhooks",
}
```

Lets you assign a callback URL for POST notifications. Make sure to assign a publicly accessible URL for your callback service. Responds to `PUT` requests to `/v1/callback`.

## Get callback URL

> Example Request

```shell
curl https://api.kardia.com/v1/callback \
  -u YOUR-API-KEY:
```

> Example Response

```json
{
  "url": "https://www.example.com/webhooks",
}
```

## Callback JSON examples

> Participant connected to a team

```json
{
    "eventType": "participantConnected",
    "customParticipantId": "mrn123",
    "patientId": "patientid123"
}
```

> Participant disconnected from a team

```json
{
    "eventType": "participantDisconnected",
    "customParticipantId": "mrn123",
    "patientId": "patientid123"
}
```

> New recording made by patient

```json
{
    "eventType":   "newRecording",
    "recordingId": "recordingid123",
    "patientId": "patientid123"
}
```

> Stack updated based on an automatic "trigger" or "manual" action

```json
{
	"eventType": "recordingInboxUpdated",
	"memberId": "memberid123",
	"action": "trigger"
}
```

This section provides examples of JSON request bodies that are sent to the callback URL from Alivecor backend when the described events take place

## Set QT Analysis Callback URL

> Example Request

```shell
curl -X PUT https://api.kardia.com/v1/qtCallback \
  -u YOUR-API-KEY: \
  -d url=https://www.example.com/webhooks
```

> Example Response

```json
{
  "url": "https://www.example.com/webhooks",
}
```

Lets you assign a callback URL for POST notifications. Make sure to assign a publicly accessible URL for your callback service. Responds to `PUT` requests to `/v1/qtCallback`.

## Get QT Analysis Callback URL

> Example Request

```shell
curl https://api.kardia.com/v1/qtCallback \
  -u YOUR-API-KEY:
```

> Example Response

```json
{
  "url": "https://www.example.com/webhooks",
}
```

## QT callback JSON example

> QT analysis complete

```json
{
    "eventType": "qtAnalysis",
    "recordingId": "recordingID123",
}
```

This section provides examples of JSON request bodies that are sent to the QT callback URL from Alivecor backend when the described events take place

## Get callback logs

> Example Request

```shell
curl https://api.kardia.com/v1/logs \
  -u YOUR-API-KEY:
```

> Example Response

```json
{
    "totalCount": 2,
    "logs": [
        {
            "statusCode": "500",
            "eventType": "newRecording",
            "createdAt": "2019-05-13T00:00:01Z",
            "error": "Failed to send new recording to callback url"
        },
        {
            "statusCode": "200",
            "eventType": "newRecording",
            "createdAt": "2019-05-13T00:00:00Z"
        }
    ],
    "pageInfo": {
        "startCursor": "Y3Vyc29yMjAxOS0wNS0xM1QwMDowMDowMVo=",
        "endCursor": "Y3Vyc29yMjAxOS0wNS0xM1QwMDowMDowMFo=",
        "hasNextPage": false
    }
}
```

Returns a paged list of logs. Send a `GET` request to `/v1/logs`.

**Querystring parameters**

`limit` A limit on the number of objects to be returned. Limit can range between 1 and 500, and the default is 100.

`start` The cursor used to return logs after the `startCursor` or `endCursor` cursor, and returning at most `limit` logs..
