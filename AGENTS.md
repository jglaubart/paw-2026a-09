# Platea — Project Context for Claude

## What is this project

**Platea** is a university project (PAW — Programación Avanzada en la Web, ITBA) for a theatre/play ticketing web application. Built with Spring MVC 5.3, JSP/JSTL, Maven multi-module, Java 21. Runs on Jetty. Database: PostgreSQL.

---

## Complete File System Structure

```
paw-2026a-09/
├── pom.xml                              ← Parent POM (version mgmt, shared deps)
│
├── models/                              ← Plain domain entity POJOs
│   └── pom.xml
│
├── service-contracts/                   ← Interfaces only (services + DAOs)
│   └── pom.xml
│
├── services/                            ← @Service implementations
│   └── pom.xml
│
├── persistence/                         ← @Repository JDBC implementations
│   ├── pom.xml
│   └── src/main/
│       ├── java/ar/edu/itba/paw/persistence/
│       └── resources/
│           ├── schema.sql
│           ├── seed.sql
│           └── migration_*.sql          ← incremental migrations
│
└── webapp/                              ← WAR module (Spring MVC + JSP)
    ├── pom.xml
    └── src/main/
        ├── java/ar/edu/itba/paw/webapp/
        │   ├── auth/
        │   │   ├── PawUserDetailsService.java  ← implements UserDetailsService
        │   │   └── PawAuthUser.java            ← implements UserDetails, wraps User
        │   ├── config/
        │   │   ├── WebConfig.java              ← Spring MVC config
        │   │   └── WebSecurityConfig.java      ← Spring Security config
        │   ├── controller/
        │   │   ├── HomeController.java
        │   │   ├── ObraController.java
        │   │   ├── ProductionController.java
        │   │   ├── ProductoraController.java
        │   │   ├── SearchController.java
        │   │   ├── UserController.java
        │   │   ├── WatchlistController.java
        │   │   ├── SeenController.java
        │   │   ├── RatingController.java
        │   │   ├── ReviewController.java
        │   │   ├── ImageController.java
        │   │   ├── PlayPetitionController.java
        │   │   └── AdminPlayPetitionController.java
        │   └── form/
        │       ├── RegisterForm.java
        │       └── PlayPetitionForm.java
        └── webapp/
            ├── WEB-INF/
            │   ├── web.xml
            │   ├── views/
            │   │   ├── index.jsp
            │   │   ├── obras/detail.jsp
            │   │   ├── productions/list.jsp
            │   │   ├── productions/detail.jsp
            │   │   ├── productoras/detail.jsp
            │   │   ├── search/results.jsp
            │   │   ├── users/
            │   │   │   ├── login.jsp
            │   │   │   ├── register.jsp
            │   │   │   └── profile.jsp
            │   │   ├── wishlist/index.jsp
            │   │   └── watchlist/index.jsp
            │   └── tags/
            │       ├── alert.tag
            │       ├── button.tag
            │       ├── card.tag
            │       ├── hero.tag
            │       ├── navbar.tag
            │       ├── playDetail.tag
            │       ├── productionCard.tag
            │       ├── search.tag
            │       └── sectionRow.tag
            ├── css/
            │   ├── main.css
            │   └── components/
            │       ├── alert.css
            │       ├── auth.css             ← login + register pages
            │       ├── button.css
            │       ├── card.css
            │       ├── hero.css
            │       ├── navbar.css
            │       ├── play-detail.css
            │       ├── production-card.css
            │       ├── home-page.css
            │       ├── productora-detail.css
            │       ├── production-detail-page.css
            │       ├── production-list-page.css
            │       ├── search.css
            │       ├── search-results-page.css
            │       └── section-row.css
            └── images/
                └── Portadas/
```

This document is a living guide. Keep it synchronized with the repository when architecture or conventions change.

---

## Module Structure & Maven Conventions

- Parent POM: `ar.edu.itba.paw:platea` — holds `<dependencyManagement>` for all versions.
- Child POMs declare dependencies **without versions** (inherited).
- Spring version property: `${spring.version}` = `5.3.33`.
- Spring Security version: `${spring.security.version}` = `5.8.x` — kept **separate** from Spring Framework version.
- Run locally: `cd webapp && mvn jetty:run` → `http://localhost:8080/`

### Dependency rules (compile-time enforced via Maven scopes)

```
webapp          --compile-->  service-contracts
webapp          --runtime-->  services
webapp          --runtime-->  persistence
services        --compile-->  service-contracts
persistence     --compile-->  service-contracts
models          ← no Spring deps, just POJOs
```

