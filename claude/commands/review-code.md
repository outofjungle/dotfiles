First, ask the user if they want to:
1. Review local feature branch against upstream main (currently checked out branch)
2. Review remote feature branch against upstream main (PR/MR review - branch not checked out)
3. Review the entire repository

**For option 1 (local feature branch review):**
- This reviews the branch you currently have checked out locally
- Fetch latest changes: `git fetch origin`
- Identify the upstream base branch (usually origin/main or origin/master) - ask user if unclear
- Review the diff: `git diff origin/main...HEAD` (or the specified upstream base)
- This shows changes made in your local branch since it diverged from upstream main

**For option 2 (remote feature branch PR/MR review):**
- This reviews a remote branch without checking it out locally
- Ask the user for the remote branch name (e.g., "origin/feature-branch")
- Fetch latest changes: `git fetch origin`
- Identify the upstream base branch (usually origin/main or origin/master) - ask user if unclear
- Review the diff: `git diff origin/main...origin/feature-branch` (or the specified base)
- This shows changes made in the remote feature branch since it diverged from upstream main

**Review Mindset:** Approach this code review as a senior engineer wearing multiple hats. Bring the core values and concerns of each engineering discipline:

- **Security Engineering**: Defense in depth, zero trust, least privilege, threat modeling, attack surface reduction, supply chain security, compliance
- **Infrastructure Engineering**: Scalability, capacity planning, high availability, disaster recovery, cost optimization, resource efficiency
- **Site Reliability Engineering (SRE)**: Reliability, error budgets, graceful degradation, incident response, toil reduction, operational excellence, change management
- **Quality Engineering (QE)**: Test coverage, edge cases, regression prevention, data integrity, test automation, user experience
- **Performance Engineering**: Latency optimization, throughput maximization, resource efficiency, profiling, bottleneck identification, algorithmic complexity
- **Release Engineering**: Build reproducibility, deployment safety, version management, rollback strategies, release coordination
- **Platform Engineering**: Developer experience, self-service capabilities, internal tooling, productivity optimization, golden paths
- **Observability Engineering**: Distributed tracing, metrics instrumentation, log correlation, telemetry quality, debugging experience
- **API Engineering**: API design principles, contract stability, versioning strategy, backwards compatibility, integration patterns
- **Technical Writing**: Documentation clarity, completeness, accuracy, maintainability, discoverability, developer onboarding experience

Then perform a comprehensive code review looking for:

## Core Engineering Concerns

### 1. Security Engineering
   - Command injection, SQL injection, XSS vulnerabilities
   - CSRF (Cross-Site Request Forgery) protection
   - Clickjacking protection (X-Frame-Options, CSP)
   - Security headers (HSTS, CSP, X-Content-Type-Options, X-XSS-Protection)
   - SSRF (Server-Side Request Forgery) vulnerabilities
   - Path traversal vulnerabilities
   - XML External Entity (XXE) attacks
   - Deserialization vulnerabilities
   - LDAP injection
   - Authentication/authorization checks
   - JWT token validation (signature verification, expiration, audience checks)
   - Password storage (bcrypt, argon2, proper salting)
   - Multi-factor authentication considerations
   - Exposed secrets or credentials in code, logs, or error messages
   - Secrets rotation policies and mechanisms
   - Insecure data handling (encryption at rest/transit)
   - Certificate validation and TLS/SSL configuration
   - Timing attacks and side-channel vulnerabilities
   - OWASP Top 10 vulnerabilities
   - Least privilege principle violations (excessive IAM permissions, broad network access)
   - Defense in depth: single point of failure in security controls
   - Supply chain security: unverified dependencies, vulnerable package versions
   - Security testing (SAST, DAST, penetration testing)
   - Audit trail gaps: missing security-relevant logging
   - Token/session management issues (expiration, rotation, secure storage)
   - Rate limiting and DDoS protection
   - Input sanitization and output encoding
   - Cross-account access patterns and IAM role assumption security

### 2. Infrastructure Engineering
   - Horizontal vs vertical scaling capability
   - Resource limits (CPU, memory, connections, file descriptors)
   - Capacity planning: current usage vs limits
   - Database connection pooling and management
   - Caching strategy (when, where, invalidation)
   - Message queue sizing and consumer scaling
   - Network topology and segmentation (VPC design, subnets, security groups)
   - Load balancer configuration and health checks
   - DNS management and TTL considerations
   - CDN usage and edge caching strategies
   - Network bandwidth and latency considerations
   - Storage I/O patterns and optimization
   - Cost implications (compute, storage, data transfer, API calls)
   - High availability: multi-AZ/region support, failover capability
   - Disaster recovery: backup strategy, RTO/RPO compliance
   - Service dependencies and cascading failure risks
   - Container orchestration specifics (Kubernetes resources, pod scheduling)
   - Service mesh considerations (Istio, Linkerd)
   - Serverless architecture best practices
   - Cold start mitigation strategies
   - Geographic distribution and latency considerations
   - Egress/ingress traffic patterns and costs
   - Infrastructure as code: drift detection, state management
   - Auto-scaling policies and thresholds

