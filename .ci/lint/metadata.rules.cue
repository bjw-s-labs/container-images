#Spec: {
    app:  #AcceptableAppName
    base: bool
    semantic_versioning: bool
    channels: [...#Channels]
}

#Channels: {
    name: #NonEmptyString
    platforms: [...#AcceptedPlatforms]
    stable: bool
    tests: {
        enabled: bool
        type?:   =~"^(cli|web)$"
    }
}

#NonEmptyString:           string & !=""
#AcceptableAppName:        string & !="" & =~"^[a-zA-Z0-9_\\-]+$"
#AcceptableChannelName:    string & !="" & =~"^[a-zA-Z0-9_\\-\\.]+$"
#AcceptedPlatforms:        "linux/amd64" | "linux/arm64" | "linux/arm/v7"
