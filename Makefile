start_firebase_emulators:
	-lsof -t -i:8080 -i:9000 -i:9099 -i:9199 | xargs kill
	cd firebase-emulators && firebase emulators:start

run:
	-lsof -t -i:8000 | xargs kill
	FIRESTORE_EMULATOR_HOST=127.0.0.1:8080 \
	FIREBASE_DATABASE_EMULATOR_HOST=127.0.0.1:9000 \
	FIREBASE_AUTH_EMULATOR_HOST=127.0.0.1:9099 \
	FIREBASE_STORAGE_EMULATOR_HOST=127.0.0.1:9199 \
	FUNCTION_TARGET=$(FUNCTION_TARGET) LOCAL_ONLY=true go run cmd/main.go

run_test:
	FIRESTORE_EMULATOR_HOST=127.0.0.1:8080 \
	FIREBASE_DATABASE_EMULATOR_HOST=127.0.0.1:9000 \
	FIREBASE_AUTH_EMULATOR_HOST=127.0.0.1:9099 \
	FIREBASE_STORAGE_EMULATOR_HOST=127.0.0.1:9199 \
	go test -covermode=count -coverpkg=./... -coverprofile coverage.out -v ./tests/...

deploy:
	-rm -rf release_candidate/
	-mkdir release_candidate
	-cp -rf go.mod ./release_candidate
	-cp -rf $(FUNCTION_TARGET).go ./release_candidate/function.go
	gcloud functions deploy $(FUNCTION_TARGET) \
    --gen2 \
    --runtime=go121 \
    --entry-point $(FUNCTION_TARGET) \
    --trigger-http \
	--source=./release_candidate \
	--allow-unauthenticated \
	$(OTHERS)
	-rm -rf release_candidate/