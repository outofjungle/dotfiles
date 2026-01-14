First, ask the user if they want to:
1. Review only the current changes in the feature branch (git diff against main/base branch)
2. Review the entire repository

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
   - Authentication/authorization checks
   - Exposed secrets or credentials in code, logs, or error messages
   - Insecure data handling (encryption at rest/transit)
   - OWASP Top 10 vulnerabilities
   - Least privilege principle violations (excessive IAM permissions, broad network access)
   - Defense in depth: single point of failure in security controls
   - Supply chain security: unverified dependencies, vulnerable package versions
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
   - Network bandwidth and latency considerations
   - Storage I/O patterns and optimization
   - Cost implications (compute, storage, data transfer, API calls)
   - High availability: multi-AZ/region support, failover capability
   - Disaster recovery: backup strategy, RTO/RPO compliance
   - Service dependencies and cascading failure risks
   - Infrastructure as code: drift detection, state management
   - Auto-scaling policies and thresholds

### 3. Site Reliability Engineering (SRE)
   - Observability: sufficient logging, metrics, and tracing for debugging
   - Error budget impact: does this change affect system reliability?
   - Graceful degradation: fallback behavior when dependencies fail
   - Retry logic with exponential backoff and jitter
   - Circuit breakers for external service calls
   - Timeout configurations (connection, read, write timeouts)
   - Health check endpoints and readiness/liveness probes
   - Idempotency for critical operations (can safely retry)
   - Rate limiting to prevent resource exhaustion
   - SLO/SLA compliance: latency, availability, error rate impacts
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

### 4. Quality Engineering (QE)
   - Input validation on user-provided data
   - Boundary checks (nil checks, empty checks, null handling)
   - Error handling completeness
   - Test coverage: unit, integration, e2e tests for new/changed code
   - Edge cases: empty inputs, maximum values, boundary conditions
   - Negative test cases: error scenarios, invalid inputs
   - Race conditions and concurrency issues
   - Test data management and cleanup
   - Flaky test risks: timing dependencies, test isolation
   - Regression prevention: tests for previously fixed bugs
   - Test environment parity with production
   - Data integrity: validation of data transformations
   - User experience: error messages, response times, usability
   - Backward compatibility: API contracts, database migrations
   - Performance testing: load, stress, soak tests needed?
   - Test automation: can manual testing be automated?

### 5. Performance Engineering
   - Latency: request/response times, p50/p95/p99 latencies
   - Throughput: requests per second, transactions per second capacity
   - Resource utilization: CPU, memory, disk I/O, network bandwidth efficiency
   - N+1 query problems: database queries in loops
   - Database query optimization: proper indexing, query plans, avoiding full table scans
   - Memory leaks: proper resource cleanup, unbounded growth
   - CPU hotspots: tight loops, inefficient algorithms
   - Algorithmic complexity: O(n²) vs O(n log n) vs O(n) operations
   - Caching effectiveness: hit rates, cache invalidation strategy
   - Connection pooling: reuse vs creation overhead
   - Lazy loading vs eager loading trade-offs
   - Serialization/deserialization overhead
   - Network round trips: batching, prefetching opportunities
   - Lock contention and mutex wait times
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
   - Environment consistency: dev/staging/prod parity
   - Configuration management: environment-specific configs, secrets management
   - Database migrations: forward and backward compatibility, rollback safety
   - API versioning: breaking vs non-breaking changes
   - Feature flags: can features be toggled without redeployment?
   - Canary deployments: gradual rollout capability
   - Blue-green deployments: zero-downtime switching
   - Rollback strategy: how quickly can we revert? Any data migration concerns?
   - Deployment automation: CI/CD pipeline quality
   - Smoke tests: post-deployment validation
   - Release notes and changelog: are changes documented?
   - Deployment windows: impact on users, maintenance windows
   - Cross-service coordination: dependencies on other service deployments
   - Build caching: optimized build times
   - Artifact storage and retention policies
   - Release tagging: proper git tags, release branches
   - Hotfix process: can urgent fixes bypass normal release cycle safely?
   - Deployment observability: can we track deployment progress and health?

