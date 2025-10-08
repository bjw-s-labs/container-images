package main

import (
	"context"
	"testing"

	"github.com/bjw-s-labs/container-images/testhelpers"
)

func Test(t *testing.T) {
	ctx := context.Background()
	image := testhelpers.GetTestImage("ghcr.io/bjw-s-labs/gluetun-qb-port-sync:rolling")

	testhelpers.TestFilesExist(t, ctx, image, []string{
		"/app/script.sh",
	})
}
