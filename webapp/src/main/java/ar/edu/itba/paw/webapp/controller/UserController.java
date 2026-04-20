package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ImageService;
import ar.edu.itba.paw.interfaces.services.RatingService;
import ar.edu.itba.paw.interfaces.services.ReviewService;
import ar.edu.itba.paw.interfaces.services.UserService;
import ar.edu.itba.paw.interfaces.services.WatchlistService;
import ar.edu.itba.paw.interfaces.services.exception.UserAlreadyExistsException;
import ar.edu.itba.paw.interfaces.services.exception.UsernameAlreadyExistsException;
import ar.edu.itba.paw.models.Image;
import ar.edu.itba.paw.models.Production;
import ar.edu.itba.paw.models.Review;
import ar.edu.itba.paw.models.User;
import ar.edu.itba.paw.webapp.auth.PawAuthUser;
import ar.edu.itba.paw.webapp.form.RegisterForm;
import ar.edu.itba.paw.webapp.form.UpdatePersonalDataForm;
import ar.edu.itba.paw.webapp.form.UpdateUsernameForm;
import ar.edu.itba.paw.webapp.form.VerifyEmailForm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.validation.Valid;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

@Controller
public class UserController {

    private static final String PENDING_USER_ID_ATTR = "pendingVerificationUserId";
    private static final String PENDING_EMAIL_ATTR = "pendingVerificationEmail";

    private final UserService userService;
    private final ImageService imageService;
    private final ReviewService reviewService;
    private final WatchlistService watchlistService;
    private final RatingService ratingService;
    private final UserDetailsService userDetailsService;

    @Autowired
    public UserController(final UserService userService,
                          final ImageService imageService,
                          final ReviewService reviewService,
                          final WatchlistService watchlistService,
                          final RatingService ratingService,
                          final UserDetailsService userDetailsService) {
        this.userService = userService;
        this.imageService = imageService;
        this.reviewService = reviewService;
        this.watchlistService = watchlistService;
        this.ratingService = ratingService;
        this.userDetailsService = userDetailsService;
    }

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public ModelAndView login(@RequestParam(value = "error", required = false) final String error,
                              @RequestParam(value = "logout", required = false) final String logout,
                              @RequestParam(value = "registered", required = false) final String registered,
                              @RequestParam(value = "unverified", required = false) final String unverified,
                              @AuthenticationPrincipal final PawAuthUser authUser) {
        if (authUser != null) {
            return new ModelAndView("redirect:/users/me");
        }

        final ModelAndView mav = new ModelAndView("users/login");
        mav.addObject("hasError", "1".equals(error));
        mav.addObject("loggedOut", "1".equals(logout));
        mav.addObject("registered", "1".equals(registered));
        mav.addObject("unverified", "1".equals(unverified));
        return mav;
    }

    @RequestMapping(value = "/register", method = RequestMethod.GET)
    public ModelAndView registerForm(@AuthenticationPrincipal final PawAuthUser authUser) {
        if (authUser != null) {
            return new ModelAndView("redirect:/users/me");
        }

        return registerView(new RegisterForm());
    }

    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public ModelAndView register(@Valid @ModelAttribute("registerForm") final RegisterForm form,
                                 final BindingResult errors,
                                 final HttpServletRequest request,
                                 @AuthenticationPrincipal final PawAuthUser authUser) {
        if (authUser != null) {
            return new ModelAndView("redirect:/users/me");
        }

        form.setEmail(normalizeEmail(form.getEmail()));

        if (!form.passwordsMatch()) {
            errors.rejectValue("repeatPassword", "auth.register.repeatPassword.mismatch");
        }

        if (errors.hasErrors()) {
            return registerView(errors);
        }

        try {
            final User created = userService.create(form.getEmail(), form.getPassword(), form.getUsername());
            userService.issueVerificationCode(created.getId());
            final HttpSession session = request.getSession(true);
            session.setAttribute(PENDING_USER_ID_ATTR, created.getId());
            session.setAttribute(PENDING_EMAIL_ATTR, created.getEmail());
            return new ModelAndView("redirect:/register/verify");
        } catch (final UsernameAlreadyExistsException e) {
            errors.rejectValue("username", "auth.register.username.taken");
            return registerView(errors);
        } catch (final UserAlreadyExistsException e) {
            errors.rejectValue("email", "auth.register.email.taken");
            return registerView(errors);
        }
    }

