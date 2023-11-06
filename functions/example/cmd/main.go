package main

import (
	"log"
	"os"

	// Blank-import the function package so the init() runs
	_ "dizcoding.com/kfc/functions/example"
	"github.com/GoogleCloudPlatform/functions-framework-go/funcframework"
)

func main() {
	if err := funcframework.StartHostPort(os.Getenv("HOST_NAME"), os.Getenv("PORT")); err != nil {
		log.Fatalf("funcframework.StartHostPort: %v\n", err)
	}
}
