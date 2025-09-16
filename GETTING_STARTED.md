# Getting Started

This document provides an overview of the layout of **KernelSwiftUtilities** and describes the purpose of its main Swift libraries.

## Repository Layout

The package uses Swift Package Manager and is organised under the `Sources` and `Tests` directories:

- **Sources/** – contains all Swift packages and executable targets.  Each major library lives in its own subfolder (for example `KernelSwiftCommon` or `KernelSwiftServer`).  Additional directories such as `Demos` and `TerminalApps` hold example applications built on top of the libraries.
- **Tests/** – contains test suites for the packages.
- **Package.swift** – defines the Swift packages and their dependencies.

The key libraries within the package are:

1. `KernelSwiftCommon`
2. `KernelSwiftApplePlatforms`
3. `KernelSwiftServer`
4. `KernelSwiftTerminal`

Thin wrappers `KernelSwiftIOS` and `KernelSwiftMacOS` expose `KernelSwiftApplePlatforms` with appropriate platform settings.

Below is a high‑level description of each library.

## KernelSwiftCommon

This target provides foundation utilities and shared functionality used by the rest of the codebase. It is made up of many focused helpers grouped into subdirectories. Key areas include:

- `Allocator/` – allocation helpers
- `AuthModel/` – authentication models
- `Barcode/` – barcode generation/reading
- `Caches/` – caching strategies
- `CasePath/` – utilities for working with enum cases
- `Coding/` – Codables and encoders/decoders
- `Color/` – color types and conversions
- `Concurrency/` – concurrency primitives
- `Cryptography/` – cryptographic utilities
- `Dates/` – date and time helpers
- `Debugging/` – debugging aids
- `DefaultValues/` – property wrappers providing defaults
- `DI/` – dependency injection helpers
- `Errors/` – common error types and wrappers
- `Extensions/` – general extensions on standard types
- `Localisation/` – localisation helpers
- `Logging/` – wrappers around SwiftLog
- `Media/` – multimedia support
- `Networking/` – HTTP and network helpers
- `Numerics/` – numerical algorithms
- `ObjectID/` – unique stable identifiers
- `Reflection/` – runtime reflection helpers
- `Sampleable/` – sample generation for types
- `String/` – string utilities
- `Testing/` – helpers for unit tests
- `UUID/` – UUID conveniences
- `Validation/` – validation DSL

`KernelSwiftCommon` has minimal platform assumptions and is imported by all other modules.

## KernelSwiftApplePlatforms

This library contains components specific to Apple platforms (iOS, macOS, etc.).
It extends SwiftUI with controls, view modifiers and platform integrations.
Key modules include:

- `Animation/` – animation helpers
- `AppUtils/` – application utilities
- `BlurEffects/` – blur effects for UI
- `ButtonStyle/` – reusable button styles
- `Charts/` – simple chart views
- `CodeScanner/` – camera code scanning helpers
- `Coding/` – encoders and decoders
- `Color/` – color utilities
- `Concurrency/` – concurrency helpers
- `ControlFlowViews/` – SwiftUI control-flow constructs
- `DI/` – dependency injection helpers
- `Debugging/` – debugging aids
- `Deprecations/` – deprecation helpers
- `Errors/` – common error types
- `Fonts/` – font utilities
- `Haptics/` – haptic feedback wrappers
- `Images/` – image manipulation and barcode utilities
- `Input/` – input field helpers
- `InteractionFlows/` – modelling multi-step flows
- `Keychain/` – keychain storage wrappers
- `Layout/` – layout helpers
- `MatchedGeometry/` – matched geometry effects
- `Navigation/` – navigation helpers
- `Networking/` – network requests
- `Notifications/` – notification helpers
- `OIDC/` – OpenID Connect support
- `Permissions/` – permission prompts
- `Persistence/` – persistence utilities
- `Presentation/` – presentation helpers
- `Previews/` – SwiftUI preview helpers
- `SegmentedPicker/` – custom segmented controls
- `State/` – state storage helpers
- `Style/` – theming and styling
- `TexturedBackgrounds/` – textured backgrounds
- `Toolbar/` – toolbar helpers
- `WebBrowser/` – in-app web browser

It depends on `KernelSwiftCommon` and adds integrations with UIKit and AppKit
where applicable.

## KernelSwiftServer

`KernelSwiftServer` bundles utilities for server-side development built on Vapor.
It re-exports many Vapor packages and is organised into numerous focused modules such as:

- `ASN1/` – ASN.1 encoding/decoding
- `AppFront/` – app front-end helpers
- `Audit/` – audit logging
- `AuthFederation/` – federated authentication
- `AuthSessions/` – session management
- `Barcode/` – barcode generation for server contexts
- `BodyStreaming/` – streaming request bodies
- `CBOR/` – CBOR encoding/decoding
- `CSV/` – CSV parsing utilities
- `Coding/` – Codable helpers
- `Collections/` – collection utilities
- `Concurrency/` – concurrency primitives
- `Country/` – country data utilities
- `Cryptography/` – crypto helpers
- `Currency/` – currency formatting
- `DI/` – dependency injection
- `Dates/` – date helpers
- `Diffable/` – diffing helpers
- `Documentation/` – OpenAPI documentation builders
- `DynamicQuery/` – dynamic DB queries
- `Errors/` – server error types
- `Fluent/` – Fluent wrappers
- `GoogleCloud/` – Google Cloud integrations
- `HTTP/` – HTTP helpers
- `Identity/` – identity management
- `JOSE/` – JOSE/JWT helpers
- `JWK/` – JSON Web Keys
- `JWT/` – JWT handling
- `Localisation/` – localisation helpers
- `Location/` – location utilities
- `Logging/` – logging helpers
- `MTLS/` – mutual TLS helpers
- `Media/` – media processing
- `Middleware/` – Vapor middleware
- `Networking/` – networking utilities
- `Numerics/` – numeric helpers
- `ObjectID/` – stable identifiers
- `OpenAPI/` – OpenAPI schema support
- `OpenAPIReflection/` – reflection for OpenAPI
- `Platform/` – platform configuration
- `PlatformActions/` – actions on platform objects
- `Primitives/` – primitive types
- `Queues/` – background job queues
- `ServiceConfig/` – configuration helpers
- `Services/` – service protocols
- `Shell/` – shell command helpers
- `Signals/` – signal handling
- `TaskScheduler/` – task scheduling
- `TypedRoutes/` – typed routing APIs
- `UUID/` – UUID helpers
- `Validation/` – validation routines
- `WebFront/` – web front-end helpers
- `WebSockets/` – WebSocket helpers
- `WellKnown/` – standardised endpoints
- `X509/` – X.509 certificate utilities

Executables like `KSUCryptoX509DemoServer` use this library to demonstrate server functionality.

## KernelSwiftTerminal

This library provides a terminal user interface framework. It defines a model layer,
styling utilities and rendering primitives for building text-based applications.
Its modules include:

- `Accessory/` – accessory app setup
- `Application/` – application and window abstractions
- `Debug/` – debugging utilities
- `Layout/` – layout system
- `Model/` – view model types
- `Renderer/` – terminal renderer and escape sequences
- `Style/` – color and formatting helpers
- `ViewGraph/` – the view hierarchy model
- `Views/` – reusable terminal views

`KernelSwiftTerminal.swift` ties these pieces together and the library also relies on `KernelSwiftCommon` for core utilities.

## How to Build

Ensure Swift and Swift Package Manager are installed, then run:

```bash
swift build
```

To run the tests (if dependencies have been resolved):

```bash
swift test
```

