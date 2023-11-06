start_firebase_emulators:
	@-lsof -t -i:8080 -i:9000 -i:9099 -i:9199 | xargs kill
	@cd firebase-emulators && firebase emulators:start &


run:
	@-lsof -t -i:8090 | xargs kill
	cd functions/$(shell echo $(NAME) | tr A-Z a-z) \
	&& PORT=8090 \
	HOST_NAME=127.0.0.1 \
	FIRESTORE_EMULATOR_HOST=127.0.0.1:8080 \
	FIREBASE_DATABASE_EMULATOR_HOST=127.0.0.1:9000 \
	FIREBASE_AUTH_EMULATOR_HOST=127.0.0.1:9099 \
	FIREBASE_STORAGE_EMULATOR_HOST=127.0.0.1:9199 \
	FUNCTION_TARGET=$(NAME) \
	go run cmd/main.go

run_test:
	@cd functions/$(shell echo $(NAME) | tr A-Z a-z) \
	&& FIRESTORE_EMULATOR_HOST=127.0.0.1:8080 \
	FIREBASE_DATABASE_EMULATOR_HOST=127.0.0.1:9000 \
	FIREBASE_AUTH_EMULATOR_HOST=127.0.0.1:9099 \
	FIREBASE_STORAGE_EMULATOR_HOST=127.0.0.1:9199 \
	go test -covermode=count -coverpkg=./... -coverprofile coverage.out -v ./tests/...
	@cd functions/$(shell echo $(NAME) | tr A-Z a-z) \
	&&go tool cover -html=coverage.out -o coverage.html
	@echo ""
	@echo ""
	@echo "Show result detail on browser with this link."
	@echo "file://${shell pwd}/functions/$(shell echo $(NAME) | tr A-Z a-z)/tests/coverage.html"

deploy:
	@cd ./functions/$(shell echo $(FUNCTION_TARGET) | tr A-Z a-z) \
	&& gcloud functions deploy $(FUNCTION_TARGET) \
    --gen2 \
    --runtime=go121 \
    --entry-point $(FUNCTION_TARGET) \
    --trigger-http \
	--source=. \
	--allow-unauthenticated \
	$(OTHERS)

create_function: remove_if_exist copy_example rename_example fixing_example_file_function fixing_example_test_file_function fixing_example_main_file_function
	@cd ./functions/$(shell echo $(NAME) | tr A-Z a-z) \
	&& go mod init dizcoding.com/$(shell echo $(NAME) | tr A-Z a-z) \
	&& go mod tidy

remove_if_exist:
	@rm -rf ./functions/$(shell echo $(NAME) | tr A-Z a-z)
	

copy_example:
	@cp -rf ./functions/example ./functions/$(shell echo $(NAME) | tr A-Z a-z)

rename_example:
	@mv ./functions/$(shell echo $(NAME) | tr A-Z a-z)/Example.go ./functions/$(shell echo $(NAME) | tr A-Z a-z)/$(NAME).go 
	@mv ./functions/$(shell echo $(NAME) | tr A-Z a-z)/tests/Example_test.go ./functions/$(shell echo $(NAME) | tr A-Z a-z)/tests/$(NAME)_test.go 

fixing_example_file_function:
	@sed -i '' -e 's/package example/package $(shell echo $(NAME) | tr A-Z a-z)/g' ./functions/$(shell echo $(NAME) | tr A-Z a-z)/$(NAME).go 
	@sed -i '' -e 's/functions.HTTP("Example", Example)/functions.HTTP("$(NAME)", $(NAME))/g' ./functions/$(shell echo $(NAME) | tr A-Z a-z)/$(NAME).go 
	@sed -i '' -e 's/func Example/func $(NAME)/g' ./functions/$(shell echo $(NAME) | tr A-Z a-z)/$(NAME).go 

fixing_example_test_file_function:
	@sed -i '' -e 's/dizcoding.com\/kfc\/functions\/example/dizcoding.com\/$(shell echo $(NAME) | tr A-Z a-z)/g' ./functions/$(shell echo $(NAME) | tr A-Z a-z)/tests/$(NAME)_test.go 
	@sed -i '' -e 's/Example/$(NAME)/g' ./functions/$(shell echo $(NAME) | tr A-Z a-z)/tests/$(NAME)_test.go 
	@sed -i '' -e 's/example/$(shell echo $(NAME) | tr A-Z a-z)/g' ./functions/$(shell echo $(NAME) | tr A-Z a-z)/tests/$(NAME)_test.go 

fixing_example_main_file_function:
	@sed -i '' -e 's/dizcoding.com\/kfc\/functions\/example/dizcoding.com\/$(shell echo $(NAME) | tr A-Z a-z)/g' ./functions/$(shell echo $(NAME) | tr A-Z a-z)/cmd/main.go 