### 3. Site Reliability Engineering (SRE)
   - Observability: sufficient logging, metrics, and tracing for debugging
   - Error budget impact: does this change affect system reliability?
   - SLI (Service Level Indicators) definition and tracking
   - SLO/SLA compliance: latency, availability, error rate impacts
   - Graceful degradation: fallback behavior when dependencies fail
   - Retry logic with exponential backoff and jitter
   - Circuit breakers for external service calls
   - Timeout configurations (connection, read, write timeouts)
   - Health check endpoints and readiness/liveness probes
   - Idempotency for critical operations (can safely retry)
   - Rate limiting to prevent resource exhaustion
   - Monitoring and alerting: are new metrics/alerts needed?
   - Alert quality: clear ownership, actionable, low false positive rate
   - Alert fatigue: are we creating noisy alerts?
   - Toil reduction: can this operation be automated?
   - Incident response readiness: runbooks, rollback procedures, emergency access
   - Change management: canary deployments, feature flags, gradual rollouts
   - Rollback capability: can this change be safely reverted?
   - Blast radius: impact scope if this change causes issues
   - MTTR considerations: time to detect, diagnose, and resolve issues
   - Post-incident review: are we repeating past mistakes?
   - Operational complexity: does this add significant operational burden?
   - Chaos engineering practices (fault injection, resilience testing)
   - Dependency mapping and service topology
   - Capacity forecasting and trend analysis

### 4. Quality Engineering (QE)
   - Input validation on user-provided data
   - Boundary checks (nil checks, empty checks, null handling)
   - Error handling completeness
   - Test coverage: unit, integration, e2e tests for new/changed code
   - Code coverage metrics (line, branch, function coverage targets)
   - Edge cases: empty inputs, maximum values, boundary conditions
   - Negative test cases: error scenarios, invalid inputs
   - Race conditions and concurrency issues
   - Test data management and cleanup
   - Test data generation and fixtures management
   - Test doubles (mocks, stubs, fakes, spies) proper usage
   - Flaky test risks: timing dependencies, test isolation
   - Regression prevention: tests for previously fixed bugs
   - Test environment parity with production
   - Data integrity: validation of data transformations
   - User experience: error messages, response times, usability
   - Backward compatibility: API contracts, database migrations
   - Performance testing: load, stress, soak tests needed?
   - Test automation: can manual testing be automated?
   - Mutation testing for test quality verification
   - Contract testing for API consumers/providers
   - Visual regression testing for UI changes
   - Accessibility testing (WCAG compliance, screen readers)
   - Usability testing and UX validation
   - Smoke testing vs integration testing distinctions
   - Test naming conventions and documentation

### 5. Performance Engineering
   - Latency: request/response times, p50/p95/p99 latencies
   - Throughput: requests per second, transactions per second capacity
   - Resource utilization: CPU, memory, disk I/O, network bandwidth efficiency
   - N+1 query problems: database queries in loops
   - Database query optimization: proper indexing, query plans, avoiding full table scans
   - Memory leaks: proper resource cleanup, unbounded growth
   - CPU hotspots: tight loops, inefficient algorithms
   - Algorithmic complexity: O(n²) vs O(n log n) vs O(n) operations
   - Time complexity vs space complexity trade-offs
   - Caching effectiveness: hit rates, cache invalidation strategy
   - Connection pooling: reuse vs creation overhead
   - Lazy loading vs eager loading trade-offs
   - Serialization/deserialization overhead
   - Compression strategies (gzip, brotli, response compression)
   - Network round trips: batching, prefetching opportunities
   - Network protocol optimization (HTTP/2, HTTP/3, gRPC)
   - Disk I/O patterns (sequential vs random access)
   - Streaming vs buffering trade-offs
   - Lock contention and mutex wait times
   - Worker pool sizing and thread pool tuning
   - Event loop performance (async runtime considerations)
   - Garbage collection pressure and frequency
   - Cold start performance (Lambda, container startup)
   - Profiling and benchmarking: are performance tests in place?
   - Performance regression tests: baseline comparisons
   - Resource quotas and throttling: stay within limits
   - Asynchronous processing opportunities: can work be deferred?

