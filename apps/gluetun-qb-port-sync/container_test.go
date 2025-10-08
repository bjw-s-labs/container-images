package main

import (
	"context"
	"testing"

	"github.com/bjw-s-labs/container-images/testhelpers"
)

func Test(t *testing.T) {
	ctx := context.Background()
	image := testhelpers.GetTestImage("ghcr.io/bjw-s-labs/gluetun-qb-port-sync:rolling")

	t.Run("Check /app/script.sh exists", func(t *testing.T) {
		testhelpers.TestFileExists(t, ctx, image, "/app/script.sh")
	})
}
