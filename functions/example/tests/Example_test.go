package tests

import (
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"dizcoding.com/kfc/functions/example"
	"github.com/tj/assert"
)

func TestExample(t *testing.T) {
	urlPath := "localhost:8000"
	payload := `{"name":"Spicy Chicken Medium", "price":25000, "quantity":50}`
	req := httptest.NewRequest(http.MethodPost, urlPath, strings.NewReader(payload))
	req.Header.Add("Content-Type", "application/json")

	rr := httptest.NewRecorder()
	// call function
	example.Example(rr, req)

	println(rr.Body.String())
	assert.Equal(t, 200, rr.Result().StatusCode)
}
