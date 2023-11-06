package example

import (
	"encoding/json"
	"log"
	"net/http"

	firebase "firebase.google.com/go"
	"github.com/GoogleCloudPlatform/functions-framework-go/functions"
	"golang.org/x/net/context"
)

type Item struct {
	Name     string `json:name`
	Price    int    `json:price`
	Quantity int    `json:quantity`
}

func init() {
	functions.HTTP("Example", Example)
}

func Example(w http.ResponseWriter, r *http.Request) {
	// Use a service account
	conf := &firebase.Config{ProjectID: "dev-nkc"}
	ctx := context.Background()

	// Init firebase account
	app, err := firebase.NewApp(ctx, conf)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
		log.Println(err.Error())
		return
	}

	// Init firebase client
	fireStoreClient, err := app.Firestore(ctx)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
		log.Println(err.Error())
		return
	}

	// Defer close
	defer fireStoreClient.Close()

	var item Item
	if err := json.NewDecoder(r.Body).Decode(&item); err != nil {
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte(err.Error()))
		log.Println(err.Error())
		return
	}

	// Create new docs
	_, _, err = fireStoreClient.Collection("Product_Items").Add(ctx, item)

	// Handle error create new docs
	if err != nil {
		// Handle any errors in an appropriate way, such as returning them.
		log.Printf("Error gan: %s", err)
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
		log.Println(err.Error())
		return
	}

	// Marshal JSON
	itemBytes, err := json.Marshal(item)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte(err.Error()))
		log.Println(err.Error())
		return
	}

	// Success
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(itemBytes))
	return
}
