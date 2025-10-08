package testhelpers

import (
	"context"
	"fmt"
	"os"
	"testing"

	"github.com/docker/go-connections/nat"
	"github.com/stretchr/testify/require"
	"github.com/testcontainers/testcontainers-go"
	"github.com/testcontainers/testcontainers-go/wait"
)

// GetTestImage returns the image to test from TEST_IMAGE env var or falls back to the default
func GetTestImage(defaultImage string) string {
	image := os.Getenv("TEST_IMAGE")
	if image == "" {
		return defaultImage
	}
	return image
}

// HTTPTestConfig holds the configuration for HTTP endpoint tests
type HTTPTestConfig struct {
	Port       string
	Path       string
	StatusCode int
}

// TestHTTPEndpoint tests that an HTTP endpoint is accessible and returns the expected status code
func TestHTTPEndpoint(t *testing.T, ctx context.Context, image string, config HTTPTestConfig) {
	t.Helper()

	if config.Path == "" {
		config.Path = "/"
	}
	if config.StatusCode == 0 {
		config.StatusCode = 200
	}

	portStr := config.Port + "/tcp"
	portTCP := nat.Port(portStr)

	app, err := testcontainers.Run(
		ctx, image,
		testcontainers.WithExposedPorts(portStr),
		testcontainers.WithWaitStrategy(
			wait.ForListeningPort(portTCP),
			wait.ForHTTP(config.Path).WithPort(portTCP).WithStatusCodeMatcher(func(status int) bool {
				return status == config.StatusCode
			}),
		),
	)
	testcontainers.CleanupContainer(t, app)
	require.NoError(t, err)
}

// TestFileExists tests that a file exists in the container
func TestFileExists(t *testing.T, ctx context.Context, image string, filePath string) {
	t.Helper()

	container, err := testcontainers.Run(
		ctx, image,
		testcontainers.WithEntrypoint("test"),
		testcontainers.WithEntrypointArgs("-f", filePath),
		testcontainers.WithWaitStrategy(wait.ForExit()),
	)
	testcontainers.CleanupContainer(t, container)
	require.NoError(t, err)

	// Check the exit code
	state, err := container.State(ctx)
	require.NoError(t, err)
	require.Equal(t, 0, state.ExitCode, fmt.Sprintf("file %s should exist", filePath))
}

// TestFilesExist tests that multiple files exist in the container
func TestFilesExist(t *testing.T, ctx context.Context, image string, filePaths []string) {
	t.Helper()

	for _, filePath := range filePaths {
		t.Run(fmt.Sprintf("Check %s exists", filePath), func(t *testing.T) {
			TestFileExists(t, ctx, image, filePath)
		})
	}
}
