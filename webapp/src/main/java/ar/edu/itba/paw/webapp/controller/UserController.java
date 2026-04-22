package ar.edu.itba.paw.webapp.controller;

import ar.edu.itba.paw.interfaces.services.ImageService;
import ar.edu.itba.paw.interfaces.services.RatingService;
import ar.edu.itba.paw.interfaces.services.ReviewService;
import ar.edu.itba.paw.interfaces.services.SeenService;
import ar.edu.itba.paw.interfaces.services.UserService;
import ar.edu.itba.paw.interfaces.services.WatchlistService;
import ar.edu.itba.paw.interfaces.services.exception.UserAlreadyExistsException;
import ar.edu.itba.paw.interfaces.services.exception.UsernameAlreadyExistsException;
import ar.edu.itba.paw.models.Image;
import ar.edu.itba.paw.models.Production;
import ar.edu.itba.paw.models.Review;
import ar.edu.itba.paw.models.User;
import ar.edu.itba.paw.webapp.auth.PawAuthUser;
import ar.edu.itba.paw.webapp.form.ForgotPasswordForm;
import ar.edu.itba.paw.webapp.form.RegisterForm;
import ar.edu.itba.paw.webapp.form.ResetPasswordForm;
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
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.time.LocalDate;
import java.util.List;
import java.util.Locale;
import java.util.Optional;

@Controller
public class UserController {

    private static final String PENDING_USER_ID_ATTR = "pendingVerificationUserId";
    private static final String PENDING_EMAIL_ATTR = "pendingVerificationEmail";
    private static final String USERNAME_LAST_CHANGED_ATTR = "usernameLastChanged";
    private static final long USERNAME_COOLDOWN_MILLIS = 60_000L;

    private final UserService userService;
    private final ImageService imageService;
    private final ReviewService reviewService;
    private final WatchlistService watchlistService;
    private final RatingService ratingService;
    private final SeenService seenService;
    private final UserDetailsService userDetailsService;

    @Autowired
    public UserController(final UserService userService,
                          final ImageService imageService,
                          final ReviewService reviewService,
                          final WatchlistService watchlistService,
                          final RatingService ratingService,
                          final SeenService seenService,
                          final UserDetailsService userDetailsService) {
        this.userService = userService;
        this.imageService = imageService;
        this.reviewService = reviewService;
        this.watchlistService = watchlistService;
        this.ratingService = ratingService;
        this.seenService = seenService;
        this.userDetailsService = userDetailsService;
    }

    @RequestMapping(value = "/login", method = RequestMethod.GET)
    public ModelAndView login(@RequestParam(value = "error", required = false) final String error,
                              @RequestParam(value = "logout", required = false) final String logout,
                              @RequestParam(value = "registered", required = false) final String registered,
                              @RequestParam(value = "unverified", required = false) final String unverified,
                              @RequestParam(value = "passwordReset", required = false) final String passwordReset,
                              @AuthenticationPrincipal final PawAuthUser authUser) {
        if (authUser != null) {
            return new ModelAndView("redirect:/users/me");
        }

        final ModelAndView mav = new ModelAndView("users/login");
        mav.addObject("hasError", "1".equals(error));
        mav.addObject("loggedOut", "1".equals(logout));
        mav.addObject("registered", "1".equals(registered));
        mav.addObject("unverified", "1".equals(unverified));
        mav.addObject("passwordReset", "1".equals(passwordReset));
        return mav;
    }

    @RequestMapping(value = "/forgot-password", method = RequestMethod.GET)
    public ModelAndView forgotPasswordForm(@AuthenticationPrincipal final PawAuthUser authUser) {
        if (authUser != null) {
            return new ModelAndView("redirect:/users/me");
        }
        return forgotView(new ForgotPasswordForm(), false);
    }

    @RequestMapping(value = "/forgot-password", method = RequestMethod.POST)
    public ModelAndView forgotPasswordSubmit(@Valid @ModelAttribute("forgotPasswordForm") final ForgotPasswordForm form,
                                             final BindingResult errors,
                                             @AuthenticationPrincipal final PawAuthUser authUser) {
        if (authUser != null) {
            return new ModelAndView("redirect:/users/me");
        }
        if (errors.hasErrors()) {
            return forgotView(errors, false);
        }
        userService.requestPasswordReset(form.getEmail());
        return forgotView(form, true);
    }

