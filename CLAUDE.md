# Platea — Project Context for Codex

## What is this project

**Platea** is a university project (PAW — Programación Avanzada en la Web, ITBA) for a theatre/play ticketing web application. Built with Spring MVC 5.3, JSP/JSTL, Maven multi-module, Java 21. Runs locally on Jetty and deploys as a WAR to Tomcat on Pampero. Database: PostgreSQL.

---

## Complete File System Structure

```
paw-2026a-09/
├── pom.xml                              ← Parent POM (version mgmt, shared deps)
├── utils/
│   └── AGENTS.md                        ← This file
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
│           └── seed.sql
│
└── webapp/                              ← WAR module (Spring MVC + JSP)
    ├── pom.xml
    └── src/main/
        ├── java/ar/edu/itba/paw/webapp/
        │   ├── config/
        │   │   └── WebConfig.java       ← Spring config (@Configuration, component scan, ViewResolver, resources)
        │   └── controller/
        │       ├── HomeController.java
        │       ├── ObraController.java
        │       ├── ProductionController.java
        │       ├── ProductoraController.java
        │       ├── SearchController.java
        │       ├── UserController.java
        │       ├── WatchlistController.java
        │       ├── SeenController.java
        │       ├── RatingController.java
        │       └── ReviewController.java
        └── webapp/
            ├── WEB-INF/
            │   ├── web.xml              ← Servlet container config (DispatcherServlet, context listener)
            │   ├── views/               ← JSP pages (private — never accessible directly)
            │   │   ├── index.jsp
            │   │   ├── obras/detail.jsp
            │   │   ├── productions/list.jsp
            │   │   ├── productions/detail.jsp
            │   │   ├── productoras/detail.jsp
            │   │   ├── search/results.jsp
            │   │   ├── users/profile.jsp
            │   │   ├── wishlist/index.jsp
            │   │   └── watchlist/index.jsp
            │   └── tags/                ← Custom JSP tag files (.tag)
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
            │   ├── main.css             ← Global reset + base styles (body, header, main, h2)
            │   └── components/          ← One CSS file per UI component
            │       ├── alert.css
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
                └── Portadas/            ← Play cover images (jpg)
                    ├── hamilton.jpg
                    ├── hamlet.jpg
                    └── principito.jpg
```

This document is a living guide. Keep it synchronized with the repository when architecture or conventions change.

---

## Module Structure & Maven Conventions

- Parent POM: `ar.edu.itba.paw:platea` — holds `<dependencyManagement>` and `<pluginManagement>` for all versions.
- Child POMs declare dependencies and plugins **without versions** (inherited from parent).
- **All versions — dependencies and plugins — must be declared as `<properties>` in the parent POM.** Never hardcode a version number directly inside `<dependency>` or `<plugin>` tags.
- Run locally: `cd webapp && mvn jetty:run` → `http://localhost:8080/`

### Current version properties (parent `pom.xml`)

| Property | Value | Notes |
|----------|-------|-------|
| `spring.version` | `5.3.33` | Spring MVC, JDBC, context-support |
| `spring.security.version` | `5.8.10` | spring-security-web, config, core |
| `logback.version` | `1.4.14` | SLF4J 2.x compatible binding |
| `org.postgresql.version` | `42.7.3` | |
| `javax.servlet.version` | `4.0.1` | provided scope |
| `jstl.version` | `1.2` | |
| `thymeleaf-spring5.version` | `3.1.2.RELEASE` | email templates |
| `javax.mail.version` | `1.6.2` | |
| `commons-fileupload.version` | `1.5` | multipart |
| `jetty.plugin.version` | `9.4.58.v20250814` | local dev server |
| `maven.compiler.plugin.version` | `3.13.0` | |
| `maven.war.plugin.version` | `3.4.0` | |
| `maven.surefire.plugin.version` | `3.3.0` | |
| `maven.resources.plugin.version` | `3.3.1` | |
| `maven.clean.plugin.version` | `3.4.0` | |
| `maven.install.plugin.version` | `3.1.2` | |
| `maven.deploy.plugin.version` | `3.1.2` | |

### Dependency rules (compile-time enforced via Maven scopes)