**Do not add compile dependencies across non-adjacent layers.** This makes layer violations compile errors. When adding `persistence` module to webapp's pom, use `<scope>runtime</scope>`.

---

## Layer Architecture

### The call chain — only downward, never skipping

```
[Browser]
    ↓ HTTP request
[@Controller]  webapp / ar.edu.itba.paw.webapp.controller
    ↓ calls interface (compiled against service-contracts)
[@Service]     services / ar.edu.itba.paw.services
    ↓ calls interface (compiled against service-contracts)
[@Repository]  persistence / ar.edu.itba.paw.persistence
    ↓ SQL via JdbcTemplate
[PostgreSQL]
```

Models (`ar.edu.itba.paw.models`) flow **up** through all layers as data carriers — every layer can use them, but only `persistence` creates instances from DB rows.

---

### What each layer IS and IS NOT

#### `webapp` — `@Controller`
**IS:** Receives HTTP request → extracts params → calls one service method → passes result to a JSP view.
**IS NOT:** Does not contain `if` logic about business rules, does not call `@Repository` directly, does not send emails, does not build SQL, does not create domain objects.
**Package:** `ar.edu.itba.paw.webapp.controller`
**Knows about:** `service-contracts` interfaces, Spring MVC annotations, `HttpServletRequest/Response`, `ModelAndView`, JSP view names.
**Cannot import:** anything from `ar.edu.itba.paw.services` or `ar.edu.itba.paw.persistence` (runtime-only deps — compile error if attempted).

#### `services` — `@Service`
**IS:** Implements all business logic and use-case rules. Orchestrates calls to one or more DAOs. Sends emails. Validates business constraints (not HTTP constraints). Returns `Optional<T>` or domain objects.
**IS NOT:** Does not know about HTTP, does not build HTML, does not write SQL, does not call other `@Service` beans sideways (services do not call each other — extract shared logic to a helper or lower layer).
**Package:** `ar.edu.itba.paw.services`
**Knows about:** `service-contracts` interfaces (both `*Service` and `*Dao`), `models`, Spring `@Async`, email libraries.
**Cannot import:** anything from `ar.edu.itba.paw.webapp` or `ar.edu.itba.paw.persistence` (runtime-only — compile error if attempted).

#### `persistence` — `@Repository`
**IS:** Translates between Java objects and SQL. CRUD operations via `JdbcTemplate`/`SimpleJdbcInsert`. Returns `Optional<T>` or `List<T>`. Maps `ResultSet` rows to model objects via `RowMapper`.
**IS NOT:** Does not contain business logic, does not apply rules, does not send emails, does not call `@Service` beans.
**Package:** `ar.edu.itba.paw.persistence`
**Knows about:** `service-contracts` DAO interfaces, `models`, `JdbcTemplate`, `SimpleJdbcInsert`, `DataSource`.
**Cannot import:** anything from `ar.edu.itba.paw.webapp` or `ar.edu.itba.paw.services`.

#### `models` — plain POJOs
**IS:** Java classes representing domain entities (e.g., `User`, `Play`, `Image`). Private fields, public getters, no-arg constructor, implements `Serializable`.
**IS NOT:** No Spring annotations, no JDBC, no HTTP, no logic — pure data containers.
**Package:** `ar.edu.itba.paw.models`
**Knows about:** nothing (no dependencies).

#### `service-contracts` — interfaces only
**IS:** The compile-time boundary. Defines `interface UserService`, `interface UserDao`, etc. No implementations ever.
**Why it exists:** `webapp` compiles against these interfaces but cannot see the implementations (`services`/`persistence` are runtime-only). This makes calling the wrong layer a **compile error**, not a runtime surprise.
**Package:** `ar.edu.itba.paw.interfaces.services` and `ar.edu.itba.paw.interfaces.persistence`
**Knows about:** `models` only.

---

### "Where does this code go?" — decision guide

| What you're implementing | Layer | Module |
|--------------------------|-------|--------|
| Parse a request param, call a service, return a view name | Controller | `webapp` |
| Validate that a user is not already registered | Service | `services` |
| Hash a password | Service | `services` |
| Send a confirmation email | Service | `services` (via `@Async`) |
| Find a user by email in the DB | DAO impl | `persistence` |
| INSERT a new play into the DB | DAO impl | `persistence` |
| Define `interface UserService` | Contract | `service-contracts` |
| Define `interface UserDao` | Contract | `service-contracts` |
| Define `class User` (id, name, email…) | Model | `models` |
| Render HTML, apply CSS | View | `webapp` JSP/tag |
| Spring Security wiring, `UserDetailsService` | Auth | `webapp/auth/` |