### 6. Release Engineering
   - Build reproducibility: deterministic builds, locked dependencies
   - Version management: semantic versioning, version bumping automation
   - Dependency pinning: exact versions vs version ranges
   - Artifact integrity: checksums, signatures, provenance
   - Container registry management and image scanning
   - Environment consistency: dev/staging/prod parity
   - Immutable infrastructure principles
   - Configuration management: environment-specific configs, secrets management
   - Database migrations: forward and backward compatibility, rollback safety
   - API versioning: breaking vs non-breaking changes
   - Feature flags: can features be toggled without redeployment?
   - Canary deployments: gradual rollout capability
   - Progressive delivery strategies (traffic splitting, A/B testing)
   - Blue-green deployments: zero-downtime switching
   - Rollback strategy: how quickly can we revert? Any data migration concerns?
   - Deployment automation: CI/CD pipeline quality
   - Smoke tests: post-deployment validation
   - Release notes and changelog: are changes documented?
   - Deployment windows: impact on users, maintenance windows
   - Cross-service coordination: dependencies on other service deployments
   - Release train scheduling and coordination
   - Build caching: optimized build times
   - Artifact storage and retention policies
   - Release tagging: proper git tags, release branches
   - Hotfix process: can urgent fixes bypass normal release cycle safely?
   - Deployment observability: can we track deployment progress and health?
   - Compliance and audit trail for releases
   - License management for dependencies
   - SBOM (Software Bill of Materials) generation
   - Code signing and artifact verification

### 7. Platform Engineering
   - Developer experience (DX): is this easy for developers to understand and use?
   - Self-service capabilities: can developers accomplish tasks without platform team intervention?
   - Service catalog and service discovery
   - Template repositories and scaffolding tools
   - Abstraction quality: does this hide complexity or just add layers?
   - Golden paths: does this follow established patterns and best practices?
   - Developer onboarding: can new team members understand this code quickly?
   - Internal tooling: are CLI tools, SDKs, libraries easy to use?
   - Internal developer portal (Backstage, etc.)
   - Documentation quality: README, API docs, examples, tutorials
   - Local development experience: can developers run this locally easily?
   - Development environment parity: does local match production behavior?
   - Cognitive load: is this introducing unnecessary complexity?
   - Convention over configuration: sensible defaults, minimal boilerplate
   - Developer productivity: does this speed up or slow down development?
   - Platform services reuse: are we reinventing existing platform capabilities?
   - Platform API design and versioning
   - Multi-tenancy support and isolation
   - Resource quotas and fair usage policies
   - Standardization: does this align with org-wide standards and patterns?
   - Discoverability: can developers find what they need?
   - Error messages for developers: clear, actionable guidance
   - Debugging tools: can developers troubleshoot issues effectively?
   - Testing ergonomics: is it easy to write and run tests?
   - Dependency management: are transitive dependencies handled well?
   - Build times: impact on developer iteration speed
   - Metrics and monitoring for platform services themselves
   - Feedback loops from developers to platform team

### 8. Observability Engineering
   - Distributed tracing: span creation, trace context propagation
   - Trace sampling strategy: head-based vs tail-based sampling
   - OpenTelemetry adoption and standards
   - Metrics instrumentation: RED metrics (Rate, Errors, Duration)
   - Metrics cardinality: avoiding high-cardinality dimensions
   - Custom metrics: business metrics, SLI metrics
   - Log correlation: trace IDs, request IDs, correlation fields
   - Log aggregation platform configuration
   - Structured logging: consistent schema, searchable fields
   - Log levels and verbosity: appropriate granularity
   - PII/sensitive data in logs (must be redacted)
   - Signal-to-noise ratio: are we logging too much or too little?
   - Dashboard design: key metrics visible, drill-down capabilities
   - Error messages: actionable, clear, include context (request IDs, timestamps)
   - Telemetry overhead: performance impact of instrumentation
   - Sampling rates: balancing cost vs coverage
   - Telemetry pipeline reliability: what if observability backend is down?
   - Debugging experience: can we reproduce issues from telemetry?
   - Context propagation: passing context across service boundaries
   - Error tracking: stack traces, error grouping, error rates
   - Exception tracking service integration (Sentry, Rollbar)
   - Performance profiling: CPU, memory, flame graphs
   - APM (Application Performance Monitoring) integration
   - Real User Monitoring (RUM) for frontend applications
   - Synthetic monitoring and uptime checks
   - Service dependencies visualization: service maps, topology
   - Alerting on telemetry: can we detect issues from these signals?
   - Alerting fatigue mitigation strategies
   - Telemetry retention and cost: storage implications