    @RequestMapping(value = "/register/verify", method = RequestMethod.GET)
    public ModelAndView verifyForm(final HttpServletRequest request,
                                   @AuthenticationPrincipal final PawAuthUser authUser) {
        if (authUser != null) {
            return new ModelAndView("redirect:/users/me");
        }
        final Long pendingId = pendingUserId(request);
        if (pendingId == null) {
            return new ModelAndView("redirect:/register");
        }
        return verifyView(new VerifyEmailForm(), request, null, null);
    }

    @RequestMapping(value = "/register/verify", method = RequestMethod.POST)
    public ModelAndView verifySubmit(@Valid @ModelAttribute("verifyEmailForm") final VerifyEmailForm form,
                                     final BindingResult errors,
                                     final HttpServletRequest request,
                                     final HttpServletResponse response,
                                     @AuthenticationPrincipal final PawAuthUser authUser) {
        if (authUser != null) {
            return new ModelAndView("redirect:/users/me");
        }
        final Long pendingId = pendingUserId(request);
        if (pendingId == null) {
            return new ModelAndView("redirect:/register");
        }

        if (errors.hasErrors()) {
            return verifyView(errors, request, null, null);
        }

        final UserService.VerificationResult result = userService.verifyEmailCode(pendingId, form.getCode());
        switch (result) {
            case VERIFIED:
            case ALREADY_VERIFIED: {
                final Optional<User> userOpt = userService.findById(pendingId);
                clearPending(request);
                if (userOpt.isPresent()) {
                    authenticateUser(userOpt.get().getEmail());
                    return new ModelAndView("redirect:" + resolvePostRegisterTarget(request, response));
                }
                return new ModelAndView("redirect:/login?registered=1");
            }
            case EXPIRED:
                return verifyView(form, request, "expired", null);
            case USER_NOT_FOUND:
                clearPending(request);
                return new ModelAndView("redirect:/register");
            case INVALID_CODE:
            default:
                return verifyView(form, request, "invalid", null);
        }
    }

    @RequestMapping(value = "/register/verify/resend", method = RequestMethod.POST)
    public ModelAndView verifyResend(final HttpServletRequest request,
                                     @AuthenticationPrincipal final PawAuthUser authUser) {
        if (authUser != null) {
            return new ModelAndView("redirect:/users/me");
        }
        final Long pendingId = pendingUserId(request);
        if (pendingId == null) {
            return new ModelAndView("redirect:/register");
        }
        userService.issueVerificationCode(pendingId);
        return verifyView(new VerifyEmailForm(), request, null, "resent");
    }

    @RequestMapping(value = "/users/me", method = RequestMethod.GET)
    public ModelAndView profile(@AuthenticationPrincipal final PawAuthUser authUser) {
        final ModelAndView mav = buildProfileMav(authUser);
        mav.addObject("updatePersonalDataForm", new UpdatePersonalDataForm());
        return mav;
    }

    @RequestMapping(value = "/users/me/username", method = RequestMethod.POST)
    public ModelAndView updateUsername(@AuthenticationPrincipal final PawAuthUser authUser,
                                       @Valid @ModelAttribute("updateUsernameForm") final UpdateUsernameForm form,
                                       final BindingResult errors) {
        if (errors.hasErrors()) {
            final ModelAndView mav = buildProfileMav(authUser);
            mav.addObject("updatePersonalDataForm", new UpdatePersonalDataForm());
            return mav;
        }
        userService.updateUsername(authUser.getUser().getId(), form.getUsername());
        authenticateUser(authUser.getUser().getEmail());
        return new ModelAndView("redirect:/users/me");
    }

    @RequestMapping(value = "/users/me/picture", method = RequestMethod.POST)
    public ModelAndView updatePicture(@AuthenticationPrincipal final PawAuthUser authUser,
                                      @RequestParam("picture") final MultipartFile file) {
        if (file == null || file.isEmpty() || file.getContentType() == null
                || !file.getContentType().startsWith("image/")) {
            return new ModelAndView("redirect:/users/me");
        }
        try {
            final Image img = imageService.create(file.getContentType(), file.getBytes());
            userService.updateImage(authUser.getUser().getId(), img.getId());
            authenticateUser(authUser.getUser().getEmail());
        } catch (final Exception ignored) {
            // Non-fatal: redirect to profile without updating
        }
        return new ModelAndView("redirect:/users/me");
    }