**If logic could be extracted to a service test without a web server — it belongs in `services`, not the controller.**
**If logic touches a SQL table — it belongs in `persistence`, not `services`.**

---

### Forbidden patterns (penalized in grading)

```
// WRONG — controller calling DAO directly (skips service layer)
@Controller
class PlayController {
    @Autowired PlayDao playDao;  // ← compile error (runtime dep), and conceptually wrong
}

// WRONG — business logic inside a controller
@Controller
class UserController {
    public String register(...) {
        if (userDao.findByEmail(email).isPresent()) { ... }  // ← belongs in service
    }
}

// WRONG — service sending its own SQL
@Service
class UserServiceImpl {
    public User register(...) {
        jdbcTemplate.update("INSERT ...");  // ← belongs in persistence
    }
}

// WRONG — controller sending email
@Controller
class UserController {
    public String register(...) {
        mailSender.send(...);  // ← belongs in service
    }
}

// WRONG — service calling another service
@Service
class PlayServiceImpl {
    @Autowired UserService userService;  // ← services do not call each other
}

// WRONG — hardcoded user ID
private static final long HARDCODED_USER_ID = 1L;  // ← use @AuthenticationPrincipal
```

---

## Spring MVC Conventions

- `@ComponentScan` in `WebConfig`: `ar.edu.itba.paw.webapp.controller`, `ar.edu.itba.paw.services`, `ar.edu.itba.paw.persistence`.
- `@ComponentScan` must also cover `ar.edu.itba.paw.webapp.auth` for `PawUserDetailsService`.
- Views resolved as: `/WEB-INF/views/<name>.jsp` via `InternalResourceViewResolver` (prefix + suffix in `WebConfig`).
- Static resources: `/css/**` → `/css/`, `/images/**` → `/images/` (configured in `WebConfig.addResourceHandlers`).
- Controller methods return `String` (view name) or `ModelAndView`.
- Use `@RequestParam` for query params, `@PathVariable` for path segments.
- Path variable type validation via regex: `@RequestMapping("/{id:\\d+}")`.
- Return `Optional<T>` from service/DAO methods — never `null`.
- All Spring beans (`@Controller`, `@Service`, `@Repository`) must be **stateless** — no mutable instance fields.

---

## JSP View Conventions

### File locations

- Pages: `WEB-INF/views/<feature>/<page>.jsp` — never in public webapp root.
- Tags: `WEB-INF/tags/<ComponentName>.tag` — camelCase, one file per component.
- Each view or tag links its own CSS; no global CSS import in tags.

### Required taglib declarations in every JSP/tag

```jsp
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions" %>   <%-- only if needed --%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>       <%-- for i18n messages --%>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>  <%-- only for forms --%>
<%@ taglib prefix="sec"    uri="http://www.springframework.org/security/tags" %> <%-- only if auth checks --%>
<%@ taglib prefix="paw"    tagdir="/WEB-INF/tags" %>                          <%-- only if composing tags --%>
```

### Security rules (non-negotiable)

- **Text content:** always `<c:out value="${var}" />` — never raw `${var}` for user-supplied data.
- **HTML attributes (alt, title, etc.):** always `${fn:escapeXml(var)}`.
- **URLs:** always `<c:url var="resolvedX" value="${rawUrl}" />` then use `${resolvedX}` — ensures correct context path.
- Direct string concatenation into attributes or HTML is forbidden.

### CSS linking in JSPs

```jsp
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/css/components/button.css" />
```

Always use `${pageContext.request.contextPath}` for all static asset paths.

---

## Custom Tag File Conventions (`WEB-INF/tags/`)

Every `.tag` file must follow this pattern:

```jsp
<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="attrName" required="true/false" [type="java.lang.Boolean"] %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>   <%-- only if composing other tags --%>

<%-- 1. Resolve defaults for optional attributes using c:set --%>
<c:set var="localVar" value="${not empty attrName ? attrName : 'default'}" />

<%-- 2. Resolve optional URLs before use --%>
<c:if test="${not empty someUrl}">
    <c:url var="resolvedSomeUrl" value="${someUrl}" />
</c:if>

<%-- 3. Render HTML using c:out for text, fn:escapeXml for attributes --%>
```

**Boolean attribute pattern** — always declare with `type="java.lang.Boolean"` and handle null:
```jsp
<%@ attribute name="disabled" required="false" type="java.lang.Boolean" %>
<c:set var="isDisabled" value="${disabled ne null ? disabled : false}" />
```

