package tests

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"dizcoding.com/kfc"
	"github.com/tj/assert"
)

func TestCreateItem(t *testing.T) {
	urlPath := "localhost:8000"
	payload := `{"name":"Spicy Chicken Medium", "price":25000, "quantity":50}`
	req := httptest.NewRequest(http.MethodPost, urlPath, strings.NewReader(payload))
	req.Header.Add("Content-Type", "application/json")

	rr := httptest.NewRecorder()
	// call function
	kfc.CreateItem(rr, req)

	println(rr.Body.String())
	assert.Equal(t, 200, rr.Result().StatusCode)
}
