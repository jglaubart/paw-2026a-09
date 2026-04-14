package ar.edu.itba.paw.webapp.config;

import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;
import org.springframework.jdbc.datasource.SimpleDriverDataSource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.validation.Validator;
import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.ViewResolver;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter;
import org.springframework.web.servlet.view.InternalResourceViewResolver;
import org.springframework.web.servlet.view.JstlView;
import org.thymeleaf.spring5.SpringTemplateEngine;
import org.thymeleaf.templatemode.TemplateMode;
import org.thymeleaf.templateresolver.ClassLoaderTemplateResolver;

import javax.sql.DataSource;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

@ComponentScan({
    "ar.edu.itba.paw.webapp.controller",
    "ar.edu.itba.paw.webapp.auth",
    "ar.edu.itba.paw.services",
    "ar.edu.itba.paw.persistence"
})
@EnableWebMvc
@EnableAsync
@Configuration
public class WebConfig implements WebMvcConfigurer {

    public static final long MAX_UPLOAD_SIZE_BYTES = 5L * 1024 * 1024;

    static {
        loadDotEnvIntoSystemProperties();
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/css/**").addResourceLocations("/css/");
        registry.addResourceHandler("/js/**").addResourceLocations("/js/");
        registry.addResourceHandler("/images/**").addResourceLocations("/images/");
        registry.addResourceHandler("/favicon.png").addResourceLocations("/favicon.png");
    }

    @Bean
    public ViewResolver viewResolver() {
        InternalResourceViewResolver resolver = new InternalResourceViewResolver();
        resolver.setViewClass(JstlView.class);
        resolver.setPrefix("/WEB-INF/views/");
        resolver.setSuffix(".jsp");
        return resolver;
    }

    @Bean
    public DataSource dataSource() {
        final SimpleDriverDataSource ds = new SimpleDriverDataSource();
        ds.setDriverClass(org.postgresql.Driver.class);
        ds.setUrl(resolveConfig("PLATEA_DB_URL", "platea.db.url", "jdbc:postgresql://localhost/platea"));
        ds.setUsername(resolveConfig("PLATEA_DB_USERNAME", "platea.db.username", "postgres"));
        ds.setPassword(resolveConfig("PLATEA_DB_PASSWORD", "platea.db.password", "postgres"));
        return ds;
    }

    @Bean(name = "multipartResolver")
    public CommonsMultipartResolver multipartResolver() {
        final CommonsMultipartResolver resolver = new CommonsMultipartResolver();
        resolver.setMaxUploadSize(MAX_UPLOAD_SIZE_BYTES);
        resolver.setMaxUploadSizePerFile(MAX_UPLOAD_SIZE_BYTES);
        resolver.setDefaultEncoding("UTF-8");
        return resolver;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public JavaMailSender mailSender() {
        final JavaMailSenderImpl sender = new JavaMailSenderImpl();
        sender.setHost(resolveConfig("PLATEA_MAIL_HOST", "platea.mail.host", "smtp.gmail.com"));
        sender.setPort(Integer.parseInt(resolveConfig("PLATEA_MAIL_PORT", "platea.mail.port", "587")));
        sender.setUsername(resolveConfig("PLATEA_MAIL_USERNAME", "platea.mail.username", "platea.noreply@gmail.com"));
        sender.setPassword(resolveConfig("PLATEA_MAIL_PASSWORD", "platea.mail.password", ""));
        final Properties props = sender.getJavaMailProperties();
        props.put("mail.transport.protocol", "smtp");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.starttls.required", "true");
        props.put("mail.smtp.connectiontimeout", "10000");
        props.put("mail.smtp.timeout", "10000");
        props.put("mail.smtp.writetimeout", "10000");

        if (sender.getPassword() == null || sender.getPassword().trim().isEmpty()) {
            System.err.println("[Platea] SMTP password not configured. Set PLATEA_MAIL_PASSWORD to enable email delivery.");
        }
        return sender;
    }

    @Bean
    public ReloadableResourceBundleMessageSource messageSource() {
        final ReloadableResourceBundleMessageSource messageSource = new ReloadableResourceBundleMessageSource();
        messageSource.setBasenames("classpath:i18n/messages", "classpath:mail/messages");
        messageSource.setDefaultEncoding(StandardCharsets.UTF_8.name());
        messageSource.setFallbackToSystemLocale(false);
        return messageSource;
    }

    @Bean
    public LocalValidatorFactoryBean validator() {
        final LocalValidatorFactoryBean validator = new LocalValidatorFactoryBean();
        validator.setValidationMessageSource(messageSource());
        return validator;
    }

    @Override
    public Validator getValidator() {
        return validator();
    }

    @Bean
    public SpringTemplateEngine mailTemplateEngine() {
        final ClassLoaderTemplateResolver templateResolver = new ClassLoaderTemplateResolver();
        templateResolver.setPrefix("mail/");
        templateResolver.setSuffix(".html");
        templateResolver.setTemplateMode(TemplateMode.HTML);
        templateResolver.setCharacterEncoding(StandardCharsets.UTF_8.name());
        templateResolver.setCacheable(false);

        final SpringTemplateEngine engine = new SpringTemplateEngine();
        engine.setTemplateResolver(templateResolver);
        engine.setTemplateEngineMessageSource(messageSource());
        return engine;
    }

    @Bean
    public BeanPostProcessor requestMappingHandlerAdapterCustomizer() {
        return new BeanPostProcessor() {
            @Override
            public Object postProcessAfterInitialization(final Object bean, final String beanName) {
                if (bean instanceof RequestMappingHandlerAdapter) {
                    ((RequestMappingHandlerAdapter) bean).setIgnoreDefaultModelOnRedirect(true);
                }
                return bean;
            }
        };
    }

    @Bean
    public InitializingBean databaseInitializer(final DataSource dataSource,
                                                final PasswordEncoder passwordEncoder) {
        return () -> {
            runScript(dataSource, "schema.sql");
            runScript(dataSource, "migration_add_shows_location_columns.sql");

            final JdbcTemplate jdbcTemplate = new JdbcTemplate(dataSource);
            final Integer productionsCount = jdbcTemplate.queryForObject(
                    "SELECT COUNT(*) FROM productions",
                    Integer.class
            );

            if (productionsCount != null && productionsCount == 0) {
                runScript(dataSource, "seed.sql");
            }

            runScript(dataSource, "migration_users_role.sql");
            runScript(dataSource, "migration_backfill_shows_location_from_seed_theaters.sql");
            runScript(dataSource, "migration_play_petitions.sql");
            runScript(dataSource, "migration_images_for_productions.sql");
            runScript(dataSource, "migration_drop_legacy_image_urls.sql");
            runScript(dataSource, "migration_backfill_play_ratings_from_production_ratings.sql");
            runScript(dataSource, "migration_review_email_identity.sql");
            runScript(dataSource, "migration_reviews_per_obra.sql");
            hashLegacyUserPasswords(jdbcTemplate, passwordEncoder);
        };
    }

    private void runScript(final DataSource dataSource, final String resourcePath) {
        final ResourceDatabasePopulator populator = new ResourceDatabasePopulator();
        populator.addScript(new ClassPathResource(resourcePath));
        populator.execute(dataSource);
    }

    private String resolveConfig(final String envName, final String propertyName, final String defaultValue) {
        final String envValue = System.getenv(envName);
        if (envValue != null && !envValue.trim().isEmpty()) {
            return envValue.trim();
        }

        final String propertyValue = System.getProperty(propertyName);
        if (propertyValue != null && !propertyValue.trim().isEmpty()) {
            return propertyValue.trim();
        }

        return defaultValue;
    }

    private static void loadDotEnvIntoSystemProperties() {
        Map<String, String> values = null;
        final Path dotenvPath = resolveDotEnvPath();
        
        if (dotenvPath != null) {
            values = parseDotEnv(dotenvPath);
        } else {
            final ClassPathResource cp = new ClassPathResource(".env");
            if (cp.exists()) {
                try {
                    values = parseDotEnvStream(cp.getInputStream());
                } catch (IOException e) {
                    System.err.println("[Platea] Could not read .env from classpath: " + e.getMessage());
                }
            }
        }

        if (values == null) {
            return;
        }

        for (final Map.Entry<String, String> entry : values.entrySet()) {
            final String key = entry.getKey();
            final String value = entry.getValue();
            if (value == null || value.trim().isEmpty()) {
                continue;
            }
            if (System.getProperty(key) == null) {
                System.setProperty(key, value);
            }
            final String alias = aliasFor(key);
            if (alias != null && System.getProperty(alias) == null) {
                System.setProperty(alias, value);
            }
        }
    }

    private static Path resolveDotEnvPath() {
        final String explicitEnvPath = firstNonBlank(System.getenv("PLATEA_ENV_FILE"), System.getProperty("platea.env.file"));
        if (explicitEnvPath != null) {
            final Path explicitPath = Paths.get(explicitEnvPath).toAbsolutePath().normalize();
            if (Files.exists(explicitPath)) {
                return explicitPath;
            }
        }

        Path current = Paths.get("").toAbsolutePath().normalize();
        while (current != null) {
            final Path candidate = current.resolve(".env");
            if (Files.exists(candidate)) {
                return candidate;
            }
            current = current.getParent();
        }
        return null;
    }

    private static Map<String, String> parseDotEnv(final Path dotenvPath) {
        try {
            return parseDotEnvStream(Files.newInputStream(dotenvPath));
        } catch (final IOException e) {
            throw new IllegalStateException("Could not load .env file from " + dotenvPath, e);
        }
    }

    private static Map<String, String> parseDotEnvStream(final java.io.InputStream is) throws IOException {
        final Map<String, String> values = new LinkedHashMap<>();
        try (java.io.BufferedReader reader = new java.io.BufferedReader(new java.io.InputStreamReader(is, StandardCharsets.UTF_8))) {
            String rawLine;
            while ((rawLine = reader.readLine()) != null) {
                String line = rawLine.trim();
                if (line.isEmpty() || line.startsWith("#")) {
                    continue;
                }
                if (line.startsWith("export ")) {
                    line = line.substring("export ".length()).trim();
                }

                final int separatorIndex = line.indexOf('=');
                if (separatorIndex <= 0) {
                    continue;
                }

                final String key = line.substring(0, separatorIndex).trim();
                String value = line.substring(separatorIndex + 1).trim();
                if ((value.startsWith("\"") && value.endsWith("\"")) || (value.startsWith("'") && value.endsWith("'"))) {
                    value = value.substring(1, value.length() - 1);
                }
                values.put(key, value);
            }
        }
        return values;
    }

    private static String aliasFor(final String key) {
        switch (key) {
            case "PLATEA_DB_URL":
                return "platea.db.url";
            case "PLATEA_DB_USERNAME":
                return "platea.db.username";
            case "PLATEA_DB_PASSWORD":
                return "platea.db.password";
            case "PLATEA_MAIL_HOST":
                return "platea.mail.host";
            case "PLATEA_MAIL_PORT":
                return "platea.mail.port";
            case "PLATEA_MAIL_USERNAME":
                return "platea.mail.username";
            case "PLATEA_MAIL_PASSWORD":
                return "platea.mail.password";
            case "PLATEA_MAIL_FROM":
                return "platea.mail.from";
            case "PLATEA_PUBLIC_BASE_URL":
                return "platea.public.base-url";
            default:
                return null;
        }
    }

    private static String firstNonBlank(final String first, final String second) {
        if (first != null && !first.trim().isEmpty()) {
            return first.trim();
        }
        if (second != null && !second.trim().isEmpty()) {
            return second.trim();
        }
        return null;
    }

    private void hashLegacyUserPasswords(final JdbcTemplate jdbcTemplate,
                                         final PasswordEncoder passwordEncoder) {
        final List<Map<String, Object>> users = jdbcTemplate.queryForList(
                "SELECT id, password FROM users WHERE password IS NOT NULL"
        );

        for (final Map<String, Object> user : users) {
            final String password = (String) user.get("password");
            if (password == null || password.trim().isEmpty() || looksLikeBcryptHash(password)) {
                continue;
            }

            jdbcTemplate.update(
                    "UPDATE users SET password = ? WHERE id = ?",
                    passwordEncoder.encode(password),
                    ((Number) user.get("id")).longValue()
            );
        }
    }

    private boolean looksLikeBcryptHash(final String password) {
        return password.startsWith("$2a$") || password.startsWith("$2b$") || password.startsWith("$2y$");
    }
}