**Tag composition** — tags may use `<paw:button>` and other `<paw:*>` tags internally.

### Layout tags (page-level structure)

Every page must use `<paw:navbar>` as its `<header>` and place `<paw:hero>` **outside** `<main>` for full-width rendering. Content sections (`<paw:sectionRow>`) go **inside** `<main>`.

```html
<body>
    <paw:navbar [activeSection="cartelera|teatros|experiencias"] />
    <paw:hero ... />        ← full-width, outside <main>
    <main>
        <paw:sectionRow ...>
            <paw:productionCard ... />
        </paw:sectionRow>
    </main>
</body>
```

### Existing tags and their attributes

#### `<paw:button>`
| Attribute | Required | Type | Default | Notes |
|-----------|----------|------|---------|-------|
| `text` | yes | String | — | Button label |
| `size` | no | String | `md` | `sm`, `md`, `lg` |
| `cssClass` | no | String | `''` | Extra CSS classes |
| `disabled` | no | Boolean | `false` | |
| `ariaLabel` | no | String | — | |

#### `<paw:card>`
| Attribute | Required | Type | Notes |
|-----------|----------|------|-------|
| `title` | yes | String | Play title |
| `imageUrl` | no | String | Falls back to `/images/placeholder.jpg` |
| `detailUrl` | no | String | If present, card becomes a link; resolved via `<c:url>` |

#### `<paw:alert>`
| Attribute | Required | Type | Default | Notes |
|-----------|----------|------|---------|-------|
| `message` | yes | String | — | |
| `title` | no | String | — | |
| `variant` | no | String | `info` | `info`, `success`, `warning`, `error` |
| `showClose` | no | Boolean | `true` | |

#### `<paw:search>`
| Attribute | Required | Type | Default | Notes |
|-----------|----------|------|---------|-------|
| `name` | yes | String | — | Input `name` attribute |
| `type` | no | String | `text` | Input type |
| `placeholder` | no | String | — | |
| `value` | no | String | — | Pre-filled value |
| `error` | no | String | — | Shows `.search-error-msg` and `.search-input-error` class |
| `required` | no | Boolean | — | |
| `minlength` | no | String | — | |
| `maxlength` | no | String | — | |
| `pattern` | no | String | — | |
| `title` | no | String | — | Tooltip |

#### `<paw:navbar>`
| Attribute | Required | Type | Notes |
|-----------|----------|------|-------|
| `activeSection` | no | String | `cartelera`, `teatros`, or `experiencias` — highlights the matching nav link |

Renders `<header class="navbar">`. Reuses `<paw:search>` internally. Sticky, `z-index: 100`.
After auth is wired, shows Login/Register links for anonymous users and username/Logout for authenticated users via `<sec:authorize>`.

#### `<paw:hero>`
| Attribute | Required | Type | Default | Notes |
|-----------|----------|------|---------|-------|
| `title` | yes | String | — | Rendered uppercase |
| `description` | no | String | — | Short subtitle below title |
| `imageUrl` | no | String | — | Full resolved URL (prepend `${pageContext.request.contextPath}`) |
| `badge` | no | String | `DESTACADO` | Featured badge text |
| `rating` | no | String | — | e.g., `4.9/5.0` |
| `ticketUrl` | no | String | — | If set, "Reservar Entradas" renders as `<a>` instead of `<button>` |

#### `<paw:productionCard>`
| Attribute | Required | Type | Notes |
|-----------|----------|------|-------|
| `title` | yes | String | Rendered uppercase |
| `imageUrl` | no | String | Full resolved URL |
| `venue` | no | String | Theater name shown below title |
| `rating` | no | String | e.g., `4.9` — shown with amber star |
| `badge` | no | String | Overlay badge (e.g., `TOP1`) — amber pill top-right of image |
| `detailUrl` | no | String | If set, image area wraps in `<a>`; resolved via `<c:url>` |

#### `<paw:sectionRow>`
| Attribute | Required | Type | Notes |
|-----------|----------|------|-------|
| `title` | yes | String | Section title (large bold italic) |
| `subtitle` | no | String | Small uppercase subtitle below title |

#### `<paw:playDetail>`
| Attribute | Required | Type | Notes |
|-----------|----------|------|-------|
| `title` | yes | String | |
| `imageUrl` | no | String | Shows placeholder div if absent |
| `productionName` | no | String | |
| `year` | no | String | |
| `location` | no | String | |
| `averageRating` | no | String | Shows rating row with "Ver opiniones" button |
| `summary` | no | String | |
| `ticketUrl` | no | String | Resolved via `<c:url>` |
| `reviewsUrl` | no | String | Resolved via `<c:url>` |
| `otherEditions` | no | String | Format: `year;production;location~year2;production2;location2` |
| `seen` | no | Boolean | default `false` |
| `inWishlist` | no | Boolean | default `false` |
| `currentlyRunning` | no | Boolean | default `false` |
| `expiringSoon` | no | Boolean | default `false` |