```
webapp          --compile-->  service-contracts
webapp          --runtime-->  services
webapp          --runtime-->  persistence       (when created)
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
```

---

## Spring Security Conventions

Spring Security 5.8.10 is configured in `WebAuthConfig` (`ar.edu.itba.paw.webapp.config`).

### Setup
- `DelegatingFilterProxy` for `springSecurityFilterChain` registered in `web.xml` before all other filters.
- `WebAuthConfig` extends `WebSecurityConfigurerAdapter`, annotated `@Configuration @EnableWebSecurity`.
- `PasswordEncoder` bean (`BCryptPasswordEncoder`) lives in `WebConfig` — **not** in `WebAuthConfig` — to avoid a circular dependency with `PawUserDetailsService`.
- `@ComponentScan` covers `ar.edu.itba.paw.webapp` (not just the controller sub-package) so `PawUserDetailsService` and `PawUserDetails` in `ar.edu.itba.paw.webapp.auth` are picked up.

### Auth classes (`ar.edu.itba.paw.webapp.auth`)
- `PawUserDetails` — extends `org.springframework.security.core.userdetails.User`, wraps the domain `User` model, grants `ROLE_USER`.
- `PawUserDetailsService` — `@Component` implementing `UserDetailsService`, delegates to `UserService.findByEmail()`.

### Route rules
- `/users/me` — requires `ROLE_USER`.
- All other routes — `permitAll()`.
- Login form: `/login` (GET show, POST handled by Spring Security), parameters `email` / `password`.
- Logout: POST to `/logout` with CSRF token; redirects to `/login?logout=true`.

### Success handler
After login, a custom `AuthenticationSuccessHandler` redirects to `{contextPath}/users/me` via `response.sendRedirect()` — **not** `defaultSuccessUrl`. This avoids Jetty's UTF-8 query-string merging bug on JSP forwards.

```java
private AuthenticationSuccessHandler successHandler() {
    return (request, response, authentication) -> {
        response.sendRedirect(request.getContextPath() + "/users/me");
    };
}
```

### CSRF
CSRF is enabled. Every POST form must include:
```jsp
<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
```

### Auto-login after registration
`UserController.register()` calls `request.login(email, password)` after `userService.create()` to programmatically authenticate the new user, then redirects to `/users/me`.

### Accessing the logged-in user
Inject `@AuthenticationPrincipal PawUserDetails userDetails` into controller methods. Get the domain object via `userDetails.getUser()`.

### Checking auth state in JSP (no taglib needed)
```jsp
<c:choose>
    <c:when test="${pageContext.request.userPrincipal != null}">
        <%-- authenticated --%>
    </c:when>
    <c:otherwise>
        <%-- anonymous --%>
    </c:otherwise>
</c:choose>
```

---

## Spring MVC Conventions

- `@ComponentScan` in `WebConfig`: `ar.edu.itba.paw.webapp` (covers controllers, auth, and config sub-packages), `ar.edu.itba.paw.services`, `ar.edu.itba.paw.persistence`.
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
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>   <%-- only if needed --%>
<%@ taglib prefix="paw" tagdir="/WEB-INF/tags" %>                         <%-- only if composing tags --%>
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

CSS: `.btn .btn-{size} {cssClass}` — classes from `button.css`.

#### `<paw:card>`
| Attribute | Required | Type | Notes |
|-----------|----------|------|-------|
| `title` | yes | String | Play title |
| `imageUrl` | no | String | Falls back to `/images/placeholder.jpg` |
| `detailUrl` | no | String | If present, card becomes a link; resolved via `<c:url>` |

Renders `.obra-card`. If `detailUrl` present: wraps in `<a>` with `.obra-card-clickable`. Always includes `<paw:button>` for wishlist.

#### `<paw:alert>`
| Attribute | Required | Type | Default | Notes |
|-----------|----------|------|---------|-------|
| `message` | yes | String | — | |
| `title` | no | String | — | |
| `variant` | no | String | `info` | `info`, `success`, `warning`, `error` |
| `showClose` | no | Boolean | `true` | |

CSS class: `.alert .alert-{variant}`. Close button via `<paw:button>`.

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

Renders `<header class="navbar">`. Reuses `<paw:search>` internally. Sticky, `z-index: 100`. CSS: `navbar.css` + overrides on `.navbar .search-*`.

