
# Sample Golang Cloud Function



A Sample for writing an Google Cloud Function with Go Language

## Features

- Firebase Emulator
```
-> Firestore Emulator using default port : 8080 (HAS TESTED)
-> Database Emulator using default port : 9000
-> Auth Emulator using default port : 9099
-> Storage Emulator using default port : 9199

```
- Easy Deploy
- Easy Local Test
- Easy Unit Test

## Usage

- Running Firebase emulator
```
make start_firebase_emulators

```

- Running Function Locally

```
make run FUNCTION_TARGET=CreateItem

```

- Running Unit Test
```
make run_test

```

- Do Deploy To Gcloud
```
make deploy FUNCTION_TARGET=CreateItem

```

## ISSUE

- Only Can running ONE function on same time.
- Need Refactor Folder Structure