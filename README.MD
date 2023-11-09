
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
make create_function FUNCTION_TARGET=CreateItem DIR_NAME=createitem

NOTE : this command will replace an existing function. SO, do it with full attention.
```

- Add Some pkg

```
copy folder name from pkg folder, to .pkg inside your functions directory.

```

- Initial pkg to created Function

```
 make init_local_dependency DIR_NAME=createitem
```

- Running Function Locally

```
make run FUNCTION_TARGET=CreateItem DIR_NAME=createitem

```

- Running Unit Test
```
make run_test  DIR_NAME=createitem

```

- Do Deploy To Gcloud
```
make deploy FUNCTION_TARGET=CreateItem DIR_NAME=createitem

```

## ISSUE

-