    @RequestMapping(value = "/reset-password", method = RequestMethod.GET)
    public ModelAndView resetPasswordForm(@RequestParam(value = "token", required = false) final String token,
                                          @AuthenticationPrincipal final PawAuthUser authUser) {
        if (authUser != null) {
            return new ModelAndView("redirect:/users/me");
        }
        if (token == null || !userService.isPasswordResetTokenValid(token)) {
            return new ModelAndView("users/resetPasswordInvalid");
        }
        final ResetPasswordForm form = new ResetPasswordForm();
        form.setToken(token);
        return resetView(form, null);
    }

    @RequestMapping(value = "/reset-password", method = RequestMethod.POST)
    public ModelAndView resetPasswordSubmit(@Valid @ModelAttribute("resetPasswordForm") final ResetPasswordForm form,
                                            final BindingResult errors,
                                            @AuthenticationPrincipal final PawAuthUser authUser) {
        if (authUser != null) {
            return new ModelAndView("redirect:/users/me");
        }
        if (form.getToken() == null || form.getToken().trim().isEmpty()) {
            return new ModelAndView("users/resetPasswordInvalid");
        }
        if (!form.passwordsMatch()) {
            errors.rejectValue("repeatPassword", "auth.reset.repeatPassword.mismatch");
        }
        if (errors.hasErrors()) {
            return resetViewFromErrors(errors);
        }
        final UserService.ResetPasswordResult result = userService.resetPassword(form.getToken(), form.getPassword());
        switch (result) {
            case RESET:
                return new ModelAndView("redirect:/login?passwordReset=1");
            case EXPIRED:
                return resetView(form, "expired");
            case INVALID_TOKEN:
            default:
                return new ModelAndView("users/resetPasswordInvalid");
        }
    }

    private ModelAndView forgotView(final ForgotPasswordForm form, final boolean sent) {
        final ModelAndView mav = new ModelAndView("users/forgotPassword");
        mav.addObject("forgotPasswordForm", form);
        mav.addObject("sent", sent);
        mav.addObject("sentEmail", sent ? form.getEmail() : null);
        return mav;
    }

    private ModelAndView forgotView(final BindingResult errors, final boolean sent) {
        final ModelAndView mav = new ModelAndView("users/forgotPassword", errors.getModel());
        mav.addObject("sent", sent);
        return mav;
    }

    private ModelAndView resetView(final ResetPasswordForm form, final String errorCode) {
        final ModelAndView mav = new ModelAndView("users/resetPassword");
        mav.addObject("resetPasswordForm", form);
        mav.addObject("resetError", errorCode);
        return mav;
    }