#### `<paw:hero>`
| Attribute | Required | Type | Default | Notes |
|-----------|----------|------|---------|-------|
| `title` | yes | String | — | Rendered uppercase |
| `description` | no | String | — | Short subtitle below title |
| `imageUrl` | no | String | — | Full resolved URL (prepend `${pageContext.request.contextPath}`) |
| `badge` | no | String | `DESTACADO` | Featured badge text |
| `rating` | no | String | — | e.g., `4.9/5.0` |
| `ticketUrl` | no | String | — | If set, "Reservar Entradas" renders as `<a>` instead of `<button>` |

Full-width section with background image, gradient overlay, content bottom-left, nav arrows bottom-right. Reuses `<paw:button>` for all interactive elements.

#### `<paw:productionCard>`
| Attribute | Required | Type | Notes |
|-----------|----------|------|-------|
| `title` | yes | String | Rendered uppercase |
| `imageUrl` | no | String | Full resolved URL |
| `venue` | no | String | Theater name shown below title |
| `rating` | no | String | e.g., `4.9` — shown with amber star |
| `badge` | no | String | Overlay badge (e.g., `TOP1`) — amber pill top-right of image |
| `detailUrl` | no | String | If set, image area wraps in `<a>`; resolved via `<c:url>` |

Fixed width `210px`, portrait image (`aspect-ratio: 3/4`), hover scale on clickable cards. Use inside `<paw:sectionRow>`.

#### `<paw:sectionRow>`
| Attribute | Required | Type | Notes |
|-----------|----------|------|-------|
| `title` | yes | String | Section title (large bold italic) |
| `subtitle` | no | String | Small uppercase subtitle below title |

Body content: place `<paw:productionCard>` elements directly inside the tag. They render in a horizontally scrollable flex row. Uses `body-content="scriptless"` and `<jsp:doBody />`.

```jsp
<paw:sectionRow title="Tendencia" subtitle="Lo que todos están hablando">
    <paw:productionCard title="Hamlet" venue="Teatro Regina" rating="4.9" ... />
    <paw:productionCard title="Hamilton" venue="Gran Rex" rating="4.8" ... />
</paw:sectionRow>
```

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
| `otherEditions` | no | String | Format: `year;production;location~year2;production2;location2` (split `~` then `;`) |
| `seen` | no | Boolean | default `false` |
| `inWishlist` | no | Boolean | default `false` |
| `currentlyRunning` | no | Boolean | default `false` |
| `expiringSoon` | no | Boolean | default `false` |

---

## CSS Architecture

### File structure rules

- `css/main.css` — global reset, `*` box-sizing, `body`, `header`, `main`, `h2` base styles only.
- `css/components/<component>.css` — one file per tag/component, named in kebab-case matching the component concept.
- **Never put component styles in `main.css`.**
- **Never put global styles in a component file.**
- Each JSP view links `main.css` + every component CSS it uses, in `<head>`.

### Naming convention — Component-scoped BEM-like

Pattern: `.<component>-<element>` and `.<component>-<modifier>` or `.<component>-<element>-<modifier>`.

Examples:
- `.obra-card`, `.obra-card-img`, `.obra-card-title`, `.obra-card-clickable`, `.obra-card-wishlist`
- `.btn`, `.btn-sm`, `.btn-md`, `.btn-lg`, `.btn-wishlist`
- `.alert`, `.alert-content`, `.alert-title`, `.alert-message`, `.alert-close`, `.alert-info`, `.alert-success`, `.alert-warning`, `.alert-error`
- `.search-wrapper`, `.search-input`, `.search-input-error`, `.search-error-msg`
- `.play-detail`, `.play-detail-body`, `.play-detail-title`, `.play-detail-status-active`, `.play-detail-status-inactive`

**All class names are lowercase kebab-case. No camelCase, no underscores.**

### Layout primitives

- Use **CSS Grid** for page-level and multi-column layouts.
- Use **Flexbox** for single-axis component internals.
- Never use inline `style=""` attributes in HTML (except Tailwind-style utilities, not used here).
- Never use `float` for layout.

### Design tokens (dark theme)