### 9. API Engineering
   - API design principles: REST, GraphQL, gRPC best practices
   - Resource naming: consistent, intuitive, hierarchical
   - HTTP method semantics: GET (safe, idempotent), POST, PUT, PATCH, DELETE
   - Status codes: appropriate HTTP status code usage
   - Request/response schemas: clear, well-documented contracts
   - API versioning strategy: URL versioning, header versioning, content negotiation
   - API lifecycle management (alpha, beta, GA, deprecated)
   - Backwards compatibility: can old clients still work?
   - Breaking changes: clearly identified, migration path provided
   - Deprecation policy: sunset timeline, deprecation warnings
   - Pagination: cursor-based vs offset-based, page size limits
   - Bulk operations and batch endpoints
   - Partial responses (field selection, sparse fieldsets)
   - Filtering, sorting, searching: query parameter design
   - Conditional requests (ETags, If-None-Match, If-Modified-Since)
   - Rate limiting: per-user, per-endpoint limits
   - API authentication: API keys, OAuth, JWT
   - API authorization: fine-grained permissions, scopes
   - Webhook reliability: retries, exponential backoff, dead letter queues
   - Webhook security: signature verification, IP whitelisting
   - Idempotency keys: safe retries for non-idempotent operations
   - API documentation: OpenAPI/Swagger, examples, SDKs
   - API client SDKs: developer ergonomics, error handling
   - Integration patterns: sync vs async, event-driven, polling
   - API composition and aggregation patterns (BFF, API gateway)
   - GraphQL specific: N+1 queries, depth limiting, complexity analysis
   - gRPC specific: streaming, deadline propagation, metadata
   - WebSocket lifecycle management and reconnection strategies
   - Server-Sent Events (SSE) for real-time updates
   - Long polling vs WebSocket trade-offs
   - Consumer-driven contracts testing
   - Link headers and HATEOAS principles
   - Error responses: consistent format, error codes, actionable messages
   - API gateway usage: routing, transformation, validation
   - Cross-origin resource sharing (CORS): proper configuration
   - Content negotiation: JSON, XML, protobuf support
   - API monitoring: endpoint latency, error rates, usage patterns

### 10. Technical Writing
   - Documentation completeness: are all public APIs, configuration options, and features documented?
   - README quality: clear project description, installation instructions, quick start guide, usage examples
   - API documentation: complete parameter descriptions, return types, error conditions
   - Code comments: complex logic explained, "why" not "what", non-obvious behavior clarified
   - Architecture documentation: system diagrams, component interactions, data flow
   - Runbooks and playbooks: incident response procedures, troubleshooting guides, common tasks
   - Configuration documentation: all environment variables, config files, CLI flags explained
   - Migration guides: version upgrade instructions, breaking changes, deprecation notices
   - Changelog maintenance: user-facing changes documented, semantic versioning followed
   - Documentation accuracy: outdated docs, incorrect examples, broken links
   - Code examples: working, tested, covering common use cases
   - Code playground integration
   - Interactive documentation (try-it-now features)
   - Video tutorials and screencasts
   - Error message clarity: actionable guidance, not just error codes
   - Onboarding documentation: getting started guides, development setup, contribution guidelines
   - Documentation organization: logical structure, easy navigation, searchable
   - Inline help: CLI --help output, tooltips, inline documentation completeness
   - Diagrams and visuals: architecture diagrams, sequence diagrams, entity relationships
   - Documentation maintenance: docs updated with code changes, versioned appropriately
   - Documentation as code (docs in version control with code)
   - Documentation review processes
   - Community contribution to documentation
   - Glossary and terminology: consistent terms, acronyms defined, domain concepts explained
   - Tutorial quality: step-by-step guides, learning path for new users
   - Reference documentation: comprehensive, well-organized, searchable
   - Documentation discoverability: can developers find answers when they need them?
   - Accessibility: clear language, appropriate technical level, internationalization considerations
   - Localization and internationalization of docs
   - Security documentation: authentication setup, authorization model, security best practices
   - Performance tuning guides: optimization recommendations, profiling instructions
   - Troubleshooting sections: common errors, debugging techniques, FAQ
   - Integration guides: how to integrate with other systems, SDKs, sample projects
   - Dependency documentation: version requirements, compatibility matrix
   - Documentation testing: examples actually work, commands are valid, links aren't broken
   - Version-specific docs: clear which version documentation applies to
   - Documentation format: markdown quality, consistent formatting, proper code blocks

## Language & Tool-Specific Best Practices

### 11. Go Best Practices
   - Error handling patterns (errors.Is, errors.As, wrapped errors with %w)
   - Panic recovery (when to use, how to recover gracefully with defer/recover)
   - Nil pointer dereferences prevention
   - Proper use of defer, context, goroutines
   - Resource cleanup (defer for Close, cleanup functions)
   - Idiomatic Go code
   - Interface usage and composition
   - Channel operations and select statements
   - Proper mutex usage and race condition prevention
   - Slice/map initialization (make vs literal, capacity pre-allocation)
   - String concatenation (strings.Builder for efficiency)
   - Reflection usage (performance implications, type safety)
   - CGO usage (when to avoid, cross-compilation issues)
   - Build tags and conditional compilation
   - Module management (go.mod, go.sum, version selection)
   - Vendoring considerations
   - Testing best practices (table-driven tests, t.Helper(), subtests)
   - Benchmark writing (b.ResetTimer(), b.StopTimer())
   - Go workspace usage (go.work)
   - Generics usage (Go 1.18+)
   - Go formatting (gofmt/goimports compliance)

