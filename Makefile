start_firebase_emulators:
	@-lsof -t -i:8080 -i:9000 -i:9099 -i:9199 | xargs kill
	@cd firebase-emulators && firebase emulators:start &


run:
	@-lsof -t -i:8090 | xargs kill
	cd functions/$(DIR_NAME) \
	&& PORT=8090 \
	HOST_NAME=127.0.0.1 \
	FIRESTORE_EMULATOR_HOST=127.0.0.1:8080 \
	FIREBASE_DATABASE_EMULATOR_HOST=127.0.0.1:9000 \
	FIREBASE_AUTH_EMULATOR_HOST=127.0.0.1:9099 \
	FIREBASE_STORAGE_EMULATOR_HOST=127.0.0.1:9199 \
	FUNCTION_TARGET=$(FUNCTION_TARGET) \
	go run cmd/main.go

run_test:
	@cd functions/$(DIR_NAME) \
	&& FIRESTORE_EMULATOR_HOST=127.0.0.1:8080 \
	FIREBASE_DATABASE_EMULATOR_HOST=127.0.0.1:9000 \
	FIREBASE_AUTH_EMULATOR_HOST=127.0.0.1:9099 \
	FIREBASE_STORAGE_EMULATOR_HOST=127.0.0.1:9199 \
	go test -covermode=count -coverpkg=./... -coverprofile coverage.out -v ./tests/...
	@cd functions/$(DIR_NAME) \
	&&go tool cover -html=coverage.out -o coverage.html
	@echo ""
	@echo ""
	@echo "Show result detail on browser with this link."
	@echo "file://${shell pwd}/functions/$(DIR_NAME)/tests/coverage.html"

deploy:
	@cd ./functions/$(DIR_NAME) \
	&& gcloud functions deploy $(FUNCTION_TARGET) \
    --gen2 \
    --runtime=go121 \
    --entry-point $(FUNCTION_TARGET) \
    --trigger-http \
	--source=. \
	--allow-unauthenticated \
	$(OTHERS)

init_local_dependency:
	@rm -rf ./functions/$(DIR_NAME)/pkg
	@mkdir ./functions/$(DIR_NAME)/pkg
	@while read line || [ -n "$$line" ]; do cp -rf ./pkg/$$file ./functions/$(DIR_NAME)/pkg; done < ./functions/$(DIR_NAME)/.pkg

create_function: remove_if_exist copy_example rename_example fixing_example_file_function fixing_example_test_file_function fixing_example_main_file_function
	@cd ./functions/$(DIR_NAME) \
	&& go mod init dizcoding.com/$(DIR_NAME) \
	&& go mod tidy

remove_if_exist:
	@rm -rf ./functions/$(DIR_NAME)
	

copy_example:
	@cp -rf ./functions/example ./functions/$(DIR_NAME)

rename_example:
	@mv ./functions/$(DIR_NAME)/Example.go ./functions/$(DIR_NAME)/$(FUNCTION_TARGET).go 
	@mv ./functions/$(DIR_NAME)/tests/Example_test.go ./functions/$(DIR_NAME)/tests/$(FUNCTION_TARGET)_test.go 

fixing_example_file_function:
	@sed -i '' -e 's/package example/package $(DIR_NAME)/g' ./functions/$(DIR_NAME)/$(FUNCTION_TARGET).go 
	@sed -i '' -e 's/functions.HTTP("Example", Example)/functions.HTTP("$(FUNCTION_TARGET)", $(FUNCTION_TARGET))/g' ./functions/$(DIR_NAME)/$(FUNCTION_TARGET).go 
	@sed -i '' -e 's/func Example/func $(FUNCTION_TARGET)/g' ./functions/$(DIR_NAME)/$(FUNCTION_TARGET).go 

fixing_example_test_file_function:
	@sed -i '' -e 's/dizcoding.com\/kfc\/functions\/example/dizcoding.com\/$(DIR_NAME)/g' ./functions/$(DIR_NAME)/tests/$(FUNCTION_TARGET)_test.go 
	@sed -i '' -e 's/Example/$(FUNCTION_TARGET)/g' ./functions/$(DIR_NAME)/tests/$(FUNCTION_TARGET)_test.go 
	@sed -i '' -e 's/example/$(DIR_NAME)/g' ./functions/$(DIR_NAME)/tests/$(FUNCTION_TARGET)_test.go 

fixing_example_main_file_function:
	@sed -i '' -e 's/dizcoding.com\/kfc\/functions\/example/dizcoding.com\/$(DIR_NAME)/g' ./functions/$(DIR_NAME)/cmd/main.go 