| Token | Value | Usage |
|-------|-------|-------|
| Background | `#141414` | `body` background |
| Header bg | `#000` | `header` / navbar background |
| Primary purple | `#7c3aed` | Logo, `.btn-primary`, CTA buttons |
| Primary purple hover | `#6d28d9` | `.btn-primary:hover` |
| Amber/featured | `#f5a623` | `hero-badge-featured`, `production-card-badge`, rating stars |
| Gold accent | `#cc9108` | Ticket CTA in playDetail, rating display |
| Error/danger | `#e50914` | Error states, `.search-input-error`, wishlist hover |
| Text primary | `#fff` | Default text |
| Text muted | `rgba(255,255,255,0.80–0.88)` | Secondary text, summaries |
| Text subtle | `rgba(255,255,255,0.45–0.65)` | Nav links, venue names, inactive states |
| Surface subtle | `rgba(255,255,255,0.04–0.12)` | Cards, tags, badges, navbar search bg |
| Border subtle | `rgba(255,255,255,0.08–0.18)` | Card/panel/input borders |

**Hardcoding colors outside of their established component is forbidden** — reuse these values.

### Responsive design

- Add `@media (max-width: 768px)` blocks inside the component's CSS file when needed (see `play-detail.css`).
- Collapse grid to single column on mobile.

---

## Java Package Structure

```
ar.edu.itba.paw.
├── webapp.
│   ├── config.WebConfig           ← Spring MVC configuration
│   └── controller.*Controller     ← @Controller classes
├── services.*ServiceImpl          ← @Service implementations
├── interfaces.
│   ├── services.*Service          ← Service interfaces (in service-contracts)
│   └── persistence.*Dao           ← DAO interfaces (in service-contracts)
├── persistence.*DaoImpl           ← @Repository JDBC implementations (TBD)
└── models.*                       ← Domain entity POJOs (TBD)
```

**Naming rules:**
- Interfaces: `UserService`, `UserDao`
- Implementations: `UserServiceImpl`, `UserDaoImpl`
- Controllers: `UserController`, `PlayController`
- One class per file, package mirrors module name.

---

## Database Conventions (when implemented)

- Use `JdbcTemplate` for SELECT/UPDATE/DELETE — never raw JDBC.
- Use `SimpleJdbcInsert` for INSERT — never hand-build INSERT strings.
- **Parameterized queries only** — `?` placeholders, never string concatenation (SQL injection).
- `RowMapper<T>` defined as `private static final` field (stateless lambda or static inner class).
- DAO methods return `Optional<T>` for single-result queries, `List<T>` for multi-result.
- Never return `null` from a DAO or service.
- IDs are `SERIAL` (auto-generated) in PostgreSQL.
- `DataSource` bean defined in `WebConfig.java`.

### Image storage pattern

- The current implementation stores external cover URLs in `image_url` columns on domain tables such as `productions` and `productoras`.
- For the course delivery, image uploads must use `multipart/form-data`.
- A single request may carry both form fields and a file. A controller may bind them with `@ModelAttribute` into a form object that contains both regular fields and a `MultipartFile`.
- Uploaded images should be persisted in PostgreSQL. Prefer storing the binary content or a dedicated image record there instead of relying on temporary filesystem state.
- Images must be rendered through normal image URLs and the `src` attribute of `<img>`, not embedded inline.
- Expose dedicated controller endpoints that return image content for the frontend to consume through application-owned URLs.
- Never store or render images as Base64.
- If the project later migrates to a different image persistence strategy, update this guide and the persistence layer together.

---

## Email Conventions (when implemented)

- Use a mailing library instead of hand-building SMTP calls. Spring mail support is the expected baseline.
- Send emails **only from the services layer** — never from controllers or persistence.
- Mark email methods `@Async` — email must never block the request thread.
- Enable `@EnableAsync` in `WebConfig`.
- Thymeleaf is the compulsory template engine for emails.
- Define a reusable base email style so every message shares the same visual structure and branding.
- Templates must be internationalized (i18n). For the final delivery, email content must be translatable and tested with multiple locales.
- Email structure: header (site branding) → body (reason/content) → call-to-action link → footer (optional).
- Every email must include a clear call to action.
- Emails must contain information the user does not already know.