### 12. Python Best Practices
   - PEP 8 compliance (formatting, naming)
   - Proper exception handling (specific exceptions, context managers)
   - Type hints usage (where appropriate)
   - Type checking with mypy or pyright
   - List/dict comprehensions vs loops
   - Context managers (with statements)
   - Generator usage for memory efficiency
   - Async/await usage (asyncio, event loops)
   - Pythonic idioms (EAFP vs LBYL)
   - Dataclasses and attrs for data structures
   - Enum usage for constants
   - pathlib vs os.path for file operations
   - Logging best practices (structured logging, log levels)
   - Virtual environment and dependency management
   - Poetry vs pip/setuptools for dependency management
   - f-strings vs older formatting methods
   - Avoiding mutable default arguments
   - pytest vs unittest (modern testing approaches)
   - Mock/patch usage for testing
   - Security (SQL injection with parameterized queries, eval avoidance)
   - Resource management (file handles, network connections)
   - Import ordering and organization
   - Docstrings (Google style, NumPy style, reStructuredText)
   - Packaging (setup.py, pyproject.toml, wheels)
   - Linting with pylint, flake8, black

### 13. C/C++ Best Practices
   - Memory management (leaks, double-free, use-after-free)
   - Buffer overflows and bounds checking
   - Proper use of pointers and references
   - nullptr vs NULL vs 0
   - RAII patterns (C++)
   - Smart pointers usage (C++: unique_ptr, shared_ptr)
   - Rule of Five (destructor, copy/move constructors, copy/move assignment)
   - Exception safety and error handling
   - Undefined behavior prevention
   - Initialization (uniform initialization, member initializer lists)
   - auto keyword usage and type deduction
   - Lambda expressions and closures
   - Templates and metaprogramming considerations
   - Constexpr for compile-time evaluation
   - Modern C++ features (C++11/14/17/20 standards)
   - Standard library usage (STL containers, algorithms)
   - Range-based for loops
   - Enum class vs enum
   - Header guards or #pragma once
   - Forward declarations vs includes
   - Const correctness
   - Move semantics (C++)
   - Static analysis tools (clang-tidy, cppcheck)
   - Sanitizers (AddressSanitizer, ThreadSanitizer, UndefinedBehaviorSanitizer)
   - Compilation flags (-Wall, -Wextra, -Werror, optimization levels)
   - Link-time optimization (LTO)

### 14. Terraform Best Practices
   - Security: IAM policies (least privilege), encryption at rest/transit, public access restrictions
   - State management and backend configuration
   - Remote state locking and concurrency
   - State file security (encryption, access control)
   - Workspace usage for environment separation
   - Resource naming conventions and tagging
   - Use of variables, locals, and outputs appropriately
   - tfvars files and variable precedence
   - Dynamic blocks and meta-arguments (count, for_each)
   - Module structure and reusability
   - Module versioning and registry usage
   - Proper use of data sources vs resources
   - Lifecycle management (prevent_destroy, create_before_destroy)
   - Dependencies and ordering (depends_on usage)
   - Provisioners (when to avoid, alternatives)
   - Import existing resources
   - Refactoring with moved blocks
   - Terraform formatting (terraform fmt compliance)
   - Version constraints for providers and modules
   - Sensitive data handling (sensitive = true on outputs)
   - Cost optimization opportunities
   - Testing (terraform validate, terraform plan, Terratest)
   - Terraform Cloud/Enterprise features
   - Policy as Code (Sentinel, OPA)

### 15. Dockerfile Best Practices
   - Use specific base image tags (avoid :latest)
   - Multi-stage builds for smaller images
   - Layer caching optimization (order of COPY/ADD)
   - Layer optimization (combining RUN commands vs readability)
   - Security: run as non-root user, scan for vulnerabilities
   - USER directive for non-root users (specific UID/GID)
   - Distroless images for minimal attack surface
   - Minimize layers and image size
   - Use .dockerignore to exclude unnecessary files
   - .dockerignore patterns and efficiency
   - COPY vs ADD usage (prefer COPY)
   - ARG vs ENV (build-time vs runtime variables)
   - BuildKit features (cache mounts, secret mounts)
   - Health checks (HEALTHCHECK instruction)
   - Proper signal handling (ENTRYPOINT vs CMD)
   - WORKDIR best practices
   - SHELL directive for custom shells
   - LABEL usage for metadata
   - Platform-specific builds (multi-arch images)
   - Secrets management (avoid ARG for secrets)
   - Image scanning in CI/CD (Trivy, Snyk, Clair)

### 16. Makefile Best Practices
   - Proper use of .PHONY for non-file targets
   - Variables and pattern rules usage
   - Automatic variables ($@, $<, $^, $?)
   - Target-specific variables
   - Dependency management between targets
   - Error handling (use of set -e, || exit)
   - Cross-platform compatibility considerations
   - Conditional directives (ifeq, ifdef)
   - Include directive for modular Makefiles
   - Clear target naming and documentation
   - Avoid hardcoded paths, use variables
   - Parallel execution safety (-j flag compatibility)
   - Recursive make considerations (considered harmful)
   - Silent mode (@prefix for commands)
   - MAKEFLAGS usage
   - Default goals (.DEFAULT_GOAL)
   - Use of $(shell) vs backticks
   - Proper quoting and escaping