### 7. Platform Engineering
   - Developer experience (DX): is this easy for developers to understand and use?
   - Self-service capabilities: can developers accomplish tasks without platform team intervention?
   - Abstraction quality: does this hide complexity or just add layers?
   - Golden paths: does this follow established patterns and best practices?
   - Developer onboarding: can new team members understand this code quickly?
   - Internal tooling: are CLI tools, SDKs, libraries easy to use?
   - Documentation quality: README, API docs, examples, tutorials
   - Local development experience: can developers run this locally easily?
   - Development environment parity: does local match production behavior?
   - Cognitive load: is this introducing unnecessary complexity?
   - Convention over configuration: sensible defaults, minimal boilerplate
   - Developer productivity: does this speed up or slow down development?
   - Platform services reuse: are we reinventing existing platform capabilities?
   - Standardization: does this align with org-wide standards and patterns?
   - Discoverability: can developers find what they need?
   - Error messages for developers: clear, actionable guidance
   - Debugging tools: can developers troubleshoot issues effectively?
   - Testing ergonomics: is it easy to write and run tests?
   - Dependency management: are transitive dependencies handled well?
   - Build times: impact on developer iteration speed

### 8. Observability Engineering
   - Distributed tracing: span creation, trace context propagation
   - Trace sampling strategy: head-based vs tail-based sampling
   - Metrics instrumentation: RED metrics (Rate, Errors, Duration)
   - Metrics cardinality: avoiding high-cardinality dimensions
   - Custom metrics: business metrics, SLI metrics
   - Log correlation: trace IDs, request IDs, correlation fields
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
   - Performance profiling: CPU, memory, flame graphs
   - Service dependencies visualization: service maps, topology
   - Alerting on telemetry: can we detect issues from these signals?
   - Telemetry retention and cost: storage implications

### 9. API Engineering
   - API design principles: REST, GraphQL, gRPC best practices
   - Resource naming: consistent, intuitive, hierarchical
   - HTTP method semantics: GET (safe, idempotent), POST, PUT, PATCH, DELETE
   - Status codes: appropriate HTTP status code usage
   - Request/response schemas: clear, well-documented contracts
   - API versioning strategy: URL versioning, header versioning, content negotiation
   - Backwards compatibility: can old clients still work?
   - Breaking changes: clearly identified, migration path provided
   - Deprecation policy: sunset timeline, deprecation warnings
   - Pagination: cursor-based vs offset-based, page size limits
   - Filtering, sorting, searching: query parameter design
   - Rate limiting: per-user, per-endpoint limits
   - API authentication: API keys, OAuth, JWT
   - API authorization: fine-grained permissions, scopes
   - Webhook reliability: retries, exponential backoff, dead letter queues
   - Webhook security: signature verification, IP whitelisting
   - Idempotency keys: safe retries for non-idempotent operations
   - API documentation: OpenAPI/Swagger, examples, SDKs
   - API client SDKs: developer ergonomics, error handling
   - Integration patterns: sync vs async, event-driven, polling
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
   - Error message clarity: actionable guidance, not just error codes
   - Onboarding documentation: getting started guides, development setup, contribution guidelines
   - Documentation organization: logical structure, easy navigation, searchable
   - Inline help: CLI --help output, tooltips, inline documentation completeness
   - Diagrams and visuals: architecture diagrams, sequence diagrams, entity relationships
   - Documentation maintenance: docs updated with code changes, versioned appropriately
   - Glossary and terminology: consistent terms, acronyms defined, domain concepts explained
   - Tutorial quality: step-by-step guides, learning path for new users
   - Reference documentation: comprehensive, well-organized, searchable
   - Documentation discoverability: can developers find answers when they need them?
   - Accessibility: clear language, appropriate technical level, internationalization considerations
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
   - Error handling patterns (errors.Is, errors.As, wrapped errors)
   - Proper use of defer, context, goroutines
   - Resource cleanup (defer for Close, cleanup functions)
   - Idiomatic Go code
   - Interface usage and composition
   - Channel operations and select statements
   - Proper mutex usage and race condition prevention
   - Go formatting (gofmt/goimports compliance)

### 12. Python Best Practices
   - PEP 8 compliance (formatting, naming)
   - Proper exception handling (specific exceptions, context managers)
   - Type hints usage (where appropriate)
   - List/dict comprehensions vs loops
   - Context managers (with statements)
   - Generator usage for memory efficiency
   - Pythonic idioms (EAFP vs LBYL)
   - Virtual environment and dependency management
   - f-strings vs older formatting methods
   - Avoiding mutable default arguments

### 13. C/C++ Best Practices
   - Memory management (leaks, double-free, use-after-free)
   - Buffer overflows and bounds checking
   - Proper use of pointers and references
   - RAII patterns (C++)
   - Smart pointers usage (C++: unique_ptr, shared_ptr)
   - Exception safety and error handling
   - Undefined behavior prevention
   - Modern C++ features (C++11/14/17/20 standards)
   - Header guards or #pragma once
   - Const correctness
   - Move semantics (C++)