---

## Forms & Validation (JSR 303)

### Form beans

All HTML form inputs must bind to a **form bean** in `ar.edu.itba.paw.webapp.form`:
- Private fields + public getters/setters
- Public no-arg constructor
- JSR 303 annotations for constraint validation

```java
public class RegisterForm {
    @NotEmpty @Email
    private String email;

    @NotEmpty @Size(min = 8, max = 64)
    private String password;

    @NotEmpty
    private String repeatPassword;

    // getters + setters
}
```

### Controller usage

```java
@RequestMapping(value = "/register", method = RequestMethod.POST)
public ModelAndView register(@Valid @ModelAttribute("registerForm") RegisterForm form,
                              final BindingResult errors) {
    if (errors.hasErrors()) {
        return registerView(form);
    }
    // delegate to service
}
```

- `@Valid` triggers JSR 303 validation.
- `BindingResult` must immediately follow the `@ModelAttribute` parameter.
- `@ModelAttribute("name")` both binds the form object and adds it to the model.

### Spring Form taglib in JSP

```jsp
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<form:form modelAttribute="registerForm" action="..." method="post">
    <form:input path="email" />
    <form:errors path="email" element="span" cssClass="field-error" />
</form:form>
```

### Overriding validation messages

In `messages.properties`:
```properties
NotEmpty.registerForm.email=El email es obligatorio
Size.registerForm.password=La contraseña debe tener al menos {2} caracteres
Email.registerForm.email=Ingresá un email válido
```

---

## Internationalization (i18n)

### Properties file naming convention

- `messages.properties` — default (fallback)
- `messages_es.properties` — Spanish
- `messages_es_AR.properties` — Spanish (Argentina) — most specific, tried first

Files live in `src/main/resources/i18n/` (or `mail/` for email templates).

### Using messages in JSP

```jsp
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:message code="register.title" />
<spring:message code="welcome.greeting" arguments="${user.email}" />
```

### Rules

- Every user-visible string must be externalized via `<spring:message>`.
- Email templates (Thymeleaf) must also use `#{key}` message syntax.
- Test with at least two locales before final delivery.
- `@ModelAttribute` on a controller method adds an object to every request's model — useful for attaching the current logged-in user to all views.

---

## Spring Security

Spring Security is a **separate module** — its version is NOT kept in sync with Spring Framework.

### Modules required (`webapp/pom.xml`)

```xml
<dependency>spring-security-web</dependency>
<dependency>spring-security-config</dependency>
<dependency>spring-security-taglibs</dependency>  <!-- for <sec:authorize> in JSP -->
```

### Security filter in `web.xml`

Add `DelegatingFilterProxy` for `springSecurityFilterChain` **before** the dispatcher servlet:

```xml
<filter>
    <filter-name>springSecurityFilterChain</filter-name>
    <filter-class>org.springframework.web.filter.DelegatingFilterProxy</filter-class>
</filter>
<filter-mapping>
    <filter-name>springSecurityFilterChain</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

Also add `WebSecurityConfig` to `contextConfigLocation`:
```xml
<param-value>ar.edu.itba.paw.webapp.config.WebConfig,ar.edu.itba.paw.webapp.config.WebSecurityConfig</param-value>
```

### `WebSecurityConfig` (separate from `WebConfig`)

```java
@Configuration
@EnableWebSecurity
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    @Autowired private PawUserDetailsService userDetailsService;

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.userDetailsService(userDetailsService).passwordEncoder(passwordEncoder());
    }

    @Override
    protected void configure(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
                .antMatchers("/", "/search/**", "/obras/**", "/productions/**", "/productoras/**", "/images/**").permitAll()
                .antMatchers("/login", "/register").anonymous()
                .anyRequest().authenticated()
            .and().formLogin()
                .loginPage("/login")
                .defaultSuccessUrl("/", false)
                .failureUrl("/login?error")
            .and().logout()
                .logoutUrl("/logout")
                .logoutSuccessUrl("/");
    }
}
```

### `PawUserDetailsService` (`webapp/auth/`)

Not a PAW `@Service` — it is a Spring Security `@Component`:

```java
@Component
public class PawUserDetailsService implements UserDetailsService {
    @Autowired private UserService userService;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        return userService.findByEmail(email)
            .map(PawAuthUser::new)
            .orElseThrow(() -> new UsernameNotFoundException("User not found: " + email));
    }
}
```

### `PawAuthUser` (`webapp/auth/`)

```java
public class PawAuthUser implements UserDetails {
    private final User user;