### 17. CI/CD Configuration (.gitlab-ci.yml, GitHub Actions, etc.)
   - Security: secret management, no hardcoded credentials
   - Proper use of stages and dependencies
   - Job artifacts and caching strategies
   - Container image caching for faster builds
   - Conditional execution (rules, only, except)
   - Retry and timeout configurations
   - Matrix builds for multiple versions/platforms
   - Parallel job execution and job dependencies
   - Fail-fast vs complete pipeline strategies
   - Resource limits and runner tags
   - Environment-specific runners and tags
   - Version pinning for actions/images
   - Proper environment variable usage
   - Code quality and security scanning integration
   - SAST/DAST integration
   - Dependency scanning and vulnerability detection
   - License compliance checking
   - Code coverage tracking and enforcement
   - Test result publishing and reporting
   - Pipeline as code versioning and review
   - Pipeline triggers (merge request, tag, schedule, API)
   - Approval gates and manual intervention
   - Notification configuration (Slack, email)
   - Deployment strategies (manual gates, rollback plans)

### 18. YAML/JSON Configuration Files
   - Valid syntax and structure
   - Proper indentation (YAML: spaces not tabs)
   - Security: no sensitive data in config files
   - Secret references (sealed secrets, external secret operators)
   - Schema validation where applicable
   - JSON Schema validation
   - Comments for complex configurations
   - Environment-specific configurations
   - Avoid duplication (use anchors/references in YAML)
   - YAML anchors and aliases (&anchor, *alias)
   - YAML merge keys (<<: *default)
   - YAML multi-line strings (|, >, |-, >-)
   - JSON trailing commas (not allowed)
   - JSON5 or JSONC considerations
   - Configuration templating (Helm, Kustomize)

### 19. JavaScript/TypeScript/Node.js Best Practices
   - Async/await patterns (proper error handling, Promise chains)
   - Promise handling (avoiding callback hell, Promise.all for parallel operations)
   - Error boundaries (React error handling)
   - TypeScript strict mode and type safety
   - Type assertions vs type guards
   - ESLint/Prettier configuration and compliance
   - npm/yarn/pnpm dependency management
   - Package-lock.json or yarn.lock integrity
   - Tree shaking and code splitting
   - Module systems (CommonJS vs ESM)
   - Import ordering and organization
   - const/let instead of var
   - Arrow functions vs function declarations
   - Destructuring and spread operators
   - Optional chaining (?.) and nullish coalescing (??)
   - Template literals for string interpolation
   - Array methods (map, filter, reduce) over loops
   - Event loop understanding and non-blocking I/O
   - Memory leaks (event listeners, closures, timers)
   - Security (XSS prevention, input sanitization, npm audit)
   - Testing frameworks (Jest, Mocha, Vitest)
   - Mocking and stubbing in tests
   - React/Vue/Angular framework-specific best practices
   - State management (Redux, Zustand, Pinia)
   - Bundle size optimization
   - Webpack/Vite/Rollup configuration

### 20. Java/JVM Languages Best Practices
   - Exception handling (specific exceptions, try-with-resources)
   - Resource management (try-with-resources, AutoCloseable)
   - Collections usage (List, Set, Map implementations)
   - Stream API for functional operations
   - Concurrency (synchronized, volatile, concurrent collections, ExecutorService)
   - Thread safety and immutability
   - Optional usage for null safety
   - Generics and type parameters
   - Dependency injection patterns
   - Memory management and GC tuning (heap sizing, GC algorithms)
   - Maven/Gradle dependency management
   - JUnit/TestNG testing frameworks
   - Mockito for mocking
   - Spring Boot best practices (if applicable)
   - Logging frameworks (SLF4J, Logback, Log4j2)
   - Annotations usage and custom annotations
   - Reflection usage and performance implications
   - Serialization and deserialization
   - JDBC and connection pooling
   - Builder pattern for complex objects
   - Equals and hashCode contract

### 21. Rust Best Practices
   - Ownership and borrowing rules
   - Lifetime annotations (when needed, explicit vs implicit)
   - Error handling (Result, Option, ? operator)
   - Pattern matching exhaustiveness
   - Traits and trait bounds
   - Generic types and associated types
   - Unsafe code usage (minimizing, justification, safety comments)
   - Memory safety guarantees (no data races, no dangling pointers)
   - Cargo dependency management (Cargo.toml, Cargo.lock)
   - Workspace usage for multi-crate projects
   - clippy linting and warnings
   - rustfmt code formatting
   - Testing with #[test] and cargo test
   - Documentation with ///, cargo doc
   - Macro usage (declarative vs procedural)
   - Async/await with tokio or async-std
   - Reference counting (Rc, Arc) vs ownership
   - Interior mutability (Cell, RefCell, Mutex)
   - Zero-cost abstractions validation