---

## Static Resources

- Static assets may include JavaScript, CSS, and static images such as logos, icons, and placeholders.
- CSS is mandatory for delivered views. Do not ship raw unstyled pages.
- Keep static resources in the public static folders of the web module, next to the webapp assets layout already used by the project.
- Reference static assets with `<c:url>` or with URLs built from the application context path. Do not hardcode deploy-specific absolute URLs.
- Keep `WebConfig.addResourceHandlers(...)` aligned with any new static folders. In most cases the mapping is already configured and should be extended, not replaced.

---

## Pampero Deploy Guide

- Deployment target: `Tomcat 9.0.107-dev` on `pampero.itba.edu.ar`.
- The deployable artifact is the WAR generated by the `webapp` module.
- The final artifact must be uploaded as `/web/app.war` with that exact name.

### Upload options

- `scp path/to/file username@pampero.itba.edu.ar:/home/username/.`
- `sftp paw-2026a-#i@10.16.1.110`
- Then: `put web/app.war web/app.war`

### Database access

- Database engine: PostgreSQL.
- Credentials are the same ones used for `sftp`.
- Database name must match the group name.
- Example connection: `psql -h 10.16.1.110 -U paw-2026a-$i`

### Logs

- Team log example: `http://pawserver.it.itba.edu.ar/logs/paw-2026a-01-webapp.2026-04-01.log`
- General access log example: `http://pawserver.it.itba.edu.ar/logs/localhost_access_log.2026-04-01.txt`
- Catalina stderr: `http://pawserver.it.itba.edu.ar/logs/catalina.err`
- Log using the levels covered in the course lectures. Do not leave debugging blind spots around deploy, multipart handling, mail flows, and persistence failures.

### Final URL

- The final deployed app is exposed at `http://pawserver.it.itba.edu.ar/paw-2026a-#i`

---

## Critical Coding Rules (violations are penalized)

1. **No business logic in controllers** — receive, validate, delegate, return view. Nothing more.
2. **No shared mutable state** — Spring beans have no instance fields that change per-request. Thread-safety via statelessness.
3. **No null returns** — use `Optional<T>` for possibly-absent values at every layer boundary.
4. **No raw SQL string construction** — always use `?` placeholders via `JdbcTemplate`/`SimpleJdbcInsert`.
5. **No `${var}` for user data in JSP** — always `<c:out value="${var}" />`.
6. **No raw URLs in JSP** — always `<c:url value="..." />`.
7. **No inline styles in HTML** — all styling goes in CSS files.
8. **No cross-layer compile dependencies** — Maven scopes enforce this; do not bypass.
9. **No Base64 images** — upload with `multipart/form-data`, persist appropriately, and expose them through application URLs.
10. **No undocumented image storage changes** — if image persistence strategy changes, update this file and the persistence layer together.
11. **No blocking email sends** — always `@Async`.
12. **Emails live in services** — never trigger mail delivery directly from controllers.
13. **Every email needs i18n and a CTA** — final delivery must satisfy both.
14. **Pampero WAR path is fixed** — production deploy expects `/web/app.war`.
15. **Immutability** — create new objects, never mutate existing ones. Domain objects from persistence are the single source of truth.

---

## Current State (2026-03-23)

**Implemented:**
- Multi-module architecture with `models`, `service-contracts`, `services`, `persistence`, and `webapp`
- Spring MVC configuration in `WebConfig`, including `DataSource`, JSP view resolution, and static resource handlers
- PostgreSQL schema and seed data in `persistence/src/main/resources/`
- Controllers for home, plays, productions, productoras, search, wishlist, seen list, ratings, reviews, and user profile
- Service and DAO layers for productions, obras, productoras, ratings, reviews, wishlist, seen items, shows, users, and images
- Shared JSP tags: `alert`, `button`, `card`, `hero`, `navbar`, `playDetail`, `productionCard`, `search`, `sectionRow`
- Production cards reused across landing, cartelera, search results, productora pages, and wishlist/profile sections

**Still pending or intentionally simplified:**
- Authentication and real logged-in users (some controllers still use a hardcoded user id for demo flow)
- Email sending and async mail flows
- Automated tests enforcing all documented conventions
