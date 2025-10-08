package main

import (
	"context"
	"testing"

	"github.com/bjw-s-labs/container-images/testhelpers"
)

func Test(t *testing.T) {
	ctx := context.Background()
	image := testhelpers.GetTestImage("ghcr.io/bjw-s-labs/kepubify:rolling")

	testhelpers.TestFilesExist(t, ctx, image, []string{
		"/app/kepubify",
	})
}