    public PawAuthUser(User user) { this.user = user; }

    public User getUser() { return user; }

    @Override public String getUsername() { return user.getEmail(); }
    @Override public String getPassword() { return user.getPassword(); }
    @Override public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.singletonList(new SimpleGrantedAuthority("ROLE_USER"));
    }
    // isAccountNonExpired/Locked/CredentialsNonExpired/isEnabled → all true
}
```

### Password encoding

- **Always** `BCryptPasswordEncoder` — plain-text passwords are penalized.
- Encode in `UserServiceImpl.create()`, NOT in the controller or DAO.

### Getting the logged-in user in controllers

```java
@RequestMapping("/users/me")
public ModelAndView profile(@AuthenticationPrincipal PawAuthUser authUser) {
    long userId = authUser.getUser().getId();
    // ...
}
```

**Never** use hardcoded `HARDCODED_USER_ID = 1L`. Replace with `@AuthenticationPrincipal`.

### Auth checks in JSP (navbar, conditional UI)

```jsp
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<sec:authorize access="isAnonymous()">
    <a href="<c:url value='/login' />">Iniciar sesión</a>
    <a href="<c:url value='/register' />">Registrarse</a>
</sec:authorize>

<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal.user.email" var="currentEmail" />
    <c:out value="${currentEmail}" />
    <a href="<c:url value='/logout' />">Cerrar sesión</a>
</sec:authorize>
```

### ACL model

- **Roles** define functionality: `ROLE_USER`, `ROLE_ADMIN`.
- **Resources** are URL patterns.
- **Permissions** say whether a role can access a resource.
- One user can have multiple roles — do NOT model roles as user profile types.

---

## Logging

### Framework

SLF4J as the API, Logback as the implementation. **Never** use `System.out.println` or `java.util.logging`.

### Defining a logger (one per class)

```java
private static final Logger LOGGER = LoggerFactory.getLogger(UserController.class);
```

Import from `org.slf4j`, not from Logback directly.

### Log levels

| Level | When to use |
|-------|-------------|
| `ERROR` | Unexpected failures requiring attention |
| `WARN` | Unexpected but recoverable situations |
| `INFO` | Key lifecycle events (startup, registration, login) |
| `DEBUG` | Detailed trace — development only |

### Placeholder syntax — never concatenate Strings

```java
// CORRECT
LOGGER.info("User registered: {}", email);
LOGGER.error("Email failed for {}: {}", email, e.getMessage(), e);

// WRONG — always allocates String even if level is disabled
LOGGER.info("User registered: " + email);
```

### Dual config (dev / prod)

- `src/main/resources/logback-test.xml` — development: console appender, DEBUG level.
- `src/main/resources/logback.xml` — production: rolling file appender, INFO level.
- Maven WAR plugin excludes `logback-test.xml` from the WAR.
- Use `additivity="false"` on package-level loggers to stop upward propagation.

### Required log coverage

Log at appropriate levels around:
- Application startup / DB initialization
- User registration and authentication events (login, logout, failures)
- Email sending (attempt, success, failure)
- Multipart file upload handling
- Any caught exception

---

## AOP & Transactions

### Why AOP

AOP separates cross-cutting concerns (transactions, logging, security) from business logic. Spring implements AOP via **proxies** that intercept external method calls.

### Key proxy constraint

AOP advice only fires on **external** calls (through the proxy). Self-calls within the same bean bypass the proxy — `@Transactional` on a private/internal method has no effect.

### `@Transactional` usage

- Apply at **service layer** methods that span multiple DAO calls.
- One transaction = one use-case.
- Email sending must be `@Async` — never inside the same transaction.
- Requires `@EnableTransactionManagement` in `WebConfig` and a `PlatformTransactionManager` bean.

```java
@Service
public class UserServiceImpl implements UserService {
    @Transactional
    public User create(String email, String password) {
        return userDao.create(email, passwordEncoder.encode(password));
    }
}
```

---

## Unit Testing

### Test structure (AAA — Arrange / Act / Assert)

1. **Arrange** — set up preconditions and mocks
2. **Act** — single method call on the object under test
3. **Assert** — postconditions (max 4 assertions)

The object under test must only be touched in the Act phase.

### Service tests with Mockito

```java
@RunWith(MockitoJUnitRunner.class)
public class UserServiceImplTest {