### 22. Ruby Best Practices
   - Idiomatic Ruby (blocks, procs, lambdas)
   - Enumerable methods (map, select, reduce)
   - Symbol vs String usage
   - Class and module design
   - Metaprogramming (when to use, when to avoid)
   - Rails best practices (if applicable)
   - ActiveRecord patterns and N+1 query prevention
   - Gem management (Bundler, Gemfile, Gemfile.lock)
   - RSpec testing framework
   - FactoryBot for test fixtures
   - Rubocop linting
   - Thread safety considerations
   - Performance optimization (memoization, caching)
   - Security (SQL injection, mass assignment protection)
   - Exception handling and custom exceptions

### 23. Shell Scripts (Bash/sh) Best Practices
   - Set -euo pipefail for safety (exit on error, undefined variables, pipe failures)
   - Shellcheck compliance
   - Quoting and escaping (double quotes for variables, single quotes for literals)
   - POSIX compliance vs Bash extensions
   - Exit codes and error handling
   - Function usage and modularity
   - Local variables in functions
   - Avoid parsing ls output
   - Use [[ ]] instead of [ ] for conditionals (in Bash)
   - Command substitution $() instead of backticks
   - Here documents for multi-line strings
   - Trap for cleanup on exit
   - Argument parsing (getopts)
   - Path handling and portability
   - Avoid eval when possible
   - Security (command injection, input validation)

### 24. SQL/Database Best Practices
   - Query optimization (indexes, query plans, EXPLAIN)
   - Index design (when to use, composite indexes, covering indexes)
   - Transaction isolation levels (READ COMMITTED, REPEATABLE READ, SERIALIZABLE)
   - ACID properties understanding
   - N+1 query prevention
   - Proper use of JOINs vs subqueries
   - Avoiding SELECT * in production code
   - Parameterized queries (SQL injection prevention)
   - Schema design (normalization vs denormalization trade-offs)
   - Foreign key constraints and referential integrity
   - Database migrations (up/down scripts, version control)
   - Migration rollback safety
   - ORM usage anti-patterns (lazy loading issues, query generation)
   - Connection pooling configuration
   - Deadlock prevention and handling
   - Batch operations for bulk inserts/updates
   - Pagination strategies (offset vs cursor-based)
   - Database-specific features and extensions
   - Backup and restore procedures
   - Query performance monitoring

### 25. Kubernetes Manifests Best Practices
   - Resource requests and limits (CPU, memory)
   - Health probes configuration (liveness, readiness, startup probes)
   - Security contexts and pod security policies/standards
   - RBAC configuration (least privilege roles)
   - Service account usage
   - NetworkPolicies for network segmentation
   - PodDisruptionBudgets for high availability
   - HorizontalPodAutoscaler/VerticalPodAutoscaler configuration
   - Resource naming conventions and labels
   - Namespace organization
   - ConfigMaps and Secrets usage
   - Volume mounts and persistent storage
   - Init containers for setup tasks
   - Sidecar containers and multi-container pods
   - Affinity and anti-affinity rules
   - Taints and tolerations
   - ImagePullPolicy configuration
   - Rolling update strategy
   - API version compatibility
   - Resource annotations for tooling

### 26. Helm Charts Best Practices
   - Chart structure and organization (Chart.yaml, values.yaml, templates/)
   - values.yaml organization (hierarchical, clear defaults)
   - Template functions and pipelines (tpl, include, required)
   - Conditional logic in templates (if/else, with, range)
   - Hooks and lifecycle management (pre-install, post-upgrade, etc.)
   - Chart dependencies (requirements.yaml, Chart.lock)
   - Subchart usage and values override
   - Named templates (_helpers.tpl)
   - Chart versioning (semantic versioning)
   - Chart testing (helm lint, helm test)
   - Values validation (JSON Schema)
   - Documentation (README.md, values.yaml comments)
   - Chart repository management
   - Secret management (sealed secrets, external secret operators)
   - Resource naming consistency
   - NOTES.txt for installation instructions

### 27. GraphQL Schema Best Practices
   - Schema design principles (graph thinking, not endpoint thinking)
   - Type system usage (scalar, object, interface, union, enum)
   - Nullable vs non-nullable fields
   - Resolver performance optimization
   - N+1 query prevention (dataloader, batching)
   - Pagination (relay-style cursor-based, offset-based)
   - Error handling (field errors vs top-level errors)
   - Deprecation strategy (@deprecated directive)
   - Schema stitching and federation
   - Input validation
   - Authorization and field-level permissions
   - Query complexity analysis and limits
   - Query depth limiting
   - Caching strategies (per-field, per-query)
   - Subscription usage and scalability
   - Schema versioning strategies
   - Documentation with descriptions