### 14. Terraform Best Practices
   - Security: IAM policies (least privilege), encryption at rest/transit, public access restrictions
   - State management and backend configuration
   - Resource naming conventions and tagging
   - Use of variables, locals, and outputs appropriately
   - Module structure and reusability
   - Proper use of data sources vs resources
   - Lifecycle management (prevent_destroy, create_before_destroy)
   - Dependencies and ordering (depends_on usage)
   - Terraform formatting (terraform fmt compliance)
   - Version constraints for providers and modules
   - Sensitive data handling (sensitive = true on outputs)
   - Cost optimization opportunities

### 15. Dockerfile Best Practices
   - Use specific base image tags (avoid :latest)
   - Multi-stage builds for smaller images
   - Layer caching optimization (order of COPY/ADD)
   - Security: run as non-root user, scan for vulnerabilities
   - Minimize layers and image size
   - Use .dockerignore to exclude unnecessary files
   - COPY vs ADD usage (prefer COPY)
   - Health checks (HEALTHCHECK instruction)
   - Proper signal handling (ENTRYPOINT vs CMD)
   - Secrets management (avoid ARG for secrets)

### 16. Makefile Best Practices
   - Proper use of .PHONY for non-file targets
   - Variables and pattern rules usage
   - Dependency management between targets
   - Error handling (use of set -e, || exit)
   - Cross-platform compatibility considerations
   - Clear target naming and documentation
   - Avoid hardcoded paths, use variables
   - Parallel execution safety (-j flag compatibility)
   - Use of $(shell) vs backticks
   - Proper quoting and escaping

### 17. CI/CD Configuration (.gitlab-ci.yml, GitHub Actions, etc.)
   - Security: secret management, no hardcoded credentials
   - Proper use of stages and dependencies
   - Job artifacts and caching strategies
   - Conditional execution (rules, only, except)
   - Retry and timeout configurations
   - Matrix builds for multiple versions/platforms
   - Fail-fast vs complete pipeline strategies
   - Resource limits and runner tags
   - Version pinning for actions/images
   - Proper environment variable usage
   - Code quality and security scanning integration
   - Deployment strategies (manual gates, rollback plans)

### 18. YAML/JSON Configuration Files
   - Valid syntax and structure
   - Proper indentation (YAML: spaces not tabs)
   - Security: no sensitive data in config files
   - Schema validation where applicable
   - Comments for complex configurations
   - Environment-specific configurations
   - Avoid duplication (use anchors/references in YAML)

### 19. Jsonnet/Libsonnet Best Practices
   - Proper use of local, function, and self keywords
   - Avoid deep nesting, use local bindings for clarity
   - Parameterization via function arguments or external variables
   - Use of std library functions (std.join, std.map, etc.)
   - Proper string formatting and concatenation
   - Import statements organization and dependencies
   - Avoid code duplication, extract reusable functions
   - Consistent naming conventions for functions and variables
   - Comments and documentation for complex logic
   - Formatting and indentation consistency

### 20. Qbec Best Practices
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

### 21. Code Quality & Organization
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

### 22. Project-Specific Concerns
   - AWS SDK proper usage
   - Cloud provider best practices (AWS, Azure, GCP)
   - Database query optimization
   - Proper logging practices
   - Configuration management
   - CI/CD pipeline compatibility

## Output Format

**Priority Guidelines:**
- **P0 (Critical)**: Security vulnerabilities, data loss risks, production-breaking issues
- **P1 (High)**: Missing validation, error handling gaps, framework misuse, potential bugs
- **P2 (Medium)**: Code quality issues, linting problems, non-idiomatic code, minor best practice violations
- **P3 (Low)**: Style improvements, documentation, optimization opportunities

### For Merge Request Reviews (Option 1):
Present findings as formatted feedback to share with the developer:
- Organize by priority level (P0 → P1 → P2 → P3)
- For each finding include:
  - File path and line number (e.g., "auth.go:42")
  - Priority level
  - Specific, actionable description with context
  - Why this matters and recommended fix
- Format in clear markdown suitable for merge request comments

### For Full Repository Scans (Option 2):
Use the TodoWrite tool to create trackable todo items:
- Each todo should include:
  - Priority label in the content (e.g., "[P0] Fix SQL injection in auth.go:42")
  - File path and line number
  - Specific and actionable description
- Organize systematically so items can be worked through in priority order