    @Mock private UserDao userDao;
    @InjectMocks private UserServiceImpl userService;

    @Test
    public void testCreate_newUser_returnsUser() {
        when(userDao.create(anyString(), anyString()))
            .thenReturn(new User(1L, "a@b.com", "hash"));

        User result = userService.create("a@b.com", "secret");

        assertEquals("a@b.com", result.getEmail());
    }
}
```

- Prefer `@InjectMocks` + `@Mock` over manual instantiation.
- Do NOT use `Mockito.verify(...)` — tests implementation details, not contract behaviour.

### DAO integration tests with HSQL

```java
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = TestConfig.class)
public class UserDaoImplTest {

    @Autowired private UserDao userDao;
    @Autowired private JdbcTemplate jdbcTemplate;

    @Before
    public void setUp() {
        JdbcTestUtils.deleteFromTables(jdbcTemplate, "users");
    }

    @Test
    public void testFindById_existingUser_returnsUser() {
        jdbcTemplate.update("INSERT INTO users (email, password) VALUES (?,?)", "a@b.com", "hash");
        long id = jdbcTemplate.queryForObject("SELECT id FROM users WHERE email=?", Long.class, "a@b.com");

        Optional<User> result = userDao.findById(id);

        assertTrue(result.isPresent());
        assertEquals("a@b.com", result.get().getEmail());
    }
}
```

`TestConfig.java` provides an HSQL in-memory `DataSource` and loads `schema.sql`.

---

## CSS Architecture

### File structure rules

- `css/main.css` — global reset, `*` box-sizing, `body`, `header`, `main`, `h2` base styles only.
- `css/components/<component>.css` — one file per tag/component, named in kebab-case.
- **Never put component styles in `main.css`.**
- **Never put global styles in a component file.**
- Each JSP view links `main.css` + every component CSS it uses, in `<head>`.

### Naming convention — Component-scoped BEM-like

Pattern: `.<component>-<element>` and `.<component>-<modifier>`.

**All class names are lowercase kebab-case. No camelCase, no underscores.**

### Layout primitives

- Use **CSS Grid** for page-level and multi-column layouts.
- Use **Flexbox** for single-axis component internals.
- Never use inline `style=""` attributes in HTML.
- Never use `float` for layout.

### Design tokens (dark theme)

| Token | Value | Usage |
|-------|-------|-------|
| Background | `#141414` | `body` background |
| Header bg | `#000` | `header` / navbar background |
| Primary purple | `#7c3aed` | Logo, `.btn-primary`, CTA buttons |
| Primary purple hover | `#6d28d9` | `.btn-primary:hover` |
| Amber/featured | `#f5a623` | `hero-badge-featured`, rating stars |
| Gold accent | `#cc9108` | Ticket CTA in playDetail, rating display |
| Error/danger | `#e50914` | Error states, `.search-input-error` |
| Text primary | `#fff` | Default text |
| Text muted | `rgba(255,255,255,0.80–0.88)` | Secondary text |
| Text subtle | `rgba(255,255,255,0.45–0.65)` | Nav links, venue names |
| Surface subtle | `rgba(255,255,255,0.04–0.12)` | Cards, badges, search bg |
| Border subtle | `rgba(255,255,255,0.08–0.18)` | Card/panel/input borders |

**Hardcoding colors outside of their established component is forbidden.**

### Responsive design

- Add `@media (max-width: 768px)` blocks inside the component's CSS file when needed.
- Collapse grid to single column on mobile.

---

## Java Package Structure

```
ar.edu.itba.paw.
├── webapp.
│   ├── auth.
│   │   ├── PawUserDetailsService      ← Spring Security UserDetailsService
│   │   └── PawAuthUser                ← UserDetails wrapper over domain User
│   ├── config.
│   │   ├── WebConfig                  ← Spring MVC configuration
│   │   └── WebSecurityConfig          ← Spring Security configuration
│   ├── controller.*Controller         ← @Controller classes
│   └── form.*Form                     ← form beans (JSR 303 validation)
├── services.*ServiceImpl              ← @Service implementations
├── interfaces.
│   ├── services.*Service              ← Service interfaces
│   └── persistence.*Dao               ← DAO interfaces
├── persistence.*DaoImpl               ← @Repository JDBC implementations
└── models.*                           ← Domain entity POJOs
```

---

## Database Conventions