### 28. Protobuf/gRPC Best Practices
   - Message design (clear naming, logical grouping)
   - Field numbering (never reuse, reserve removed fields)
   - Backward compatibility (adding fields, not removing)
   - Forward compatibility considerations
   - Repeated fields vs maps
   - Oneof for mutually exclusive fields
   - Well-known types (Timestamp, Duration, Any)
   - Service definitions (clear method names, idempotent operations)
   - Streaming patterns (unary, server streaming, client streaming, bidirectional)
   - Error handling with status codes
   - Metadata usage for cross-cutting concerns
   - Deadline propagation
   - Interceptors for logging, auth, tracing
   - Code generation configuration
   - Protobuf versioning and package naming
   - JSON mapping and REST transcoding

### 29. Jsonnet/Libsonnet Best Practices
   - Proper use of local, function, and self keywords
   - Avoid deep nesting, use local bindings for clarity
   - Parameterization via function arguments or external variables
   - Use of std library functions (std.join, std.map, etc.)
   - Error handling with std.assertEqual, std.trace
   - Proper string formatting and concatenation
   - Import statements organization and dependencies
   - Avoid code duplication, extract reusable functions
   - Consistent naming conventions for functions and variables
   - Comments and documentation for complex logic
   - Formatting and indentation consistency
   - Testing Jsonnet code
   - Debugging techniques

### 30. Qbec Best Practices
   - Environment configuration (qbec.yaml structure)
   - Proper use of components and their organization
   - Parameter management across environments
   - Use of params.libsonnet for environment-specific overrides
   - Namespace and context configuration
   - Baseline vs environment-specific resources
   - Security: no hardcoded secrets, use external secret management
   - Resource naming conventions and labels
   - Proper use of qbec commands (apply, diff, validate)
   - Component dependencies and ordering
   - Kubernetes API version compatibility
   - GC (garbage collection) tag usage for resource cleanup
   - Validation of generated manifests before apply

### 31. General Code Quality & Organization
   - Language-appropriate formatting standards
   - Naming conventions (language-specific best practices)
   - Code organization and structure
   - Unused imports, variables, or dead code
   - Comment quality and documentation
   - External framework/library usage according to official documentation
   - Proper initialization and configuration
   - Correct API usage patterns (deprecated vs current APIs)
   - Error handling as per framework conventions
   - Resource cleanup and lifecycle management
   - Thread-safety and concurrency considerations
   - Version compatibility and breaking changes
   - Unnecessary dependencies or redundant packages

### 32. Project-Specific Concerns
   - Check @AGENTS.md or @CLAUDE.md for project-specific guidelines and follow them
   - Respect project conventions for issue tracking (beads/bd, TodoWrite, or other tools)
   - Follow project-specific naming conventions and code organization
   - Adhere to project-specific security requirements
   - Follow project-specific testing requirements and frameworks
   - Respect project-specific deployment and release processes

## Output Format

**Priority Guidelines:**
- **P0 (Critical)**: Security vulnerabilities, data loss risks, production-breaking issues
  - Examples: SQL injection, exposed credentials, missing authentication, unencrypted sensitive data, broken deployment
- **P1 (High)**: Missing validation, error handling gaps, framework misuse, potential bugs
  - Examples: Missing input validation, no error handling, race conditions, nil pointer dereferences, memory leaks
- **P2 (Medium)**: Code quality issues, linting problems, non-idiomatic code, minor best practice violations
  - Examples: Unused imports, inconsistent naming, missing test coverage, inefficient algorithms, poor documentation
- **P3 (Low)**: Style improvements, documentation, optimization opportunities
  - Examples: Code formatting, additional comments, minor refactoring, performance micro-optimizations

### For Merge Request Reviews (Option 1):
Present findings as formatted feedback to share with the developer:
- Organize by priority level (P0 → P1 → P2 → P3)
- For each finding include:
  - File path and line number (e.g., "auth.go:42")
  - Priority level
  - Specific, actionable description with context
  - Why this matters and recommended fix
- Format in clear markdown suitable for merge request comments

### For Full Repository Scans (Option 3):
First, check if the project specifies a preferred todo tracking tool in @AGENTS.md or @CLAUDE.md:
- If **beads/bd** is specified: Use `bd create` commands to file issues for each finding
  - Create issues with priority in title (e.g., "[P0] Fix SQL injection in auth.go:42")
  - Include file path, line number, and actionable description in the issue description
  - Organize by priority so items can be worked through systematically
- If **TodoWrite** is allowed or no preference specified: Use the TodoWrite tool to create trackable todo items
  - Each todo should include priority label in the content
  - Include file path and line number
  - Provide specific and actionable descriptions
- **Important**: Always respect the project's issue tracking preference to maintain consistency

---

## After Review Completion

After completing the code review, ask the user:
"Would you like to copy the contents of the review to your clipboard?"

If the user answers yes:
1. Echo the entire review content and pipe it to `pbcopy` using a heredoc
2. Use this exact format:
```bash
cat <<'EOF' | pbcopy
[full review content here]
EOF
```
3. Inform the user that the review has been copied to their clipboard