    @RequestMapping(value = "/users/me/personal", method = RequestMethod.POST)
    public ModelAndView updatePersonalData(@AuthenticationPrincipal final PawAuthUser authUser,
                                           @Valid @ModelAttribute("updatePersonalDataForm") final UpdatePersonalDataForm form,
                                           final BindingResult errors) {
        if (errors.hasErrors()) {
            final ModelAndView mav = buildProfileMav(authUser);
            mav.addObject("updatePersonalDataForm", form);
            mav.addObject("activeTab", "account");
            return mav;
        }
        if (form.getUsername() != null && !form.getUsername().trim().isEmpty()) {
            userService.updateUsername(authUser.getUser().getId(), form.getUsername());
        }
        if (form.getBio() != null) {
            userService.updateBio(authUser.getUser().getId(), form.getBio());
        }
        authenticateUser(authUser.getUser().getEmail());
        return new ModelAndView("redirect:/users/me");
    }

    private ModelAndView buildProfileMav(final PawAuthUser authUser) {
        final long userId = authUser.getUser().getId();
        final ModelAndView mav = new ModelAndView("users/profile");
        mav.addObject("currentUserEmail", authUser.getUser().getEmail());
        mav.addObject("currentUsername", authUser.getUser().getUsername());
        mav.addObject("currentUserImageId", authUser.getUser().getImageId());
        mav.addObject("currentUserBio", authUser.getUser().getBio());
        mav.addObject("reviews", reviewService.findByUser(userId));
        mav.addObject("updateUsernameForm", new UpdateUsernameForm());
        final List<Production> watchlist = watchlistService.findByUser(userId);
        mav.addObject("watchlist", watchlist);
        mav.addObject("productionRatings", ratingService.getProductionRatingLabels(collectProductionIds(watchlist)));
        return mav;
    }

    private List<Long> collectProductionIds(final List<Production> productions) {
        final List<Long> ids = new java.util.ArrayList<>();
        for (final Production p : productions) {
            ids.add(p.getId());
        }
        return ids;
    }

    private ModelAndView registerView(final RegisterForm form) {
        final ModelAndView mav = new ModelAndView("users/register");
        mav.addObject("registerForm", form);
        return mav;
    }

    private ModelAndView registerView(final BindingResult errors) {
        return new ModelAndView("users/register", errors.getModel());
    }

    private ModelAndView verifyView(final VerifyEmailForm form,
                                    final HttpServletRequest request,
                                    final String errorCode,
                                    final String notice) {
        final ModelAndView mav = new ModelAndView("users/verify");
        mav.addObject("verifyEmailForm", form);
        mav.addObject("pendingEmail", pendingEmail(request));
        mav.addObject("verifyError", errorCode);
        mav.addObject("verifyNotice", notice);
        return mav;
    }

    private ModelAndView verifyView(final BindingResult errors,
                                    final HttpServletRequest request,
                                    final String errorCode,
                                    final String notice) {
        final ModelAndView mav = new ModelAndView("users/verify", errors.getModel());
        mav.addObject("pendingEmail", pendingEmail(request));
        mav.addObject("verifyError", errorCode);
        mav.addObject("verifyNotice", notice);
        return mav;
    }

    private Long pendingUserId(final HttpServletRequest request) {
        final HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        final Object value = session.getAttribute(PENDING_USER_ID_ATTR);
        return value instanceof Long ? (Long) value : null;
    }

    private String pendingEmail(final HttpServletRequest request) {
        final HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        final Object value = session.getAttribute(PENDING_EMAIL_ATTR);
        return value instanceof String ? (String) value : null;
    }

    private void clearPending(final HttpServletRequest request) {
        final HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }
        session.removeAttribute(PENDING_USER_ID_ATTR);
        session.removeAttribute(PENDING_EMAIL_ATTR);
    }

    private String normalizeEmail(final String email) {
        if (email == null) {
            return null;
        }
        return email.trim().toLowerCase(Locale.ROOT);
    }

    private void authenticateUser(final String email) {
        final UserDetails userDetails = userDetailsService.loadUserByUsername(email);
        final UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(
                userDetails,
                userDetails.getPassword(),
                userDetails.getAuthorities()
        );
        SecurityContextHolder.getContext().setAuthentication(authentication);
    }

    private String resolvePostRegisterTarget(final HttpServletRequest request,
                                             final HttpServletResponse response) {
        final HttpSessionRequestCache requestCache = new HttpSessionRequestCache();
        final SavedRequest savedRequest = requestCache.getRequest(request, response);

        requestCache.removeRequest(request, response);
        if (savedRequest != null) {
            return savedRequest.getRedirectUrl();
        }

        final String contextPath = request.getContextPath();
        return (contextPath != null ? contextPath : "") + "/users/me";
    }
}