- Use `JdbcTemplate` for SELECT/UPDATE/DELETE — never raw JDBC.
- Use `SimpleJdbcInsert` for INSERT — never hand-build INSERT strings.
- **Parameterized queries only** — `?` placeholders, never string concatenation (SQL injection).
- `RowMapper<T>` defined as `private static final` field (stateless lambda or static inner class).
- DAO methods return `Optional<T>` for single-result queries, `List<T>` for multi-result.
- Never return `null` from a DAO or service.
- IDs are `SERIAL` (auto-generated) in PostgreSQL.
- `DataSource` bean defined in `WebConfig.java`.

### Image storage pattern

- Separate `images` table with `id` and `content` (binary) columns. Domain tables reference `image_id` as a foreign key.
- Never JOIN the images table alongside domain data — fetch separately through dedicated image endpoints.
- Expose images via a dedicated `ImageController` endpoint returning `ResponseEntity<byte[]>`.
- Never store or render images as Base64.
- Upload via `multipart/form-data`; bind with `@ModelAttribute` + `MultipartFile`.

---

## Email Conventions

- Send emails **only from the services layer** — never from controllers or persistence.
- Mark email methods `@Async` — email must never block the request thread.
- `@EnableAsync` is in `WebConfig`.
- Thymeleaf is the compulsory template engine for emails.
- Templates must be internationalized (i18n) — test with multiple locales.
- Email structure: header (site branding) → body (reason/content) → call-to-action link → footer (optional).
- Every email must include a clear call to action and information the user does not already know.

---

## Static Resources

- Reference static assets with `${pageContext.request.contextPath}/...` or `<c:url>`. Do not hardcode absolute URLs.
- Keep `WebConfig.addResourceHandlers(...)` aligned with any new static folders.

---

## Pampero Deploy Guide

- Deployment target: `Tomcat 9.0.107-dev` on `pampero.itba.edu.ar`.
- Final artifact: WAR uploaded as `/web/app.war`.
- `sftp paw-2026a-#i@10.16.1.110` → `put web/app.war web/app.war`
- DB: `psql -h 10.16.1.110 -U paw-2026a-$i`
- Logs: `http://pawserver.it.itba.edu.ar/logs/paw-2026a-01-webapp.YYYY-MM-DD.log`
- Final URL: `http://pawserver.it.itba.edu.ar/paw-2026a-#i`

---

## Critical Coding Rules (violations are penalized)

1. **No business logic in controllers** — receive, validate, delegate, return view.
2. **No shared mutable state** — Spring beans must be stateless.
3. **No null returns** — use `Optional<T>` at every layer boundary.
4. **No raw SQL string construction** — `?` placeholders only.
5. **No `${var}` for user data in JSP** — always `<c:out value="${var}" />`.
6. **No raw URLs in JSP** — always `<c:url value="..." />`.
7. **No inline styles in HTML** — all styling in CSS files.
8. **No cross-layer compile dependencies** — Maven scopes enforce this.
9. **No Base64 images** — multipart upload, binary persistence, URL endpoint.
10. **No undocumented image storage changes** — update this file too.
11. **No blocking email sends** — always `@Async`.
12. **Emails from services only** — never from controllers.
13. **Every email needs i18n and a CTA** — both required for final delivery.
14. **Pampero WAR path is fixed** — `/web/app.war`.
15. **Immutability** — create new objects, never mutate existing ones.
16. **No plain-text passwords** — always `BCryptPasswordEncoder`.
17. **No hardcoded user IDs** — always `@AuthenticationPrincipal PawAuthUser`.
18. **No `Mockito.verify()`** in tests — tests contract behaviour, not implementation.

---

## Current State (2026-04-14)

**Implemented:**
- Multi-module Maven architecture: `models`, `service-contracts`, `services`, `persistence`, `webapp`
- `WebConfig` with `DataSource`, JSP view resolution, static resources, mail sender, Thymeleaf engine, `@EnableAsync`, multipart resolver
- PostgreSQL schema + seed data + multiple migration scripts
- Controllers: home, obras, productions, productoras, search, watchlist, seen, ratings, reviews, images, play petitions (admin + user)
- Service and DAO layers for all entities above
- `MailServiceImpl` with async email sending (Thymeleaf templates)
- JSP tags: `alert`, `button`, `card`, `hero`, `navbar`, `playDetail`, `productionCard`, `search`, `sectionRow`

**Still pending:**
- Spring Security (authentication not yet configured)
- Some controllers still use `HARDCODED_USER_ID = 1L` — replace with `@AuthenticationPrincipal`
- Registration form with JSR 303 validation
- i18n for all UI-facing strings (only mail messages currently externalized)
- Unit tests for service and DAO layers