    private ModelAndView resetViewFromErrors(final BindingResult errors) {
        final ModelAndView mav = new ModelAndView("users/resetPassword", errors.getModel());
        mav.addObject("resetError", null);
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
    public ModelAndView profile(@AuthenticationPrincipal final PawAuthUser authUser,
                                final HttpServletRequest request) {
        final ModelAndView mav = buildProfileMav(authUser, request.getSession(false));
        final UpdatePersonalDataForm form = new UpdatePersonalDataForm();
        form.setUsername(authUser.getUser().getUsername());
        form.setBio(authUser.getUser().getBio());
        mav.addObject("updatePersonalDataForm", form);
        return mav;
    }

    @RequestMapping(value = "/users/me/username", method = RequestMethod.POST)
    public ModelAndView updateUsername(@AuthenticationPrincipal final PawAuthUser authUser,
                                       @Valid @ModelAttribute("updateUsernameForm") final UpdateUsernameForm form,
                                       final BindingResult errors,
                                       final HttpServletRequest request) {
        if (errors.hasErrors()) {
            final ModelAndView mav = buildProfileMav(authUser, request.getSession(false));
            final UpdatePersonalDataForm personalForm = new UpdatePersonalDataForm();
            personalForm.setUsername(authUser.getUser().getUsername());
            personalForm.setBio(authUser.getUser().getBio());
            mav.addObject("updatePersonalDataForm", personalForm);
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
                                           final BindingResult errors,
                                           final HttpServletRequest request) {
        final HttpSession session = request.getSession(true);
        if (errors.hasErrors()) {
            final ModelAndView mav = buildProfileMav(authUser, session);
            mav.addObject("updatePersonalDataForm", form);
            mav.addObject("activeTab", "account");
            return mav;
        }

        final String newUsername = form.getUsername() != null ? form.getUsername().trim() : "";
        final boolean wantsUsernameChange = !newUsername.isEmpty()
                && !newUsername.equals(authUser.getUser().getUsername());

        if (wantsUsernameChange) {
            final Long lastChanged = (Long) session.getAttribute(USERNAME_LAST_CHANGED_ATTR);
            if (lastChanged != null && System.currentTimeMillis() - lastChanged < USERNAME_COOLDOWN_MILLIS) {
                final long remainingSecs = (long) Math.ceil(
                        (USERNAME_COOLDOWN_MILLIS - (System.currentTimeMillis() - lastChanged)) / 1000.0);
                errors.rejectValue("username", "profile.username.cooldown",
                        new Object[]{ remainingSecs }, null);
                final ModelAndView mav = buildProfileMav(authUser, session);
                mav.addObject("updatePersonalDataForm", form);
                mav.addObject("activeTab", "account");
                return mav;
            }
            userService.updateUsername(authUser.getUser().getId(), newUsername);
            session.setAttribute(USERNAME_LAST_CHANGED_ATTR, System.currentTimeMillis());
        }

        if (form.getBio() != null) {
            userService.updateBio(authUser.getUser().getId(), form.getBio());
        }
        authenticateUser(authUser.getUser().getEmail());
        return new ModelAndView("redirect:/users/me");
    }

    private ModelAndView buildProfileMav(final PawAuthUser authUser, final HttpSession session) {
        final long userId = authUser.getUser().getId();
        final ModelAndView mav = new ModelAndView("users/profile");
        mav.addObject("currentUserEmail", authUser.getUser().getEmail());
        mav.addObject("currentUsername", authUser.getUser().getUsername());
        mav.addObject("currentUserImageId", authUser.getUser().getImageId());
        mav.addObject("currentUserBio", authUser.getUser().getBio());
        final List<Production> watchlist = watchlistService.findByUser(userId);
        mav.addObject("watchlist", watchlist);
        mav.addObject("watchlistCount", watchlist.size());
        final List<Review> reviews = reviewService.findByUser(userId);
        mav.addObject("reviews", reviews);
        mav.addObject("reviewsCount", reviews.size());
        mav.addObject("recentReviews", reviewService.findRecentByUser(userId, 3));
        mav.addObject("historialCount", seenService.countByUser(userId));
        final Double avgRating = ratingService.getUserAverageRating(userId).orElse(null);
        mav.addObject("averageRating", avgRating);
        mav.addObject("avgFormatted", avgRating != null ? formatAverage(avgRating) : null);
        mav.addObject("ratingDistribution", ratingService.getUserScoreDistribution(userId));
        mav.addObject("today", LocalDate.now());
        mav.addObject("updateUsernameForm", new UpdateUsernameForm());
        mav.addObject("productionRatings", ratingService.getProductionRatingLabels(collectProductionIds(watchlist)));
        // Username edit cooldown
        if (session != null) {
            final Long lastChanged = (Long) session.getAttribute(USERNAME_LAST_CHANGED_ATTR);
            if (lastChanged != null) {
                final long elapsed = System.currentTimeMillis() - lastChanged;
                if (elapsed < USERNAME_COOLDOWN_MILLIS) {
                    mav.addObject("usernameEditLocked", true);
                    mav.addObject("usernameEditSecondsLeft",
                            (int) Math.ceil((USERNAME_COOLDOWN_MILLIS - elapsed) / 1000.0));
                }
            }
        }
        return mav;
    }

    private String formatAverage(final double avg) {
        final DecimalFormatSymbols symbols = new DecimalFormatSymbols(Locale.ROOT);
        symbols.setDecimalSeparator(',');
        return new DecimalFormat("0.0", symbols).format(avg);
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

        return "/users/me";
    }
}
