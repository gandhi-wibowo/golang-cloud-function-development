
# Sample Golang Cloud Function



A Sample for writing an Google Cloud Function with Go Language.
One function will be considered as One service, so every single function will have go.mod, go.sum it self

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
- Easy Create New Function

## Usage

- Running Firebase emulator
```
make start_firebase_emulators

```

- Create New Function

```
make create_function NAME=CreateItem

NOTE : this command will replace an existing function. SO, do it with full attention.
```

- Running Function Locally

```
make run NAME=CreateItem

```

- Running Unit Test
```
make run_test  NAME=CreateItem

```

- Do Deploy To Gcloud
```
make deploy FUNCTION_TARGET=CreateItem

```

## ISSUE

- How to handle, when multiple function use an common function. ie : string validation
